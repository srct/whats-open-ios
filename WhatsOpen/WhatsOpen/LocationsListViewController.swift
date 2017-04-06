//
//  LocationsListViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 Patrick Murray. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {

	@IBAction func LeftButton(_ sender: Any) {
	}
	@IBOutlet var LeftButton: UIBarButtonItem!
	
	
	@IBAction func RightButton(_ sender: Any) {
	}
	@IBOutlet var RightButton: UIBarButtonItem!
	
	@IBOutlet var LocationsList: UICollectionView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		

        // Do any additional setup after loading the view.
		
		//Yes I could just run the code inside these in here
		//I want to be both more modular and more organized
		setupDataSourceForList(LocationsList)
		setupDelegateForList(LocationsList)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupDataSourceForList(_ list: UICollectionView) {
		var dataSource = list.dataSource
	}
	
	func setupDelegateForList(_ list: UICollectionView) {
		var delegate = list.delegate
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
