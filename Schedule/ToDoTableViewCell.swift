//
//  ToDoTableViewCell.swift
//  Schedule
//
//  Created by Jkookoo on 2018. 10. 23..
//  Copyright © 2018년 Jkookoo. All rights reserved.
//

import UIKit

class ToDoTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var toDoTitleLabel: UILabel!
}

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var toDoListText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class AddCellTableViewCell: UITableViewCell {
    @IBOutlet weak var addCellButton: UIButton!
    
}
