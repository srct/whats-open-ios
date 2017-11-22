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

class FacilitiesListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate {

	var facilitiesArray = List<Facility>()
    var filteredFacilities = List<Facility>()
    
    // passing in nil sets the controller to be this controller
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

	@IBAction func favoritesControlChanges(_ sender: Any) {
		switch (self.favoritesControl.selectedSegmentIndex)
		{
		case 0:
			showFavorites = false
			filteredFacilities = facilitiesArray
		case 1:
			showFavorites = true
			filteredFacilities = List<Facility>()
			let defaults = UserDefaults.standard
			
			let favoriteStrings = defaults.array(forKey: "favorites") as! [String]?
			if(favoriteStrings == nil) {
				return
			}
			else {
				for facility in facilitiesArray {
					for str in favoriteStrings! {
						if(facility.facilityName == str) {
							filteredFacilities.append(facility)
							break;
						}
					}
				}
			}

		default:
			showFavorites = false
		}
		self.LocationsList.reloadData()
	}

	let refreshControl = UIRefreshControl()

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
		refresh(sender)
	}

	override func viewWillAppear(_ animated: Bool) {
		LastUpdatedLabel.isEnabled = false
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
        
        configureSearchController()
		
		LocationsListLayout.invalidateLayout()
		
		settingsButton.accessibilityLabel = "Settings"
		LastUpdatedLabel.accessibilityHint = ""
		
		LocationsListLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)

		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		LocationsList.addSubview(refreshControl)
		LocationsList.alwaysBounceVertical = true

		SRCTNetworkController.performDownload { (facilities) in
			self.facilitiesArray = List(facilities)
			DispatchQueue.main.async {
				self.LocationsList.reloadData()
				let date = Date()
				self.LastUpdatedLabel.title = "Updated: " + self.shortDateFormat(date)
			}
		}
		
	}
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    func filterFacilitiesForSearchText(_ searchText: String) {
        filteredFacilities = facilitiesArray.filter({(facility: Facility) -> Bool in
            let hasName = facility.facilityName.lowercased().contains(searchText.lowercased())
            let hasBuilding = facility.facilityLocation?.building.lowercased().contains(searchText.lowercased()) ?? false
			let hasCategory = facility.category?.categoryName.lowercased().contains(searchText.lowercased()) ?? false
            return hasName || hasBuilding || hasCategory
        })
        LocationsList.reloadData()
    }
	
	@objc func refresh(_ sender: Any) {
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
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching() || showFavorites ? self.filteredFacilities.count : self.facilitiesArray.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        let dataArray: [Facility]
        
        // if something has been searched for, we want to use the filtered array as the data source
        if isSearching() || showFavorites {
            dataArray = placeOpenFacilitiesFirstInArray(filteredFacilities)
        } else {
            dataArray = placeOpenFacilitiesFirstInArray(facilitiesArray)
        }
        
		facility = dataArray[indexPath.row]
        
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

	func getLocationArray(_ facilitiesArray: List<Facility>) -> [Facility] {
		if(!showFavorites) {
			return placeOpenFacilitiesFirstInArray(facilitiesArray)
		}
		else {
			return [] //TODO - INCOMPLETE
		}


	}

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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        if(segue.identifier == "toDetailView") {
//            let destination = segue.destination as! FacilityDetailViewController
//            let destDelegate = DeckTransitioningDelegate()
//            destination.transitioningDelegate = destDelegate
//            let tapped = sender as! FacilityCollectionViewCell //this is probably a bad idea just FYI future me
//            destination.facility = tapped.facility
//
//            // if we're in the search view, present on its controller
//            if searchController.isActive {
//                searchController.present(destination, animated: true, completion: nil)
//            } else {
//                present(destination, animated: true, completion: nil)
//            }
//        }
//        else if(segue.identifier == "toFilters") {
//            let destination = segue.destination as! UINavigationController
//            let filterView = destination.topViewController as! FiltersTableViewController
//            filterView.filters = self.filters
//        }
//
//        // Pass the selected object to the new view controller.
//    }
	
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
        filterFacilitiesForSearchText(searchText)
    }
}

