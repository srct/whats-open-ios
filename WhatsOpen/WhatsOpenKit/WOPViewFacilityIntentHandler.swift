//
//  WOPViewFacilityIntentHandler.swift
//  WhatsOpenKit
//
//  Created by Zach Knox on 10/3/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import Foundation
import Intents
import RealmSwift

public class WOPViewFacilityIntentHandler: NSObject, WOPViewFacilityIntentHandling {
	
	public func handle(intent: WOPViewFacilityIntent, completion: @escaping (WOPViewFacilityIntentResponse) -> Void) {
		
		let realm = try! Realm(configuration: WOPDatabaseController.getConfig())
		let results = realm.objects(WOPFacilitiesModel.self)
		if results.count > 0 {
			let model = results[0]
			let facilities = model.facilities
			let found = facilities.filter({(facility: WOPFacility) -> Bool in
				return facility.slug == (intent.facility?.identifier ?? "")
			})
			if found.count > 0 {
				
				let activity = NSUserActivity(activityType: "facilityIntent")
				activity.isEligibleForHandoff = true
				activity.isEligibleForSearch = true
				activity.addUserInfoEntries(from: ["facility": intent.facility?.identifier ?? ""])
				activity.title = intent.facility?.identifier ?? ""
				activity.keywords = Set<String>(arrayLiteral: intent.facility?.identifier ?? "")
				activity.webpageURL = URL(string: "https://whatsopen.gmu.edu/")
				
				let facility = found.first
				
				let response = WOPViewFacilityIntentUtils.getIntentResponse(facility!, userActivity: activity)
				
				completion(response)
			} else {
				completion(WOPViewFacilityIntentResponse(code: .failure, userActivity: nil))
			}
		} else {
			completion(WOPViewFacilityIntentResponse(code: .failure, userActivity: nil))
		}
	}
	
}

public class WOPViewFacilityIntentUtils {
	public static func getIntentResponse(_ facility: WOPFacility, userActivity: NSUserActivity) -> WOPViewFacilityIntentResponse {
		let isOpen = WOPUtilities.isOpen(facility: facility)
		let nextTime = WOPUtilities.openOrClosedUntil(facility, includePreamble: false)
		
		let response: WOPViewFacilityIntentResponse
		if isOpen {
			if nextTime != nil {
				response = WOPViewFacilityIntentResponse.success(facilityName: (facility.facilityName), nextTime: nextTime!)
			} else {
				response = WOPViewFacilityIntentResponse.success24hour(facilityName: (facility.facilityName))
			}
		} else {
			if nextTime != nil {
				response = WOPViewFacilityIntentResponse.closed(facilityName: (facility.facilityName), nextTime: nextTime!)
			} else {
				response = WOPViewFacilityIntentResponse.closedNoNext(facilityName: (facility.facilityName))
			}
		}
		response.userActivity = userActivity
		
		return response
	}
}
