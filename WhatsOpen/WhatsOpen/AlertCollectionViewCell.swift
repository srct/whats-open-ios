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
	
	@IBOutlet var containingView: UIView!
	@IBOutlet var containingViewWidth: NSLayoutConstraint!
	var viewWidth: CGFloat!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		isAccessibilityElement = true
		shouldGroupAccessibilityChildren = true
		setNeedsLayout()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if(viewWidth < 640) {
			containingViewWidth.constant = -30
			//cell.containingView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -10)
		}
		else if(viewWidth >= 640 && viewWidth < 1024) {
			containingViewWidth.constant = -100
			//cell.containingView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -100)
		}
		else if(viewWidth >= 1024) {
			containingViewWidth.constant = -300
			//cell.containingView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -150)
		}
		else {
			containingViewWidth.constant = -10
			//cell.containingView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -10)
		}
	}
	
}
