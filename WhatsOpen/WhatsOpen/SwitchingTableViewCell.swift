//
//  SwitchingTableViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/29/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit

class SwitchingTableViewCell: UITableViewCell {

	let switchControl = UISwitch()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		switchControl.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
		self.accessoryView = switchControl
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func toggleSwitch(_ sender: Any) {
		print("toggle")
		dump(sender)
		//LocationsListViewController.checkForReload(sander, switchControl.isOn)
	}
	
}
