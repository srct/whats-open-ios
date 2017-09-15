//
//  SRCTSimpleCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/20/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit

class FacilityCollectionViewCell: UICollectionViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var timeDescriptionLabel: UILabel!
	@IBOutlet var openClosedLabel: UILabel!
	var facility: Facility!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	
		isAccessibilityElement = true
		shouldGroupAccessibilityChildren = true
		
		self.layer.cornerRadius = 8
		// Initialization code
	}
}
