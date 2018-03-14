//
//  SRCTNetworkController.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 26/10/2016.
//  Copyright © 2016 SRCT. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import Realm
import ObjectMapper

class SRCTNetworkController: NSObject {
    //Use this for testing with the new API, might make it possible to get stuff moving pre official release 
    //https://api.srct.gmu.edu/whatsopen/v2/facilities/?format=json
    public static func performDownload(completion: @escaping (_ result: List<Facility>?) -> Void) {

    	let requestURL: NSURL = NSURL(string: "https://api.srct.gmu.edu/whatsopen/v2/facilities/?format=json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared

		let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
			
			if(error != nil) {
				completion(nil)
				return
			}
			else {
				let httpResponse = response as! HTTPURLResponse
				let statusCode = httpResponse.statusCode
				if (statusCode == 200) {
					if let dataN = data {
						if let json = try? JSONSerialization.jsonObject(with: dataN, options: []) as? [[String: Any]] {
							// Map function to iterate through each JSON tree
							let facilities = json!.map({ (json) -> Facility in
								let facility = Facility()
								let map = Map(mappingType: .fromJSON, JSON: json, toObject: true, context: facility, shouldIncludeNilValues: true)
								facility.mapping(map: map)
								return facility
							})
							// This is where completion is called
							// Right after the array is done mapping all facility objects
							completion(List(facilities))
						}
					}
				}
			}

    }
    task.resume()

    }
	
	public static func performAlertsDownload(completion: @escaping (_ result: List<Alert>?) -> Void) {
		
		let requestURL: NSURL = NSURL(string: "https://api.srct.gmu.edu/whatsopen/v2/alerts/?format=json")!
		let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
		let session = URLSession.shared
		
		let task = session.dataTask(with: urlRequest as URLRequest) {
			(data, response, error) -> Void in
			
			if(error != nil) {
				completion(nil)
				return
			}
			else {
				let httpResponse = response as! HTTPURLResponse
				let statusCode = httpResponse.statusCode
				if (statusCode == 200) {
					if let dataN = data {
						if let json = try? JSONSerialization.jsonObject(with: dataN, options: []) as? [[String: Any]] {
							// Map function to iterate through each JSON tree
							let alerts = json!.map({ (json) -> Alert in
								let alert = Alert()
								let map = Map(mappingType: .fromJSON, JSON: json, toObject: true, context: alert, shouldIncludeNilValues: true)
								alert.mapping(map: map)
								return alert
							})
							// This is where completion is called
							// Right after the array is done mapping all facility objects
							completion(List(alerts))
						}
					}
				}
			}
			
		}
		task.resume()
		
	}

}
