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
	let facilities = List<Facility>()
	let alerts = List<Alert>()
	@objc dynamic var lastUpdated = Date()
	@objc dynamic let id = 0
}


class FacilitiesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate, UICollectionViewDelegateFlowLayout {

	// Tell Realm to use this new configuration object for the default Realm
	let realm = try! Realm(configuration: Realm.Configuration(
		// Set the new schema version. This must be greater than the previously used
		// version (if you've never set a schema version before, the version is 0).
		schemaVersion: 3,
		// We replace the data stored every 12 hours, do we _really_ need to worry about schema updates?
		// I say nay.
		deleteRealmIfMigrationNeeded: true
	  ))

	var facilitiesArray = List<Facility>()
	var alertsList = List<Alert>()
	
	var currentAlerts = List<Alert>()
    
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
		//LocationsListLayout.itemSize.width = getCellWidth()
		LocationsListLayout.invalidateLayout()
		LocationsList.reloadData()
	}
	
	/*
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
	*/

	@IBAction func RefreshButton(_ sender: Any) {
		refresh(sender, forceUpdate: true)
		reloadWithFilters()
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
			for f in filters.onlyFromCampuses {
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
		
		if(indexPath != nil) {
			if(indexPath?.section == 1 || currentAlerts.count == 0) {
				let destination =  self.storyboard?.instantiateViewController(withIdentifier: "detailView") as? FacilityDetailViewController
				let tapped = self.LocationsList.cellForItem(at: indexPath!) as! FacilityCollectionViewCell
				destination?.facility = tapped.facility
				self.presentDetailView(destination!, tapped: tapped)
			}
			else {
				let destination = self.storyboard?.instantiateViewController(withIdentifier: "alertDetail") as? AlertDetailViewController
				let tapped = self.LocationsList.cellForItem(at: indexPath!) as! AlertCollectionViewCell
				destination?.alert = tapped.alert
				self.presentDetailView(destination!, tapped: tapped)
			}
		}

	}
	
	func presentDetailView(_ destination: UIViewController, tapped: UICollectionViewCell) {
		if(self.view.traitCollection.horizontalSizeClass == .regular && self.view.traitCollection.verticalSizeClass == .regular) {
			//do a popover here for the iPad
			//iPads are cool right?
			destination.modalPresentationStyle = .popover
			let popoverController = destination.popoverPresentationController
			popoverController?.permittedArrowDirections = .any
			popoverController?.sourceView = tapped.contentView
			popoverController?.sourceRect = tapped.bounds
            
            // present the detail view over the search controller if we're searching
            if searchController.isActive {
                searchController.present(destination, animated: true, completion: nil)
            }
            else {
                present(destination, animated: true, completion: nil)
            }
		}
		else {
			let finalDestination = self.storyboard?.instantiateViewController(withIdentifier: "pulling") as? PullingViewController // Fox only, no items
			finalDestination?.currentViewController = destination
			let destDelegate = DeckTransitioningDelegate()
			finalDestination?.modalPresentationStyle = .custom
			finalDestination?.transitioningDelegate = destDelegate
            
            // present the detail view over the search controller if we're searching
            if searchController.isActive {
				searchController.present(finalDestination!, animated: true, completion: nil)
            }
            else {
				present(finalDestination!, animated: true, completion: nil)
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

		refresh(self, forceUpdate: false)
		
		reloadWithFilters()
		
	}
	
	func reloadWithFilters() {
		
		// Facilities
		filteredFacilities = filters.applyFiltersOnFacilities(facilitiesArray)
		shownFacilities = filteredFacilities
		favoritesControlChanges(self)
		
		// Alerts
		let shown = List<Alert>()
		let formatter = ISO8601DateFormatter()
		formatter.timeZone = TimeZone(identifier: "America/New_York")
		let now = Date()
		let defaults = UserDefaults.standard
		let alertFilers = defaults.dictionary(forKey: "alerts") as! [String: Bool]?
		for alert in alertsList {
			if now.isGreaterThanDate(dateToCompare: formatter.date(from: alert.startDate)!)  && now.isLessThanDate(dateToCompare: formatter.date(from: alert.endDate)!) {
				switch alert.urgency {
				case "info":
					if(alertFilers!["informational"])! {
						shown.append(alert)
					}
				case "minor":
					if(alertFilers!["minor alerts"])! {
						shown.append(alert)
					}
				case "major":
					if(alertFilers!["major alerts"])! {
						shown.append(alert)
					}
				default:
					shown.append(alert)
				}
			}
		}
		currentAlerts = shown
		
		
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
			var hasTag = false
			for tag in facility.facilityTags! {
				if hasTag {
					break
				}
				if tag.tag.lowercased().contains(searchText.lowercased()) {
					hasTag = true
				}
			}
			var hasLabel = false
			for label in facility.labels! {
				if hasLabel {
					break
				}
				if label.tag.lowercased().contains(searchText.lowercased()) {
					hasLabel = true
				}
			}
			return hasName || hasBuilding || hasCategory || hasTag
		})
        
        LocationsList.reloadData()
        return filtered
    }
	
	/*
	* Reloads data, either calling update() to attempt a download
	* or simply pulling from the realm
	*/
	@objc func refresh(_ sender: Any, forceUpdate: Bool = true) {
		refreshControl.beginRefreshing()
		if(forceUpdate) {
			update(sender);
		}
		else {
			let results = realm.objects(FacilitiesModel.self)
			if results.count > 0 {
				let model = results[0]
				let facilities = model.facilities
				let alerts = model.alerts
				let lastUpdated = model.lastUpdated
				
				if((facilities.isEmpty && alerts.isEmpty) || lastUpdated.isLessThanDate(dateToCompare: Date(timeIntervalSinceNow: -43200.0))) {
					update(sender)
				}
				else {
					facilitiesArray = facilities
					alertsList = alerts
					self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(lastUpdated)
				}
			}
			else {
				update(sender)
			}

		}
		
		
		updateFiltersLists()
		
		reloadWithFilters()
		refreshControl.endRefreshing()
	}
	
	func updateFiltersLists() {
		// Add locations and categories to filters
		for f in facilitiesArray {
			if(!filters.onlyFromCategories.keys.contains((f.category?.categoryName)!)) {
				filters.onlyFromCategories.updateValue(true, forKey: (f.category?.categoryName)!.lowercased())
			}
			if(!filters.onlyFromLocations.keys.contains((f.facilityLocation?.building)!)) {
				filters.onlyFromLocations.updateValue(true, forKey: (f.facilityLocation?.building)!.lowercased())
			}
			if(!filters.onlyFromCampuses.keys.contains((f.facilityLocation?.campus)!)) {
				filters.onlyFromCampuses.updateValue(true, forKey: (f.facilityLocation?.campus)!.lowercased())
			}
		}
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
						self.updateFiltersLists()
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
					let date = Date()
					self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(date)

					let results = self.realm.objects(FacilitiesModel.self)
					if results.count == 0 {
						let model = FacilitiesModel()
						for f in facilities! {
							model.facilities.append(f)
						}
						model.lastUpdated = date
						try! self.realm.write {
							self.realm.add(model)
						}
					}
					else {
						let fromRealm = results[0]
						try! self.realm.write {
							fromRealm.facilities.removeAll()
							for f in facilities! {
								fromRealm.facilities.append(f)
							}
							fromRealm.lastUpdated = date
						}
					}
					self.updateFiltersLists()
					self.reloadWithFilters()
				}
			}
		}
		SRCTNetworkController.performAlertsDownload { (alerts) in
			if(alerts == nil) {
				DispatchQueue.main.async {
					let results = self.realm.objects(FacilitiesModel.self)
					if results.count > 0 {
						let model = results[0]
						self.alertsList = model.alerts
					}
					else {
						self.alertsList = List<Alert>()
					}
				}
			}
			else {
				self.alertsList = alerts!
				
				DispatchQueue.main.async {
					let results = self.realm.objects(FacilitiesModel.self)
					if results.count == 0 {
						try! self.realm.write {
							let model = FacilitiesModel()
							for a in alerts! {
								model.alerts.append(a)
							}
							self.realm.add(model)
						}
					}
					else {
						let fromRealm = results[0]
						try! self.realm.write {
							fromRealm.alerts.removeAll()
							for a in alerts! {
								fromRealm.alerts.append(a)
							}
						}
					}
					self.reloadWithFilters()
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
		if currentAlerts.count > 0 {
			return 2
		}
		else {
			return 1
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if(section == 1 || currentAlerts.count == 0) {
			return shownFacilities.count
		}
		else {
			// TODO: get current alerts, not just any alerts
			return currentAlerts.count
		}
		
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if (indexPath.section == 1 || currentAlerts.count == 0) {
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
			var name = facility.facilityName
			let separator = name.index(of: "[")
			if separator != nil {
				name = String(name[..<separator!]).replacingOccurrences(of: "\\s+$",with: "", options: .regularExpression)
			}
			cell.nameLabel.text = name
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
				cell.backgroundColor = UIColor(red:0.17, green:0.17, blue: 0.17, alpha: 1.0)
				
			}
			
			//Accessibility
			cell.accessibilityLabel = cell.nameLabel.text! + " " + cell.categoryLabel.text! + ", Currently " + cell.openClosedLabel.text! + ". Located in" + cell.timeDescriptionLabel.text!
			cell.accessibilityHint = "Double Tap to view details"
			
			
			//Shadows
			cell.layer.shadowColor = UIColor.black.cgColor
			cell.layer.shadowOffset = CGSize(width: 0, height: 3)
			cell.layer.shadowRadius = 7.0
			cell.layer.shadowOpacity = 0.4
			cell.layer.masksToBounds = false
			cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
			self.reloadInputViews()
			return cell
		}
		else {
			// Do Alerts things here
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Alert Cell", for: indexPath) as! AlertCollectionViewCell
			cell.viewWidth = self.view.frame.width
			cell.alert = currentAlerts[indexPath.row]
			cell.tapRecognizer.addTarget(self, action: #selector(FacilitiesListViewController.tapRecognizer(_:)))
			cell.gestureRecognizers = []
			cell.gestureRecognizers?.append(cell.tapRecognizer)
			
			switch currentAlerts[indexPath.row].urgency {
			case "info":
				cell.imageView.image = #imageLiteral(resourceName: "info")
				cell.imageView.accessibilityLabel = "Info"
			case "minor":
				cell.imageView.image = #imageLiteral(resourceName: "minor")
				cell.imageView.accessibilityLabel = "Minor Alert"
			case "major":
				cell.imageView.image = #imageLiteral(resourceName: "major")
				cell.imageView.accessibilityLabel = "Major Alert"
			case "emergency":
				cell.imageView.image = #imageLiteral(resourceName: "emergency")
				cell.imageView.accessibilityLabel = "Emergency Alert"
			default:
				cell.imageView.image = #imageLiteral(resourceName: "major")
				cell.imageView.accessibilityLabel = "Alert"
			}
			cell.messageLabel.text = currentAlerts[indexPath.row].message

			
			return cell
		}

	}
	
	// MARK - Collection View Cell Layout
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if(indexPath.section == 1 || currentAlerts.count == 0) {
			let height = LocationsListLayout.itemSize.height
			let width: CGFloat
			
			let edgeInsets = self.view.safeAreaInsets
			let windowWidth = self.view.frame.size.width - edgeInsets.left - edgeInsets.right
			
			if(windowWidth < 640) {
				width = windowWidth - 20
			}
			else if(windowWidth >= 640 && windowWidth < 1024) {
				width = (windowWidth / 2) - 15
			}
			else if(windowWidth >= 1024) {
				width = (windowWidth / 3) - 15
			}
			else {
				width = windowWidth - 20
			}
			
			return CGSize(width: width, height: height)
		}
		else {
			let edgeInsets = self.view.safeAreaInsets
			return CGSize(width: self.view.frame.size.width - edgeInsets.left - edgeInsets.right, height: 43)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		if(section == 1 || currentAlerts.count == 0) {
			return 15
		}
		else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		if(section == 1 || currentAlerts.count == 0) {
			return 10
		}
		else {
			return 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		var sectionInsets = LocationsListLayout.sectionInset
		if(section != 1 && currentAlerts.count != 0) {
			sectionInsets.top = 0
		}
		else if currentAlerts.count == 0 {
			sectionInsets.top = 15
		}
		return sectionInsets
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

	//unused
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if(segue.identifier == "toDetailView") {
            let destination = segue.destination as! PullingViewController
			var destChild = destination.childViewControllers[0] as! FacilityDetailViewController
			destChild = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! FacilityDetailViewController
            let destDelegate = DeckTransitioningDelegate()
            destination.transitioningDelegate = destDelegate
            let tapped = sender as! FacilityCollectionViewCell //this is probably a bad idea just FYI future me
			destChild.facility = tapped.facility

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
		if(indexPath.section == 1 || currentAlerts.count == 0) {
			let cell = LocationsList?.cellForItem(at: indexPath) as? FacilityCollectionViewCell
			guard let detailView = storyboard?.instantiateViewController(withIdentifier: "detailView") as? FacilityDetailViewController else { return nil }
			detailView.facility = cell?.facility
			return detailView
		}
		else {
			let cell = LocationsList?.cellForItem(at: indexPath) as? AlertCollectionViewCell
			guard let detailView = storyboard?.instantiateViewController(withIdentifier: "alertDetail") as? AlertDetailViewController else { return nil }
			detailView.alert = cell?.alert
			return detailView
		}

	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		let finalDestination = self.storyboard?.instantiateViewController(withIdentifier: "pulling") as? PullingViewController // Fox only, no items
		finalDestination?.currentViewController = viewControllerToCommit
		let destDelegate = DeckTransitioningDelegate()
		finalDestination?.modalPresentationStyle = .custom
		finalDestination?.transitioningDelegate = destDelegate
		//If one day 3D touch comes to the iPad, this is no longer good.
		present(finalDestination!, animated: true, completion: nil)
	}
	
}

// by implementing UISearchResultsUpdating, we can use this controller for the search controller
extension FacilitiesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        shownFacilities = filterFacilitiesForSearchText(searchText)
    }
}

// based on https://stackoverflow.com/questions/26198526/nsdate-comparison-using-swift
extension Date {
	func isGreaterThanDate(dateToCompare: Date) -> Bool {
		//Declare Variables
		var isGreater = false
		
		//Compare Values
		if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
			isGreater = true
		}
		
		//Return Result
		return isGreater
	}
	
	func isLessThanDate(dateToCompare: Date) -> Bool {
		//Declare Variables
		var isLess = false
		
		//Compare Values
		if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
			isLess = true
		}
		
		//Return Result
		return isLess
	}
	
	func equalToDate(dateToCompare: Date) -> Bool {
		//Declare Variables
		var isEqualTo = false
		
		//Compare Values
		if self.compare(dateToCompare) == ComparisonResult.orderedSame {
			isEqualTo = true
		}
		
		//Return Result
		return isEqualTo
	}
}



