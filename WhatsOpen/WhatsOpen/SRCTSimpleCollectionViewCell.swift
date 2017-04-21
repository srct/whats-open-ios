//
//  SRCTSimpleCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/20/17.
//  Copyright © 2017 Patrick Murray. All rights reserved.
//

import UIKit

class SRCTSimpleCollectionViewCell: UICollectionViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var timeDescriptionLabel: UILabel!
	@IBOutlet var openClosedLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
}
