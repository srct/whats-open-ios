//
//  LocationDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {

	@IBOutlet var CurrentStatusLabel: UILabel!
	@IBOutlet var UpcomingStatusLabel: UILabel!
	@IBOutlet var PlaceLabel: UILabel!
	@IBOutlet var TapingoLinkLabel: UILabel!
	
	@IBOutlet var NavBar: UINavigationItem!
	@IBOutlet var OpenTimesList: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func MiddleButton(_ sender: Any) {
	}

	@IBOutlet var TopButton: UIBarButtonItem!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
