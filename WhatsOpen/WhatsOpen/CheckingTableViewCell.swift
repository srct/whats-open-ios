//
//  CheckingTableViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 5/25/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit

class CheckingTableViewCell: UITableViewCell {

	var onlyOne: OnlyOneChecked!
	var cellIndex: Int!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		if(selected) {
			onlyOne.setCheckToCellWithID(cellIndex)
			super.setSelected(false, animated: animated)
		}
        // Configure the view for the selected state
    }

	
}

class OnlyOneChecked {
	
	var view: FiltersTableViewController
	var cellChecked: Int //if -1, no cell is checked.
	
	init(tableView: FiltersTableViewController, tableCellChecked: Int) {
		self.view = tableView
		self.cellChecked = tableCellChecked
	}
	
	func setCheckToCellWithID(_ id: Int) {
		for cell in view.sortOptions {
			if(id == cell.cellIndex) {
				cell.accessoryType = UITableViewCellAccessoryType.checkmark
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryType.none
			}
		}
		
		//also do something here to update the filters object in view
	}
	
}
