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
	var allAllFacilities = true
    var openFirst = true
	
	init() {
        //nothing to do here
	}
	
    func applyFiltersOnFacilities(_ facilities: [Facility]) -> [Facility] {
        
        
        return []
    }
    
    // Takes in array of Facilities, separates them into those open and closed, returning a tuple of 2 arrays
    private func separateOpenAndClosed(_ facilities: [Facility]) -> (open: [Facility], closed: [Facility]) {
        
        return ([], [])
    }
    
    // Sorts items in the given Facility array by name alphabetically (reverse if told)
    private func sortAlphabetically(_ facilities: [Facility], reverse: Bool = false) -> [Facility] {
        
        return []
    }
    
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
