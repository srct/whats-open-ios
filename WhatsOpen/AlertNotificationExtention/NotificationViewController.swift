//
//  NotificationViewController.swift
//  AlertNotificationExtention
//
//  Created by Zach Knox on 1/25/19.
//  Copyright © 2019 SRCT. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

import RealmSwift

import WhatsOpenKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
	@IBOutlet var containerView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
		let realm = try! Realm(configuration: WOPDatabaseController.getConfig())
		let results = realm.objects(WOPFacilitiesModel.self)
		if results.count > 0 {
			let model = results[0]
			let alerts = model.alerts
			let objs = alerts.filter(NSPredicate(format: "id = \((notification.request.content.userInfo["alertID"])!)"))
			
			if objs.count > 0 {
				let alert = objs.first
				
				let storyboard = UIStoryboard(name: "WOPSharedUI", bundle: Bundle(for: WOPAlertDetailViewController.self))
				let detailVC = storyboard.instantiateViewController(withIdentifier: "detailView") as! WOPAlertDetailViewController
				
				detailVC.alert = alert
				
				self.addChild(detailVC)
				self.addSubview(detailVC.view, toView: containerView)
				//attachChild(detailVC)
			} else {
				return
			}
		} else {
			return
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
	
	// Taken from Apple's SoupChef sample code
	private func attachChild(_ viewController: UIViewController) {
		addChild(viewController)
		
		if let subview = viewController.view {
			view.addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
			
			// Set the child controller's view to be the exact same size as the parent controller's view.
			subview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
			subview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
			
			subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
			subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		}
		
		viewController.didMove(toParent: self)
	}

}
