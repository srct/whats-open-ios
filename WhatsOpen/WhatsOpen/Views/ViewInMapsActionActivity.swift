//
//  ViewInMapsActionActivity.swift
//  WhatsOpen
//
//  Created by Zach Knox on 12/22/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit
import MapKit
import WhatsOpenKit

class ViewInMapsActionActivity: UIActivity {

	override var activityType: UIActivity.ActivityType? {
		return UIActivity.ActivityType(rawValue: "maps")
	}
	override var activityTitle: String? {
		let appToUse = WOPDatabaseController.getDefaults().value(forKey: "mapsApp") as? String

		if appToUse == "Google Maps" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			return "View in Google Maps"
		}
		else if appToUse == "Waze" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			return "View in Waze"
		}
		else {
			return "View in Maps"
		}
	}
	override var activityImage: UIImage? {
		return UIImage(named: "map")
	}
	
	var facility: WOPFacility? = nil
	
	override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
		for i in activityItems {
			if i as? WOPFacility != nil {
				return true
			}
		}
		
		return false
	}
	
	override func prepare(withActivityItems activityItems: [Any]) {
		for i in activityItems {
			if i as? WOPFacility != nil {
				facility = i as? WOPFacility
			}
		}
	}
	
	override func perform() {
		let appToUse = WOPDatabaseController.getDefaults().value(forKey: "mapsApp") as? String
		
		if appToUse == "Google Maps" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			if let url = URL(string: "comgooglemaps://?q=\((facility!.facilityLocation?.coordinates?.coords?.last)!)),\((facility!.facilityLocation?.coordinates?.coords?.first)!)") {
				UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
			}
		}
		else if appToUse == "Waze" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			if let url = URL(string: "https://waze.com/ul?ll=\((facility!.facilityLocation?.coordinates?.coords?.last)!)),\((facility!.facilityLocation?.coordinates?.coords?.first)!))") {
				UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
			}
		}
		else {
			let regionDistance:CLLocationDistance = 100
			let coordinates = CLLocationCoordinate2DMake((facility!.facilityLocation?.coordinates?.coords?.last)!, (facility!.facilityLocation?.coordinates?.coords?.first)!)
			dump(coordinates)
			let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
			let options = [
				MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
				MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
			]
			let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
			let mapItem = MKMapItem(placemark: placemark)
			mapItem.name = facility!.facilityName
			mapItem.openInMaps(launchOptions: options)
		}
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
