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

import WhatsOpenKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		#if APPSTORE
		Fabric.with([Crashlytics.self])
		
		migrateDefaults()
		#endif
		
		let defaults = WOPDatabaseController.getDefaults()
		
		
		initAlerts(defaults)
		initCampuses(defaults)
		if defaults.value(forKey: "mapsApp") == nil {
			defaults.set("Apple Maps", forKey: "mapsApp")
		}
		
		application.setMinimumBackgroundFetchInterval(TimeInterval(exactly: 60)!)
		
        return true
    }

	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
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
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		let base = URL(string: "/", relativeTo: url)?.absoluteString
		if base == "whatsopen://open/" {
			let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
			let facilityParam = queryItems?.filter({$0.name == "facility"}).first
			if facilityParam != nil {
				NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "openFacilityFromURL"), object: url, userInfo: ["facility": facilityParam!.value]))
				return true
			}
			
			return false
		} else {
			return false
		}
	}
	
	func migrateDefaults() {
		let oldDefaults = UserDefaults.standard
		if oldDefaults.integer(forKey: "migrated") <= 0 && oldDefaults.value(forKey: "mapsApp") != nil {
			// migrating from a pre 1.2 release
			let defaults = WOPDatabaseController.getDefaults()
			defaults.set(oldDefaults.string(forKey: "mapsApp"), forKey: "mapsApp")
			defaults.set(oldDefaults.dictionary(forKey: "alerts"), forKey: "alerts")
			defaults.set(oldDefaults.dictionary(forKey: "campuses"), forKey: "campuses")
			defaults.set(oldDefaults.array(forKey: "favorites") ?? [], forKey: "favorites")
			defaults.set(1, forKey: "migrated")
		} else if oldDefaults.value(forKey: "mapsApp") != nil {
			// if initial launch, consider it migrated
			let defaults = WOPDatabaseController.getDefaults()
			defaults.set(1, forKey: "migrated")
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
	
	func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		WOPDownloadController.performDownload(completion: { facilities in
			if facilities != nil {
				WOPDownloadController.performAlertsDownload(completion: { alerts in
					if alerts != nil {
						DispatchQueue.main.async {
							let date = Date()
							let realm = try! Realm(configuration: WOPDatabaseController.getConfig())
							let results = realm.objects(WOPFacilitiesModel.self)
							if results.count == 0 {
								let model = WOPFacilitiesModel()
								for f in facilities! {
									model.facilities.append(f)
								}
								for a in alerts! {
									model.alerts.append(a)
								}
								model.lastUpdated = date
								try! realm.write {
									realm.add(model)
								}
								completionHandler(UIBackgroundFetchResult.newData)

							}
							else {
								let fromRealm = results[0]
								try! realm.write {
									fromRealm.facilities.removeAll()
									for f in facilities! {
										fromRealm.facilities.append(f)
									}
									for a in alerts! {
										fromRealm.alerts.append(a)
									}
									fromRealm.lastUpdated = date
								}
							}
							completionHandler(UIBackgroundFetchResult.newData)
						}
					} else {
						completionHandler(UIBackgroundFetchResult.failed)
				  }
				})
			} else {
				completionHandler(UIBackgroundFetchResult.failed)
			}
		})
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

