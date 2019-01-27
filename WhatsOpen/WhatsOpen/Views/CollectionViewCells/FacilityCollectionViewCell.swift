//
//  SRCTSimpleCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/20/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import QuartzCore
import WhatsOpenKit

class FacilityCollectionViewCell: UICollectionViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var timeDescriptionLabel: UILabel!
	@IBOutlet var openClosedLabel: WOPPaddedUILabel!
    @IBOutlet var categoryLabel: UILabel!
    var facility: WOPFacility!
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
		
		tapRecognizer.cancelsTouchesInView = true
		
		// Initialization code
	}

	// Animations - modified based on this: https://stackoverflow.com/questions/35236271/make-a-collectionviewcell-bounce-on-highlight-in-swift#35236995
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		UIView.animate(withDuration: 0.2) { () -> Void in
			let shrinkTransform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
			self.transform = shrinkTransform
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesEnded(touches, with: event)
		UIView.animate(withDuration: 0.3) { () -> Void in
			self.transform = .identity
		}
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		UIView.animate(withDuration: 0.3) { () -> Void in
			self.transform = .identity
		}
	}
	
}
