//
//  AlertDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/12/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit

class AlertDetailViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var messageView: UITextView!
	var alert: Alert!
	
	override func viewDidLoad() {
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
		self.messageView.text = alert.message
        // Do any additional setup after loading the view.
        
        // dynamic font sizes
        self.nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        self.messageView.font = UIFont.preferredFont(forTextStyle: .body)
    }

    override func didReceiveMemoryWarning() {
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
