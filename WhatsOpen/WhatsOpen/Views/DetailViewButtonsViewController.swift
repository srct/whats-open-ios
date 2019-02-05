//
//  DetailViewButtonsViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/16/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit
import MapKit
import WhatsOpenKit
import Intents
import IntentsUI

class DetailViewButtonsViewController: UIViewController, INUIAddVoiceShortcutViewControllerDelegate {
	

	@IBOutlet var facilityDetailView: UIView!
    private var infoBubbleView: UIView!
    
	var detailViewController: WOPFacilityDetailViewController?
	var facility: WOPFacility!
	
	@IBOutlet var favoritesButton: UIButton!
	@IBOutlet var shareButton: UIButton!
	@IBOutlet var addToSiriButton: UIButton!
	
	let activity = NSUserActivity(activityType: "facility")

	let feedback = UISelectionFeedbackGenerator()
	/**
	Favorites button touch handler
	
	Adds a facility to favorites if it isn't a favorite,
	removes from favorites if it is a favorite.
	*/
	@IBAction func setFavButton(_ sender: Any) {
		feedback.selectionChanged()

		if(WOPUtilities.isFavoriteFacility(facility)) { // if the facility is a favorite
			_ = WOPUtilities.removeFavoriteFacility(facility) // remove it from favorites
		}
		else { // else add it to favorites
			_ = WOPUtilities.addFavoriteFacility(facility)
            loadInfoBubbleView()
		}
		setFavoriteButtonText()		
	}
    
    private func loadInfoBubbleView () {
        let infoBubbleFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 200)
        infoBubbleView = UIView(frame: infoBubbleFrame)
        
        view.addSubview(infoBubbleView)
        
        infoBubbleView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.infoBubbleView.isHidden = true
        }
        
    }
    
	func getDirections(_ sender: Any) {
		let appToUse = WOPDatabaseController.getDefaults().value(forKey: "mapsApp") as? String
		
		if appToUse == "Google Maps" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			if let url = URL(string: "comgooglemaps://?q=\((facility.facilityLocation?.coordinates?.coords?.last)!)),\((facility.facilityLocation?.coordinates?.coords?.first)!)") {
				UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
			}
		}
		else if appToUse == "Waze" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			if let url = URL(string: "https://waze.com/ul?ll=\((facility.facilityLocation?.coordinates?.coords?.last)!)),\((facility.facilityLocation?.coordinates?.coords?.first)!))") {
				UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
			}
		}
		else {
			let regionDistance:CLLocationDistance = 100
			let coordinates = CLLocationCoordinate2DMake((facility.facilityLocation?.coordinates?.coords?.last)!, (facility.facilityLocation?.coordinates?.coords?.first)!)
			dump(coordinates)
			let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
			let options = [
				MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
				MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
			]
			let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
			let mapItem = MKMapItem(placemark: placemark)
			mapItem.name = facility.facilityName
			mapItem.openInMaps(launchOptions: options)
		}
	}
	
	
	@IBAction func shareFacility(_ sender: Any) {
		feedback.selectionChanged()

		let str = "\(facility.facilityName) is \(WOPUtilities.openOrClosedUntil(facility)!.lowercased())"
		// TODO in future: add URL based on facility once web supports it
		let shareSheet = UIActivityViewController(activityItems: [str, (URL(string: "https://whatsopen.gmu.edu") ?? nil), facility], applicationActivities: [ViewInMapsActionActivity()])
		shareSheet.excludedActivityTypes = [.print, .openInIBooks, .addToReadingList] // Sorry you can't print a Facility
		present(shareSheet, animated: true, completion: nil)
	}
	
	/**
	Change the favorite button text depending on if the facility is a favorite
	*/
	func setFavoriteButtonText() {
		if(WOPUtilities.isFavoriteFacility(facility)) {
			favoritesButton.accessibilityLabel = "Remove from Favorites"
			favoritesButton.titleLabel?.text = ""
			favoritesButton.setImage(UIImage(named: "heart_filled"), for: .normal)
		}
		else {
			favoritesButton.accessibilityLabel = "Add to Favorites"
			favoritesButton.titleLabel?.text = ""
			favoritesButton.setImage(UIImage(named: "heart_empty"), for: .normal)
		}
	}
	
	override func viewDidLoad() {
		// Dealing with container views and subviews
		// https://spin.atomicobject.com/2015/10/13/switching-child-view-controllers-ios-auto-layout/
		self.detailViewController!.view.translatesAutoresizingMaskIntoConstraints = false
		self.addChild(self.detailViewController!)
		self.addSubview(self.detailViewController!.view, toView: self.facilityDetailView)
        super.viewDidLoad()
        infoBubbleView.isHidden = true

		setFavoriteButtonText()
		favoritesButton.tintColor = UIColor.white
		favoritesButton.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		favoritesButton.layer.cornerRadius = 10
		
		shareButton.tintColor = UIColor.white
		shareButton.backgroundColor = UIColor.orange
		shareButton.layer.cornerRadius = 10
		shareButton.setImage(#imageLiteral(resourceName: "shareIcon"), for: .normal)
		shareButton.setTitle("", for: .normal)
		shareButton.accessibilityLabel = "Share"

		setActivityUp()
		
		addToSiriButton.tintColor = UIColor.white
		addToSiriButton.backgroundColor = UIColor.black
		addToSiriButton.layer.cornerRadius = 10
		addToSiriButton.accessibilityLabel = "Add to Siri"
		
		let interaction = INInteraction(intent: facility.createIntent(), response: WOPViewFacilityIntentUtils.getIntentResponse(facility, userActivity: activity))
		interaction.donate(completion: nil)
        // Do any additional setup after loading the view.
    }
	
	func setActivityUp() {
		activity.isEligibleForHandoff = true
		activity.isEligibleForSearch = true
		activity.addUserInfoEntries(from: ["facility": facility.slug])
		activity.title = facility.facilityName
		activity.keywords = Set<String>(arrayLiteral: facility.facilityName, facility.facilityLocation!.building)
		//activity.keywords = [facility.facilityName, facility.facilityLocation?.building]
		activity.webpageURL = URL(string: "https://whatsopen.gmu.edu/")
		
		activity.becomeCurrent()
	}
	
	@IBAction func addToSiri(_ sender: Any) {
		feedback.selectionChanged()
		let intent = facility.createIntent()
		let shortcuts = INVoiceShortcutCenter.shared
		if let shortcut = INShortcut(intent: intent) {
			let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
			viewController.modalPresentationStyle = .formSheet
			viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
			present(viewController, animated: true, completion: nil)
		}
	}

	func addSubview(_ subView: UIView, toView parentView: UIView) {
		parentView.addSubview(subView)
		
		var viewBindingsDict = [String: AnyObject]()
		viewBindingsDict["subView"] = subView
		parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
																 options: [], metrics: nil, views: viewBindingsDict))
		parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
																 options: [], metrics: nil, views: viewBindingsDict))
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: INUIAdd... Delegate
	
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
	
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		controller.dismiss(animated: true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
