//
//  LocationsListViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 Patrick Murray. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	var facilitiesArray = Array<Facility>()
	
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
		let layout = UICollectionViewFlowLayout()
		
		LocationsList = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
		
		LocationsList.dataSource = self
		LocationsList.delegate = self
		self.view.addSubview(LocationsList)
		
		
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
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = countForOpenAndClosedFacilities(facilitiesArray)
		if(section == 1) {
			return count.open
		}
		else {
			return count.closed
		}
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SRCTSimpleCollectionViewCell
		//REMINDER TO ME THIS DOESNT EXIST YET PLEASE MAKE IT K THX -zmknox
		
		let dataArray = placeOpenFacilitiesFirstInArray(facilitiesArray)
		let facility = dataArray[indexPath.row]
		cell.nameLabel.text = facility.name
		let open = Utilities.isOpen(facility: facility);
		if(open == true){
			cell.openClosedLabel.text = "Open"
			cell.openClosedLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		}else{
			cell.openClosedLabel.text = "Closed"
			cell.openClosedLabel.backgroundColor = UIColor.red
		}
		
		cell.timeDescriptionLabel.text = Utilities.timeUntilFacility(facility)
		
		self.reloadInputViews()
		return cell
	}
	
	//Returns an array which has the open locations listed first
	//Could be improved in the future because currently this means you're checking
	//open status twice per cell
	func placeOpenFacilitiesFirstInArray(_ facilitiesArray: Array<Facility>) -> [Facility] {
		var open = [Facility]()
		var closed = [Facility]()
		
		for i in facilitiesArray {
			if(Utilities.isOpen(facility: i)) {
				open.append(i)
			}
			else {
				closed.append(i)
			}
		}
		// Test
		return open + closed
	}
	
	func countForOpenAndClosedFacilities(_ facilitiesArray: Array<Facility>) -> (open: Int, closed: Int) {
		var open = 0
		var closed = 0
		
		for i in facilitiesArray {
			if(Utilities.isOpen(facility: i)) {
				open += 1
			}
			else {
				closed += 1
			}
		}
		
		return (open, closed)
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

