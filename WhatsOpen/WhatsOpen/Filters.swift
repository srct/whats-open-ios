//
//  Filters.swift
//  WhatsOpen
//
//  Created by Zach Knox on 5/7/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import Foundation

//This may be a stupid way to handle filters, but it should work; at least for now

class Filters {
	var showOpen = true
	var showClosed = true
	var sortBy = SortMethod.alphabetical
    var openFirst = true
	
	var onlyFromLocations = [Locations]() // Locations to show, could simply use Location objects instead if you wanted
	var onlyFromCategories = [Categories]() //same as above, but for Categories, not Locations
	//can check these using the .equals() functions in Locations and Categories
	
	
	init() {
        //nothing to do here
	}
	
    func applyFiltersOnFacilities(_ facilities: [Facility]) -> [Facility] {
		//TODO: Add checks for onlyFromLocations and onlyFromCategories here before doing the rest
		
		let (open, closed) = separateOpenAndClosed(facilities)
        
        // This switch statement figures out what sort method is being used, and will sort accordingly
        switch sortBy {
        case .alphabetical:
            if(openFirst) {
                var returning: [Facility] = []
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
                    return []
                }
            }
        case .reverseAlphabetical:
            if(openFirst) {
                var returning: [Facility] = []
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
                    return []
                }
            }
        case .byLocation:
            if(openFirst) {
                var returning: [Facility] = []
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
                    return []
                }
            }
        }
    }
	
	//TODO
    // Takes in array of Facilities, separates them into those open and closed, returning a tuple of 2 arrays
    private func separateOpenAndClosed(_ facilities: [Facility]) -> (open: [Facility], closed: [Facility]) {
        
        return ([], [])
    }
	
	//TODO
    // Sorts items in the given Facility array by name alphabetically (reverse if told)
    private func sortAlphabetically(_ facilities: [Facility], reverse: Bool = false) -> [Facility] {
        
        return []
    }
	
	//TODO
    // Sorts Facilities by their given location's name, and within those sorts A->Z
    private func sortByLocation(_ facilities: [Facility]) -> [Facility] {
        
        return []
    }
    
    
    
    
}

//Is this a viable way to do this?
enum SortMethod {
	case alphabetical //A -> Z
	case reverseAlphabetical //Z -> A
	case byLocation // A -> Z Locations, w/ A -> Z Facilities inside
    //case openLongest //Places things open longest on top; if only showing closed, shows opening soonest
	//case openShortest //Places things closing soonest on top; if only showing closed, shows opening furthest from now
	
	//We should figure out how we want to allow sorting
}
