//
//  SRCTSimpleCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/20/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit

class SRCTSimpleCollectionViewCell: UICollectionViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var timeDescriptionLabel: UILabel!
	@IBOutlet var openClosedLabel: UILabel!
	var facility: Facility!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.layer.cornerRadius = 10
		// Initialization code
	}
}
