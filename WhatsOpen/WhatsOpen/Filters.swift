//
//  Filters.swift
//  WhatsOpen
//
//  Created by Zach Knox on 5/7/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import Foundation
import RealmSwift

//This may be a stupid way to handle filters, but it should work; at least for now

public class WOKFilters {
    var showOpen = true
    var showClosed = true
    var sortBy = SortMethod.alphabetical
    var openFirst = true
	
	var showAlerts = ["Informational":true, "Minor Alerts":true, "Major Alerts":true]
    
    var onlyFromLocations = [String: Bool]() // Locations to show, could simply use Location objects instead if you wanted
    var onlyFromCategories = [String: Bool]() // same as above, but for Categories, not Locations
	var onlyFromCampuses = [String: Bool]() // and for campuses
	
    init() {
        //nothing to do here
    }
    
    func applyFiltersOnFacilities(_ facilities: List<Facility>) -> List<Facility> {
        //TODO: Add checks for onlyFromLocations and onlyFromCategories here before doing the rest
        
        let specifiedFacilities = List<Facility>()
        // facility must be within both a specified location and category
        for f in facilities {
            if  onlyFromLocations[(f.facilityLocation?.building)!.lowercased()] == true && onlyFromCategories[(f.category?.categoryName)!.lowercased()] == true {
                specifiedFacilities.append(f)
            }
        }
        
        let (open, closed) = separateOpenAndClosed(specifiedFacilities)
        
        // This switch statement figures out what sort method is being used, and will sort accordingly
        switch sortBy {
        case .alphabetical:
            if(openFirst) {
                var returning = List<Facility>()
                if(showOpen) {
                    returning += sortAlphabetically(open)
                }
                if(showClosed) {
                    returning += sortAlphabetically(closed)
                }
                return returning
            }
            else {
                if(showOpen && showClosed) {
                    return sortAlphabetically(facilities)
                }
                else if(showOpen) {
                    return sortAlphabetically(open)
                }
                else if(showClosed) {
                    return sortAlphabetically(closed)
                }
                else {
                    return List<Facility>()
                }
            }
        case .reverseAlphabetical:
            if(openFirst) {
                var returning = List<Facility>()
                if(showOpen) {
                    returning += sortAlphabetically(open, reverse: true)
                }
                if(showClosed) {
                    returning += sortAlphabetically(closed, reverse: true)
                }
                return returning
            }
            else {
                if(showOpen && showClosed) {
                    return sortAlphabetically(facilities, reverse: true)
                }
                else if(showOpen) {
                    return sortAlphabetically(open, reverse: true)
                }
                else if(showClosed) {
                    return sortAlphabetically(closed, reverse: true)
                }
                else {
                    return List<Facility>()
                }
            }
        case .byLocation:
            if(openFirst) {
                var returning = List<Facility>()
                if(showOpen) {
                    returning += sortByLocation(open)
                }
                if(showClosed) {
                    returning += sortByLocation(closed)
                }
                return returning
            }
            else {
                if(showOpen && showClosed) {
                    return sortByLocation(facilities)
                }
                else if(showOpen) {
                    return sortByLocation(open)
                }
                else if(showClosed) {
                    return sortByLocation(closed)
                }
                else {
                    return List<Facility>()
                }
            }
        }
    }
    
    // Takes in array of Facilities, separates them into those open and closed, returning a tuple of 2 arrays
    private func separateOpenAndClosed(_ facilities: List<Facility>) -> (open: List<Facility>, closed: List<Facility>) {
        let open = List<Facility>()
        let closed = List<Facility>()
		/*
		facilities.forEach {
            Utilities.isOpen(facility: $0) ? open.append($0) : closed.append($0)
        }
		*/
		for facility in facilities {
			if Utilities.isOpen(facility: facility) {
				open.append(facility)
			}
			else {
				closed.append(facility)
			}
		}
        return (open, closed)
    }
    
    //TODO
    // Sorts items in the given Facility array by name alphabetically (reverse if told)
    private func sortAlphabetically(_ facilities: List<Facility>, reverse: Bool = false) -> List<Facility> {
        // Convert to a swift array because the realm sorting method crashes the list object for some reason?
        var facilitiesArray = facilities.asArray()
		if !reverse {
			facilitiesArray.sort { $0.facilityName < $1.facilityName }

		}
		else {
			facilitiesArray.sort { $0.facilityName > $1.facilityName }
		}
        return facilitiesArray.asRealmList()
    }
    
    //TODO
    // Sorts Facilities by their given location's name, and within those sorts A->Z
    private func sortByLocation(_ facilities: List<Facility>) -> List<Facility> {
        var facilitiesArray = facilities.asArray()
        facilitiesArray.sort { (facility, nextFacility) in
            guard let location = facility.facilityLocation else { return true }
            guard let nextLocation = nextFacility.facilityLocation else { return false }
            return location.building < nextLocation.building
        }
        return facilitiesArray.asRealmList()
    }
    
    func setShowOpen(_ to: Bool) -> Bool {
        showOpen = to
        return true
    }
    
    func setShowClosed(_ to: Bool) -> Bool {
        showClosed = to
        return true
    }
    
    func setOpenFirst(_ to: Bool) -> Bool {
        openFirst = to
        return true
    }
    
    func setCategory(_ category: String?, to: Bool) -> Bool{
        if(category != nil) {
            onlyFromCategories[category!] = to
            return true
        }
        else {
            return false
        }
    }
    
    func setLocation(_ location: String?, to: Bool) -> Bool{
        if(location != nil) {
            onlyFromLocations[location!] = to
            return true
        }
        else {
            return false
        }
    }
    
    
}

//Is this a viable way to do this?
enum SortMethod {
    case alphabetical //A -> Z
    case reverseAlphabetical //Z -> A
    case byLocation // A -> Z Locations, w/ A -> Z Facilities inside
    //case openLongest //Places things open longest on top; if only showing closed, shows opening soonest
    //case openShortest //Places things closing soonest on top; if only showing closed, shows opening furthest from now
    
    
    static var count = 3 // REMEMBER TO CHANGE THIS IF YOU ADD MORE CASES
    
    
    //We should figure out how we want to allow sorting
}

extension Array where Element: RealmCollectionValue {
    func asRealmList() -> List<Element> {
        return self.reduce(into: List<Element>()) { (list, element) in
            list.append(element)
        }
    }
}

extension List {
    func asArray() -> [Element] {
        return self.reduce(into: [Element]()) { (array, element) in
            array.append(element)
        }
    }
}

