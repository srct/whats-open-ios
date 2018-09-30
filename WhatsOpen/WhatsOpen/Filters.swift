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
    public var showOpen = true
    public var showClosed = true
	public var sortBy = WOKSortMethod.alphabetical
    public var openFirst = true
	
	public var showAlerts = ["Informational":true, "Minor Alerts":true, "Major Alerts":true]
    
    public var onlyFromLocations = [String: Bool]() // Locations to show, could simply use Location objects instead if you wanted
    public var onlyFromCategories = [String: Bool]() // same as above, but for Categories, not Locations
	public var onlyFromCampuses = [String: Bool]() // and for campuses
	
    public init() {
        //nothing to do here
    }
    
    public func applyFiltersOnFacilities(_ facilities: List<WOKFacility>) -> List<WOKFacility> {
        //TODO: Add checks for onlyFromLocations and onlyFromCategories here before doing the rest
        
        let specifiedFacilities = List<WOKFacility>()
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
                var returning = List<WOKFacility>()
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
                    return List<WOKFacility>()
                }
            }
        case .reverseAlphabetical:
            if(openFirst) {
                var returning = List<WOKFacility>()
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
                    return List<WOKFacility>()
                }
            }
        case .byLocation:
            if(openFirst) {
                var returning = List<WOKFacility>()
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
                    return List<WOKFacility>()
                }
            }
        }
    }
    
    // Takes in array of Facilities, separates them into those open and closed, returning a tuple of 2 arrays
    private func separateOpenAndClosed(_ facilities: List<WOKFacility>) -> (open: List<WOKFacility>, closed: List<WOKFacility>) {
        let open = List<WOKFacility>()
        let closed = List<WOKFacility>()
		/*
		facilities.forEach {
            Utilities.isOpen(facility: $0) ? open.append($0) : closed.append($0)
        }
		*/
		for facility in facilities {
			if WOKUtilities.isOpen(facility: facility) {
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
    private func sortAlphabetically(_ facilities: List<WOKFacility>, reverse: Bool = false) -> List<WOKFacility> {
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
    private func sortByLocation(_ facilities: List<WOKFacility>) -> List<WOKFacility> {
        var facilitiesArray = facilities.asArray()
        facilitiesArray.sort { (facility, nextFacility) in
            guard let location = facility.facilityLocation else { return true }
            guard let nextLocation = nextFacility.facilityLocation else { return false }
            return location.building < nextLocation.building
        }
        return facilitiesArray.asRealmList()
    }
    
    public func setShowOpen(_ to: Bool) -> Bool {
        showOpen = to
        return true
    }
    
    public func setShowClosed(_ to: Bool) -> Bool {
        showClosed = to
        return true
    }
    
    public func setOpenFirst(_ to: Bool) -> Bool {
        openFirst = to
        return true
    }
    
    public func setCategory(_ category: String?, to: Bool) -> Bool{
        if(category != nil) {
            onlyFromCategories[category!] = to
            return true
        }
        else {
            return false
        }
    }
    
    public func setLocation(_ location: String?, to: Bool) -> Bool{
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
public enum WOKSortMethod {
	case alphabetical //A -> Z
	case reverseAlphabetical //Z -> A
	case byLocation // A -> Z Locations, w/ A -> Z Facilities inside
    //case openLongest //Places things open longest on top; if only showing closed, shows opening soonest
    //case openShortest //Places things closing soonest on top; if only showing closed, shows opening furthest from now
    
    
    public static var count = 3 // REMEMBER TO CHANGE THIS IF YOU ADD MORE CASES
    
    
    //We should figure out how we want to allow sorting
}

public extension Array where Element: RealmCollectionValue {
    func asRealmList() -> List<Element> {
        return self.reduce(into: List<Element>()) { (list, element) in
            list.append(element)
        }
    }
}

public extension List {
    func asArray() -> [Element] {
        return self.reduce(into: [Element]()) { (array, element) in
            array.append(element)
        }
    }
}

