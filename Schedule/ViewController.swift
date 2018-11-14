//
//  ViewController.swift
//  Schedule
//
//  Created by Jkookoo on 2018. 10. 23..
//  Copyright © 2018년 Jkookoo. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource  {
    
    var selectedDate: Int = 0
    var boolForCheckBoxButton = [Int:[Bool]]() {
        didSet {
            let checkData = NSKeyedArchiver.archivedData(withRootObject: boolForCheckBoxButton)
            UserDefaults.standard.set(checkData, forKey: "boolForCheckBoxButton")
            UserDefaults.standard.synchronize()
        }
    }
    var toDoLists = [Int:[String]]() {
        didSet {
            let textData = NSKeyedArchiver.archivedData(withRootObject: toDoLists)
            UserDefaults.standard.set(textData, forKey: "toDoLists")
            UserDefaults.standard.synchronize()
        }
    }
    var paramText: String?
    var paraDate: Int?
    var paraCellRow: Int?
    
    let titleCellIdentifier: String = "titleCell"
    let listCellIdentifier: String = "listCell"
    let cellForAddIdentifier: String = "addCell"
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        addList()
    }
    
    @IBAction func touchUpCheckBoxButton(_ sender: UIButton) {
        checkBoxAndSave(checkBox: sender)
    }
    
    
    func addList() {
        if toDoLists[selectedDate] == nil {
            toDoLists.updateValue([""], forKey: selectedDate)
            boolForCheckBoxButton.updateValue([false], forKey: selectedDate)
        } else {
            toDoLists[selectedDate]?.append("")
            boolForCheckBoxButton[selectedDate]?.append(false)
        }
        self.tableView.reloadData()
    }
    
    func checkBoxAndSave(checkBox: UIButton) {
        //강제 캐스팅 수정
        boolForCheckBoxButton[selectedDate]![checkBox.tag] = !boolForCheckBoxButton[selectedDate]![checkBox.tag]
        
        tableView.reloadData()
    }
    
    func loadSavedData() {
        if let textData = UserDefaults.standard.object(forKey: "toDoLists") as? Data  {
            if let textDictionary = NSKeyedUnarchiver.unarchiveObject(with: textData) as? [Int:[String]] {
                toDoLists = textDictionary
            }
        }
        
        if let checkData = UserDefaults.standard.object(forKey: "boolForCheckBoxButton") as? Data {
            if let boolDictionary = NSKeyedUnarchiver.unarchiveObject(with: checkData) as? [Int:[Bool]] {
                boolForCheckBoxButton = boolDictionary
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        if let dateToInt = Int(dateFormatter.string(from: date)) {
            selectedDate = dateToInt
            print(dateToInt)
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int
        switch section {
        case 0:
            count = 1
        case 1:
            guard let toDoLists = toDoLists[selectedDate] else {
                return 0
            }
            count = toDoLists.count
        case 2:
            count = 1
        default:
            count = 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoLists[selectedDate]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0 {
            guard let titleCell: ToDoTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: titleCellIdentifier, for: indexPath) as? ToDoTitleTableViewCell else {
                return UITableViewCell()
            }
            titleCell.toDoTitleLabel.text = "#ToDo"
            cell = titleCell
        } else if indexPath.section == 1 {
            guard let listCell: ToDoTableViewCell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier, for: indexPath) as? ToDoTableViewCell else {
                return UITableViewCell()
            }
            if let toDoList = toDoLists[selectedDate], let boolForCheckBoxButton = boolForCheckBoxButton[selectedDate] {
                listCell.toDoListText.text = toDoList[indexPath.row]
                listCell.checkBoxButton.tag = indexPath.row
                listCell.toDoListText.tag = indexPath.row
                
                if boolForCheckBoxButton[indexPath.row] {
                    listCell.checkBoxButton.setImage(UIImage(named: "checkBox"), for: .normal)
                    
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: toDoList[indexPath.row])
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    listCell.toDoListText.attributedText = attributeString

                } else {
                    listCell.checkBoxButton.setImage(UIImage(named: "emptyBox"), for: .normal)
                }
            }
            
            cell = listCell
        } else if indexPath.section == 2 {
            guard let cellForAdd: AddCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellForAddIdentifier, for: indexPath) as? AddCellTableViewCell else {
                return UITableViewCell()
            }
            
            cell = cellForAdd
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let text = paramText, let date = paraDate, let cellRow = paraCellRow {
            toDoLists[date]![cellRow] = text
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        if let today = Int(dateFormatter.string(from: date)) {
            selectedDate = today
        }
        
        loadSavedData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let textCell: ToDoTableViewCell = sender as? ToDoTableViewCell else {
            return
        }
        guard let textViewController: TextViewController = segue.destination as? TextViewController else {
            return
        }
        
        textViewController.selectedDate = self.selectedDate
        textViewController.cellRow = textCell.toDoListText.tag
        if let text = textCell.toDoListText.text {
            textViewController.text = text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

