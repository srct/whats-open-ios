//
//  SettingTableViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 7/26/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit
import MessageUI

class SettingTableViewCell: UITableViewCell {

	var linkURL: URL?
	
	func initMail(subject: String, to: String) -> MFMailComposeViewController {
		let mailto = MFMailComposeViewController()
		mailto.setSubject(subject)
		mailto.setToRecipients([to])
		let df = DateFormatter()
		let now = Date()
		mailto.setMessageBody("\n\n"+df.string(from: now), isHTML: false)
		return mailto
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		if(selected) {
			super.setSelected(false, animated: animated)
		}
		// Configure the view for the selected state
    }

}
