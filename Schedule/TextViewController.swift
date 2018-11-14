//
//  TextViewController.swift
//  Schedule
//
//  Created by Jkookoo on 2018. 11. 13..
//  Copyright © 2018년 Jkookoo. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextFieldDelegate {
    var selectedDate: Int?
    var cellRow: Int?
    var text: String?
    @IBOutlet weak var toDoTexField: UITextField!
    
    @IBAction func touchUpCompleteButton(_ sender: UIButton) {
        saveTextField()
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func saveTextField() {
        let mainView = self.presentingViewController as? ViewController
        mainView?.paramText = self.toDoTexField.text
        mainView?.paraDate = self.selectedDate
        mainView?.paraCellRow = self.cellRow
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toDoTexField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = self.text {
            self.toDoTexField.text = text
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
