//
//  AlertDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/12/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

#if os(iOS)
import UIKit

public class WOPAlertDetailViewController: UIViewController {

	@IBOutlet public var imageView: UIImageView!
	@IBOutlet public var nameLabel: UILabel!
	@IBOutlet public var messageView: UITextView!
	public var alert: WOPAlert!
	
	override public func viewDidLoad() {
        super.viewDidLoad()

		switch alert.urgency {
		case "info":
			self.imageView.image = #imageLiteral(resourceName: "info")
			self.nameLabel.text = "Information"
		case "minor":
			self.imageView.image = #imageLiteral(resourceName: "minor")
			self.nameLabel.text = "Minor Alert"
		case "major":
			self.imageView.image = #imageLiteral(resourceName: "major")
			self.nameLabel.text = "Major Alert"
		case "emergency":
			self.imageView.image = #imageLiteral(resourceName: "emergency")
			self.nameLabel.text = "Emergency Alert"
		default:
			self.imageView.image = #imageLiteral(resourceName: "major")
			self.nameLabel.text = "Alert"
		}
		
		if alert.message != "" { // API pre-2.2
			self.messageView.text = alert.message
		} else { // API 2.2+
			let message = NSMutableAttributedString(string: alert.subject, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1).bold()])
			message.append(NSAttributedString(string: "\n\n"))
			message.append(NSAttributedString(string: alert.body, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
			message.append(NSAttributedString(string: "\n\n"))
			message.append(NSAttributedString(string: alert.url, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline).bold()]))
			
			self.messageView.attributedText = message
		}
		        
        // dynamic font sizes
        self.nameLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
    }

	override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// https://spin.atomicobject.com/2018/02/02/swift-scaled-font-bold-italic/
extension UIFont {
	func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
		let descriptor = fontDescriptor.withSymbolicTraits(traits)
		return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
	}
	
	func bold() -> UIFont {
		return withTraits(traits: .traitBold)
	}
	
	func italic() -> UIFont {
		return withTraits(traits: .traitItalic)
	}
}
#endif
