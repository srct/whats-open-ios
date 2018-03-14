//
//  AlertCollectionViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/4/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit

class AlertCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var messageLabel: UILabel!
	var alert: Alert!
	internal let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

	
	var viewWidth: CGFloat!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		isAccessibilityElement = true
		shouldGroupAccessibilityChildren = true
		setNeedsLayout()
	}
	
}
