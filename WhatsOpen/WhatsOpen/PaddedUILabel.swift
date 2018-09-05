//
//  PaddedUILabel.swift
//  WhatsOpen
//
//  Created by Zach Knox on 11/11/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit


// Based on this
// https://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accommodate-insets/21267507#21267507
// The entire reason for this subclass of UILabel is for the openClosedLabel in FacilityCollectionViewCell
class PaddedUILabel: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
}

@IBDesignable
extension PaddedUILabel {
    
    // currently UIEdgeInsets is no supported IBDesignable type,
    // so we have to fan it out here:
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
}
