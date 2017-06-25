//
//  LocationsListViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	var facilitiesArray = Array<Facility>()
	var filters = Filters()
	
	@IBOutlet var LeftButton: UIBarButtonItem!
		
	@IBAction func RightButton(_ sender: Any) {
	}
	@IBOutlet var RightButton: UIBarButtonItem!
	
	@IBOutlet var LocationsList: UICollectionView!
	
	@IBOutlet var LocationsListLayout: UICollectionViewFlowLayout!
	
	@IBOutlet var favoritesControl: UISegmentedControl!
	var showFavorites = false

	@IBOutlet var LastUpdatedLabel: UIBarButtonItem!
	
	@IBAction func favoritesControlChanges(_ sender: Any) {
		switch (self.favoritesControl.selectedSegmentIndex)
		{
		case 0:
			showFavorites = false
		case 1:
			showFavorites = true
		default:
			showFavorites = false
		}
		self.LocationsList.reloadData()
	}
	
	let refreshControl = UIRefreshControl()
	
	override func viewWillLayoutSubviews() {
		let windowWidth = self.view.frame.size.width
		
		if(windowWidth > 320 && windowWidth < 640) {
			LocationsListLayout.itemSize.width = windowWidth - 20
		}
		else if(windowWidth >= 640 && windowWidth < 1024) {
			LocationsListLayout.itemSize.width = (windowWidth / 2) - 15
		}
		else if(windowWidth >= 1024) {
			LocationsListLayout.itemSize.width = (windowWidth / 3) - 15
		}
		
		LocationsListLayout.invalidateLayout()
		
	}
	
	@IBAction func RefreshButton(_ sender: Any) {
		refresh(sender)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		LastUpdatedLabel.isEnabled = false
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		LocationsListLayout.invalidateLayout()
		
		LocationsListLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		LocationsList.addSubview(refreshControl)
		LocationsList.alwaysBounceVertical = true
		
		
		SRCTNetworkController.performDownload { (facilities) in
			self.facilitiesArray = facilities
			//            print(self.facilitiesArray)
			DispatchQueue.main.async {
				self.LocationsList.reloadData()
				let date = Date()
				self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(date)
			}
		}
    }
	
	func refresh(_ sender: Any) {
		refreshControl.beginRefreshing()
		LocationsList.reloadData()
		let date = Date()
		LastUpdatedLabel.title = "Updated: " + shortDateFormat(date)
		refreshControl.endRefreshing()
	}
	func shortDateFormat(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short

		// US English Locale (en_US)
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: date)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = countForOpenAndClosedFacilities(getLocationArray(facilitiesArray)) //TODO could be better optimized
		
		if(section == 1) {
			return count.open
		}
		else {
			return count.closed
		}
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! SRCTSimpleCollectionViewCell
		/*
		let windowRect = self.view.window!.frame
		let windowWidth = windowRect.size.width
		if(windowWidth <= 320) {
			cell.frame.size.width = 280
		}
		*/
		
		let dataArray = placeOpenFacilitiesFirstInArray(facilitiesArray)
		let facility = dataArray[indexPath.row]
		cell.facility = facility
		cell.nameLabel.text = facility.name
		
		let open = Utilities.isOpen(facility: facility)
		if(open == true) {
			cell.openClosedLabel.text = "Open"
			cell.openClosedLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		} else {
			cell.openClosedLabel.text = "Closed"
			cell.openClosedLabel.backgroundColor = UIColor.red
		}
		
		cell.timeDescriptionLabel.text = Utilities.timeUntilFacility(facility)
		
		self.reloadInputViews()
		return cell
	}
	
	func getLocationArray(_ facilitiesArray: [Facility]) -> [Facility] {
		if(!showFavorites) {
			return placeOpenFacilitiesFirstInArray(facilitiesArray)
		}
		else {
			return [] //TODO - INCOMPLETE
		}
		
		
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
	
	
    // MARK: - Navigation

	//In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
		if(segue.identifier == "toDetailView") {
			let destination = segue.destination as! LocationDetailViewController
			let tapped = sender as! SRCTSimpleCollectionViewCell //this is probably a bad idea just FYI future me
			destination.facility = tapped.facility
			
		}
		else if(segue.identifier == "toFilters") {
			let destination = segue.destination as! UINavigationController
			let filterView = destination.topViewController as! FiltersTableViewController
			filterView.filters = self.filters
		}
		
        // Pass the selected object to the new view controller.
    }
	
}

