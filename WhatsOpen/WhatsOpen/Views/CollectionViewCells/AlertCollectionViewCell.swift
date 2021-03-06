//
//  AlertCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/4/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit
import WhatsOpenKit

class AlertCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var messageLabel: UILabel!
	var alert: WOPAlert!
	internal let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

	
	var viewWidth: CGFloat!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		isAccessibilityElement = true
		shouldGroupAccessibilityChildren = true
		setNeedsLayout()
	}
	
}
