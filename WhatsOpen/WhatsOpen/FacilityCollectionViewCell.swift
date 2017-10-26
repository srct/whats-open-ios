//
//  SRCTSimpleCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/20/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import QuartzCore

class FacilityCollectionViewCell: UICollectionViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var timeDescriptionLabel: UILabel!
	@IBOutlet var openClosedLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    var facility: Facility!
	internal let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
	
	override func awakeFromNib() {
		super.awakeFromNib()
	
		self.layer.cornerRadius = 8
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.clear.cgColor

		/*
		self.layer.shadowColor = UIColor.darkGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowRadius = 3.0
		self.layer.shadowOpacity = 1.0
		self.layer.masksToBounds = false
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
		*/

		openClosedLabel.layer.cornerRadius = 12
		openClosedLabel.layer.masksToBounds = true
		
		isAccessibilityElement = true
		shouldGroupAccessibilityChildren = true
		
		// Initialization code
	}
}
