//
//  HUDViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 2/6/19.
//  Copyright © 2019 SRCT. All rights reserved.
//

import UIKit

class HUDViewController: UIViewController {

	@IBOutlet var image: UIImageView!
	@IBOutlet var label: UILabel!
	@IBOutlet var hudBox: UIVisualEffectView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		image.tintColor = .red
		label.textColor = .black
		
		hudBox.clipsToBounds = true
		hudBox.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}