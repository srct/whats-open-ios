//
//  LocationsListViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import DeckTransition
import RealmSwift

//Realm Model
class FacilitiesModel: Object {
	var facilities = List<Facility>()
	var alerts = List<Alert>()
	@objc dynamic var lastUpdated = Date()
	@objc dynamic let id = 0
}


class FacilitiesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate {

	let realm = try! Realm()

	var facilitiesArray = List<Facility>()
	var alertsList = List<Alert>()
    
    // array of facilities that pass the current filters
    var filteredFacilities = List<Facility>()
	
	// List which actually pertains to what is shown
	var shownFacilities = List<Facility>()
    
    // passing in nil sets the search controller to be this controller
    let searchController = UISearchController(searchResultsController: nil)

	var filters = Filters()
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	@IBOutlet var LeftButton: UIBarButtonItem!

	@IBAction func RightButton(_ sender: Any) {
	}
	@IBOutlet var RightButton: UIBarButtonItem!
	
	@IBOutlet var settingsButton: UIBarButtonItem!
	
	@IBOutlet var LocationsList: UICollectionView!

	@IBOutlet var LocationsListLayout: UICollectionViewFlowLayout!

	@IBOutlet var favoritesControl: UISegmentedControl!
	var showFavorites = false

	@IBOutlet var LastUpdatedLabel: UIBarButtonItem!
    
    let refreshControl = UIRefreshControl()

	@IBAction func favoritesControlChanges(_ sender: Any) {
		switch self.favoritesControl.selectedSegmentIndex
		{
		case 0:
			showFavorites = false
			shownFacilities = filteredFacilities
		case 1:
            showFavorites = true
			shownFacilities = filterFacilitiesForFavorites()
		default:
			showFavorites = false
			shownFacilities = filteredFacilities
		}
		self.LocationsList.reloadData()
	}
    
    /**
     Get all of the facilities that are favorited.
     
     - returns:
        List of facilities that are favorited
     */
    func filterFacilitiesForFavorites() -> List<Facility> {
        var favoriteFacilites = List<Facility>()
        
        // add the facility to favorites list if it is a favorite
        favoriteFacilites = filteredFacilities.filter({ (facility: Facility) -> Bool in
            return Utilities.isFavoriteFacility(facility)
        })
        
        return favoriteFacilites
    }

	override func viewWillLayoutSubviews() {
		LocationsListLayout.itemSize.width = getCellWidth()
		LocationsListLayout.invalidateLayout()
	}
	
	func getCellWidth() -> CGFloat {
		let windowWidth = self.view.frame.size.width
		
		if(windowWidth < 640) {
			return windowWidth - 20
		}
		else if(windowWidth >= 640 && windowWidth < 1024) {
			return (windowWidth / 2) - 15
		}
		else if(windowWidth >= 1024) {
			return (windowWidth / 3) - 15
		}
		
		return 0
	}

	@IBAction func RefreshButton(_ sender: Any) {
		refresh(sender, forceUpdate: true)
	}
	
	func checkFilterState() {
		if(filters.showOpen && filters.showClosed && filters.openFirst && filters.sortBy == SortMethod.alphabetical) {
			for f in filters.onlyFromCategories {
				if(f.value != true) {
					LeftButton.title = "Filter (On)"
					return
				}
			}
			for f in filters.onlyFromLocations {
				if(f.value != true) {
					LeftButton.title = "Filter (On)"
					return
				}
			}
			LeftButton.title = "Filter"
			return
		}
		LeftButton.title = "Filter (On)"
	}

	override func viewWillAppear(_ animated: Bool) {
		LastUpdatedLabel.isEnabled = false
		checkFilterState()
		reloadWithFilters()
	}
	
	@objc func tapRecognizer(_ sender: UITapGestureRecognizer) {
		
		let tapLocation = sender.location(in: LocationsList)
		let indexPath = LocationsList.indexPathForItem(at: tapLocation)
        
		if((indexPath) != nil) {
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as? FacilityDetailViewController
            let tapped = self.LocationsList.cellForItem(at: indexPath!) as! FacilityCollectionViewCell
            destination!.facility = tapped.facility
            self.presentDetailView(destination!)
		}
	}
	
	func presentDetailView(_ destination: FacilityDetailViewController) {
		if(self.view.traitCollection.horizontalSizeClass == .regular && self.view.traitCollection.verticalSizeClass == .regular) {
			//do a popover here for the iPad
			//iPads are cool right?
			destination.modalPresentationStyle = .popover
			let popoverController = destination.popoverPresentationController
			popoverController?.permittedArrowDirections = .any
			popoverController?.sourceView = destination.view
            
            // present the detail view over the search controller if we're searching
            if searchController.isActive {
                searchController.present(destination, animated: true, completion: nil)
            }
            else {
                present(destination, animated: true, completion: nil)
            }
		}
		else {
			let destDelegate = DeckTransitioningDelegate()
			destination.modalPresentationStyle = .custom
			destination.transitioningDelegate = destDelegate
            
            // present the detail view over the search controller if we're searching
            if searchController.isActive {
                searchController.present(destination, animated: true, completion: nil)
            }
            else {
                present(destination, animated: true, completion: nil)
            }
		}
        
        
	}
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // add it to the navigationItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.definesPresentationContext = true
		
		if(traitCollection.forceTouchCapability == .available) {
			registerForPreviewing(with: self, sourceView: self.LocationsList!)
		}
        
        navigationItem.title = "What's Open"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		
        configureSearchController()
		
		LocationsListLayout.invalidateLayout()
		
		settingsButton.accessibilityLabel = "Settings"
		LastUpdatedLabel.accessibilityHint = ""
		
		LocationsListLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)

		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		LocationsList.refreshControl = refreshControl
		LocationsList.alwaysBounceVertical = true

		
		/*
		let defaults = UserDefaults.standard
		let facilitiesFromDefaults = defaults.object(forKey: "FacilitiesList") as! List<Facility>?
	  	let lastUpdatedList = defaults.object(forKey: "lastUpdatedList") as! Date?
		if(facilitiesFromDefaults == nil || lastUpdatedList == nil) {
			refresh(self)
		}
		else if(lastUpdatedList! < Date(timeIntervalSinceNow: -86400.0)) {
			refresh(self)
		}
		else {
			facilitiesArray = facilitiesFromDefaults!
		}
		*/
		
		refresh(self, forceUpdate: false)
		

		
		reloadWithFilters()
		
		
	}
	
	func reloadWithFilters() {
		filteredFacilities = filters.applyFiltersOnFacilities(facilitiesArray)
		shownFacilities = filteredFacilities
		favoritesControlChanges(self)
		LocationsList.reloadData()
	}
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    /**
     Filters facilities based on the text inputted into the search controller.
     
     - parameters:
        - searchText: text used to filter the facilities.
     - returns:
        List of filtered facilities. Facilities whose names, buildings, or categories match the search text are included.
     */
    func filterFacilitiesForSearchText(_ searchText: String) -> List<Facility> {
        var filtered: List<Facility>
		
		/*
        if showFavorites {
            let favoriteFacilities = filterFacilitiesForFavorites()
            
            if searchText == "" { // if the search text is empty, just return the favorites.
                filtered = favoriteFacilities
            } else {
                filtered = favoriteFacilities.filter({(facility: Facility) -> Bool in
                    let hasName = facility.facilityName.lowercased().contains(searchText.lowercased())
                    let hasBuilding = facility.facilityLocation?.building.lowercased().contains(searchText.lowercased()) ?? false
                    let hasCategory = facility.category?.categoryName.lowercased().contains(searchText.lowercased()) ?? false
                    
                    return hasName || hasBuilding || hasCategory
                })
            }

        } else {
		  */
		if searchText == "" {
			filtered = shownFacilities
			LocationsList.reloadData()
			return shownFacilities
		}
		filtered = filteredFacilities.filter({(facility: Facility) -> Bool in
			let hasName = facility.facilityName.lowercased().contains(searchText.lowercased())
			let hasBuilding = facility.facilityLocation?.building.lowercased().contains(searchText.lowercased()) ?? false
			let hasCategory = facility.category?.categoryName.lowercased().contains(searchText.lowercased()) ?? false
			
			return hasName || hasBuilding || hasCategory
		})
        
        LocationsList.reloadData()
        return filtered
    }
	
	/*
	* Reloads data, either calling update() to attempt a download
	* or simply pulling from the realm
	*/
	func refresh(_ sender: Any, forceUpdate: Bool = true) {
		refreshControl.beginRefreshing()
		if(forceUpdate) {
			update(sender);
		}
		else {
			let results = realm.objects(FacilitiesModel.self)
			if results.count > 0 {
				let model = results[0]
				let facilities = model.facilities
				let lastUpdated = model.lastUpdated
				
				if(facilities.isEmpty || lastUpdated < Date(timeIntervalSinceNow: -86400.0)) {
					update(sender)
				}
				else {
					facilitiesArray = facilities
					self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(lastUpdated)
				}
			}
			else {
				update(sender)
			}

		}
		reloadWithFilters()
		
		// Add locations and categories to filters
		for f in facilitiesArray {
			if(!filters.onlyFromCategories.keys.contains((f.category?.categoryName)!)) {
				filters.onlyFromCategories.updateValue(true, forKey: (f.category?.categoryName)!)
			}
			if(!filters.onlyFromLocations.keys.contains((f.facilityLocation?.building)!)) {
				filters.onlyFromLocations.updateValue(true, forKey: (f.facilityLocation?.building)!)
			}
		}
		refreshControl.endRefreshing()
	}
	
	/*
	* Attempts to update facilitiesArray from the network
	* and place that new information into Realm
	*/
	func update(_ sender: Any) {
		SRCTNetworkController.performDownload { (facilities) in
			if(facilities == nil) {
				DispatchQueue.main.async {
					let results = self.realm.objects(FacilitiesModel.self)
					if results.count > 0 {
						let model = results[0]
						let facilitiesFromDB = model.facilities
						let lastUpdated = model.lastUpdated
						
						self.facilitiesArray = facilitiesFromDB
						self.reloadWithFilters()
						self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(lastUpdated)
					}
					else {
						self.facilitiesArray = List<Facility>()
					}
				}
			}
			else {
				self.facilitiesArray = facilities!
				
				DispatchQueue.main.async {
					//let defaults = UserDefaults.standard
					//defaults.set(facilities, forKey: "FacilitiesList")
					let date = Date()
					//defaults.set(date, forKey: "lastUpdatedList")
					self.reloadWithFilters()
					self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(date)
					let model = FacilitiesModel()
					model.facilities = facilities!
					model.lastUpdated = date
					let results = self.realm.objects(FacilitiesModel.self)
					if results.count == 0 {
						try! self.realm.write {
							self.realm.add(model)
						}
					}
					else {
						let fromRealm = results[0]
						try! self.realm.write {
							fromRealm.facilities = model.facilities
							fromRealm.lastUpdated = model.lastUpdated
						}
					}
				}
			}
		}
		SRCTNetworkController.performAlertsDownload { (alerts) in
			if(alerts == nil) {
				DispatchQueue.main.async {
					let results = self.realm.objects(FacilitiesModel.self)
					if results.count > 0 {
						let model = results[0]
						let alertsFromDB = model.alerts
						
						self.alertsList = alertsFromDB
					}
					else {
						self.alertsList = List<Alert>()
					}
				}
			}
			else {
				self.alertsList = alerts!
				
				DispatchQueue.main.async {
					let model = FacilitiesModel()
					model.alerts = alerts!
					let results = self.realm.objects(FacilitiesModel.self)
					if results.count == 0 {
						try! self.realm.write {
							self.realm.add(model)
						}
					}
					else {
						let fromRealm = results[0]
						try! self.realm.write {
							fromRealm.alerts = model.alerts
						}
					}
				}
			}
		}
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
		if alertsList.count > 0 {
			return 2
		}
		else {
			return 1
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if(section == 1 || alertsList.count == 0) {
			return shownFacilities.count
		}
		else {
			// TODO: get current alerts, not just any alerts
			return alertsList.count
		}
		
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if (indexPath.section == 1 || alertsList.count == 0) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! FacilityCollectionViewCell
			/*
			let windowRect = self.view.window!.frame
			let windowWidth = windowRect.size.width
			if(windowWidth <= 320) {
			cell.frame.size.width = 280
			}
			*/
			//Get tap of the cell
			cell.tapRecognizer.addTarget(self, action: #selector(FacilitiesListViewController.tapRecognizer(_:)))
			cell.gestureRecognizers = []
			cell.gestureRecognizers?.append(cell.tapRecognizer)
			
			
			let facility: Facility
			//let dataArray: [Facility]
			
			/*
			// if something has been searched for, we want to use the filtered array as the data source
			if isSearching() || showFavorites {
			dataArray = placeOpenFacilitiesFirstInArray(filteredFacilities)
			} else {
			dataArray = placeOpenFacilitiesFirstInArray(facilitiesArray)
			}
			*/
			
			
			
			facility = shownFacilities[indexPath.row]
			
			cell.facility = facility
			
			//set labels
			cell.nameLabel.text = facility.facilityName
			cell.categoryLabel.text = facility.category?.categoryName.uppercased()
			
			cell.openClosedLabel.text = Utilities.openOrClosedUntil(facility)
			
			cell.timeDescriptionLabel.text = facility.facilityLocation?.building
			
			//change appearence based on open state
			let open = Utilities.isOpen(facility: facility)
			if(open == true) {
				//cell.openClosedLabel.text = "Open"
				cell.openClosedLabel.textColor = UIColor.black
				cell.openClosedLabel.backgroundColor = UIColor.white
				//cell.openClosedLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
				cell.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
			} else {
				//cell.openClosedLabel.text = "Closed"
				cell.openClosedLabel.textColor = UIColor.white
				cell.openClosedLabel.backgroundColor = UIColor.black
				//cell.openClosedLabel.backgroundColor = UIColor.red
				cell.backgroundColor = UIColor.red
				
			}
			
			//Accessibility
			//TODO: FIX THIS
			cell.accessibilityLabel = cell.nameLabel.text! + ", Currently " + cell.openClosedLabel.text! + "." + cell.timeDescriptionLabel.text!
			cell.accessibilityHint = "Double Tap to view details"
			
			
			self.reloadInputViews()
			return cell
		}
		else {
			// Do Alerts things here
			return UICollectionViewCell() //This is bad
		}

	}

	
	//unused
	func getLocationArray(_ facilitiesArray: List<Facility>) -> [Facility] {
		if(!showFavorites) {
			return placeOpenFacilitiesFirstInArray(facilitiesArray)
		}
		else {
			return placeOpenFacilitiesFirstInArray(filteredFacilities)
		}


	}
	
	//unused
	// Returns an array which has the open locations listed first
	// Could be improved in the future because currently this means you're checking
	// open status twice per cell
	func placeOpenFacilitiesFirstInArray(_ facilitiesArray: List<Facility>) -> [Facility] {
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

	//unused
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
            let destination = segue.destination as! FacilityDetailViewController
            let destDelegate = DeckTransitioningDelegate()
            destination.transitioningDelegate = destDelegate
            let tapped = sender as! FacilityCollectionViewCell //this is probably a bad idea just FYI future me
            destination.facility = tapped.facility

            // if we're in the search view, present on its controller
            if searchController.isActive {
                searchController.present(destination, animated: true, completion: nil)
            } else {
                present(destination, animated: true, completion: nil)
            }
        }
        else if(segue.identifier == "toFilters") {
            let destination = segue.destination as! UINavigationController
            let filterView = destination.topViewController as! FiltersTableViewController
			filterView.facilities = self.facilitiesArray
            filterView.filters = self.filters
        }

        // Pass the selected object to the new view controller.
    }
	
	// MARK: - Peek and Pop
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let indexPath = LocationsList?.indexPathForItem(at: location) else { return nil }
		let cell = LocationsList?.cellForItem(at: indexPath) as! FacilityCollectionViewCell
		guard let detailView = storyboard?.instantiateViewController(withIdentifier: "detailView") as? FacilityDetailViewController else { return nil }
		
		detailView.facility = cell.facility

		return detailView
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		let destDelegate = DeckTransitioningDelegate()
		viewControllerToCommit.modalPresentationStyle = .custom
		viewControllerToCommit.transitioningDelegate = destDelegate
		//If one day 3D touch comes to the iPad, this is no longer good.
		present(viewControllerToCommit, animated: true, completion: nil)
	}
	
}

// by implementing UISearchResultsUpdating, we can use this controller for the search controller
extension FacilitiesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        shownFacilities = filterFacilitiesForSearchText(searchText)
    }
}



