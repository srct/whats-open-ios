//
//  Filters.swift
//  WhatsOpen
//
//  Created by Zach Knox on 5/7/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import Foundation

//This may be a stupid way to handle filters, but it should work; at least for now

struct Filters {
	var showOpen = true
	var showClosed = true
	var sortBy = SortMethod.alphabetical
	var allAllFacilities = true
	var facilitiesToShow: [Facility]
	
}

//Is this a viable way to do this?
enum SortMethod {
	case alphabetical //A -> Z
	case reverseAlphabetical //Z -> A
	case openLongest //Places things open longest on top; if only showing closed, shows opening soonest
	case openShortest //Places things closing soonest on top; if only showing closed, shows opening furthest from now
	
	//We should figure out how we want to allow sorting
}
