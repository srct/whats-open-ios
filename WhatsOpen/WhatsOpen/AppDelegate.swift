//
//  AppDelegate.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 25/10/2016.
//  Copyright © 2016 SRCT. Some rights reserved.
//

import UIKit
import RealmSwift

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		#if APPSTORE
			Fabric.with([Crashlytics.self])
		#endif
		
		let defaults = UserDefaults.standard
		initAlerts(defaults)
		initCampuses(defaults)
		if defaults.value(forKey: "mapsApp") == nil {
			defaults.set("Apple Maps", forKey: "mapsApp")
		}
		
        return true
    }

	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
		dump(userActivity.userInfo)
		if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
			let _ = userActivity.webpageURL
			return true // TODO for future release with URL scheme support
		}
		else if userActivity.userInfo?["facility"] != nil {
			NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "launchToFacility"), object: userActivity, userInfo: ["facility": userActivity.userInfo!["facility"]!]))
			return true
		} else {
			return false
		}
	}
	
	func initAlerts(_ defaults: UserDefaults) {
		let alerts = defaults.dictionary(forKey: "alerts")
		if alerts == nil {
			var setAlerts = [String: Bool]()
			setAlerts.updateValue(true, forKey: "informational")
			setAlerts.updateValue(true, forKey: "minor alerts")
			setAlerts.updateValue(true, forKey: "major alerts")
			defaults.set(setAlerts, forKey: "alerts")
		}
	}
	
	func initCampuses(_ defaults: UserDefaults) {
		let campuses = defaults.dictionary(forKey: "campuses")
		if campuses == nil {
			defaults.set([String: Bool](), forKey: "campuses")
		}
	}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

