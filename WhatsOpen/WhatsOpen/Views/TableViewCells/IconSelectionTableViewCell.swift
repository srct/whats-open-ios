//
//  IconSelectionTableViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/6/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit

class IconSelectionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
		iconThumbnail.layer.cornerRadius = 10
		iconThumbnail.layer.masksToBounds = true
        // Initialization code
    }
	@IBOutlet var iconThumbnail: UIImageView!
	@IBOutlet var iconName: UILabel!
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		if(selected) {
			super.setSelected(false, animated: animated)
		}
        // Configure the view for the selected state
    }

}
