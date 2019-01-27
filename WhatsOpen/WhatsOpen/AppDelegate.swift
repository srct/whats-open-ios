//
//  AppDelegate.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 25/10/2016.
//  Copyright © 2016 SRCT. Some rights reserved.
//

import UIKit
import UserNotifications

import RealmSwift
import Fabric
import Crashlytics

import WhatsOpenKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	func applicationDidBecomeActive(_ application: UIApplication) {
		application.applicationIconBadgeNumber = 0
	}
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		#if APPSTORE
		Fabric.with([Crashlytics.self])
		
		migrateDefaults()
		#endif
		
		let defaults = WOPDatabaseController.getDefaults()
		
		
		initAlerts(defaults)
		initAlertNotifications(defaults)
		initCampuses(defaults)
		if defaults.value(forKey: "mapsApp") == nil {
			defaults.set("Apple Maps", forKey: "mapsApp")
		}
		
		application.setMinimumBackgroundFetchInterval(3600)
		
		let alertNotificationCategory = UNNotificationCategory(identifier: "alertNotify", actions: [], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "Alert", options: .hiddenPreviewsShowTitle)
		let nc = UNUserNotificationCenter.current()
		nc.delegate = self
		nc.setNotificationCategories([alertNotificationCategory])
		nc.getNotificationSettings { (settings) in
			if settings.authorizationStatus == .notDetermined {
				nc.requestAuthorization(options: [.badge, .sound, .alert, .providesAppNotificationSettings, .provisional], completionHandler: { (authorized, error) in
					return // it's a provisonal request nbd
				})
			}
		}
		
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
		let oldDefaults = WOPDatabaseController.getDefaults()
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

	func initAlertNotifications(_ defaults: UserDefaults) {
		let notifications = defaults.dictionary(forKey: "notificationDefaults")
		if notifications == nil {
			var setAlerts = [String: Bool]()
			setAlerts.updateValue(false, forKey: "informational")
			setAlerts.updateValue(true, forKey: "minor alerts")
			setAlerts.updateValue(true, forKey: "major alerts")
			setAlerts.updateValue(true, forKey: "emergency")
			defaults.set(setAlerts, forKey: "notificationDefaults")
		}
		
		let alertIDs = defaults.dictionary(forKey: "alertIDNotified")
		if alertIDs == nil {
			let setAlerts = [String: Bool]()
			defaults.set(setAlerts, forKey: "alertIDNotified")
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
							// Add to Realm
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
									fromRealm.alerts.removeAll()
									for f in facilities! {
										fromRealm.facilities.append(f)
									}
									for a in alerts! {
										fromRealm.alerts.append(a)
									}
									fromRealm.lastUpdated = date
								}
							}
							
							// Notification
							/*
							let a = WOPAlert(JSONString: "{\"id\": 20,\"created\": \"2018-11-30T12:00:28.109052-05:00\",\"modified\": \"2019-01-23T10:30:32.313528-05:00\",\"urgency_tag\": \"info\",\"message\": \"Mason is closed Mon, Jan 21. Some services are open. Dining Hours: https://dining.gmu.edu/wp-content/uploads/2019/01/MLK-HOO-1.png\",\"start_datetime\": \"2019-01-21T00:00:00-05:00\",\"end_datetime\": \"2019-01-21T23:59:00-05:00\"}")
							alerts?.append(a!)*/
							
							completionHandler(UIBackgroundFetchResult.newData)
						}
						
						self.scheduleNotifications(for: alerts!)
					} else {
						completionHandler(UIBackgroundFetchResult.failed)
				  }
				})
			} else {
				completionHandler(UIBackgroundFetchResult.failed)
			}
		})
	}
	
	func scheduleNotifications(for alerts: List<WOPAlert>) {
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.getNotificationSettings { (settings) in
			// Do not schedule notifications if not authorized.
			guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {return}
			
			let defaults = WOPDatabaseController.getDefaults()
			let inAppSettings = defaults.dictionary(forKey: "notificationDefaults") as! [String: Bool]
			let alertIDs = defaults.dictionary(forKey: "alertIDNotified") as! [String: Bool]
			
			let formatter = ISO8601DateFormatter()
			formatter.timeZone = TimeZone(identifier: "America/New_York")
			let now = Date()
			for alert in alerts {
				if true || (now.isGreaterThanDate(dateToCompare: formatter.date(from: alert.startDate)!) && now.isLessThanDate(dateToCompare: formatter.date(from: alert.endDate)!)) {
					switch alert.urgency {
					case "info":
						if inAppSettings["informational"]! {
							self.singleNotification(alert, nc: notificationCenter, ids: alertIDs, defaults: defaults)
						}
					case "minor":
						if inAppSettings["minor alerts"]! {
							self.singleNotification(alert, nc: notificationCenter, ids: alertIDs, defaults: defaults)
						}
					case "major":
						if inAppSettings["major alerts"]! {
							self.singleNotification(alert, nc: notificationCenter, ids: alertIDs, defaults: defaults)
						}
					case "emergency":
						if inAppSettings["emergency"]! {
							self.singleNotification(alert, nc: notificationCenter, ids: alertIDs, defaults: defaults)
						}
					default:
						return
					}
				}
			}
			

		}
	}
	
	func singleNotification(_ alert: WOPAlert, nc: UNUserNotificationCenter, ids: [String: Bool], defaults: UserDefaults) {
		if ids["\(alert.id)"] == nil {
			let content = UNMutableNotificationContent()
			content.categoryIdentifier = "alertNotify"
			switch alert.urgency {
			case "info":
				content.title = "Information"
			case "minor":
				content.title = "Minor Alert"
			case "major":
				content.title = "Major Alert"
			case "emergency":
				content.title = "Emergency Alert"
			default:
				content.title = "Alert"
			}
			if alert.message != "" {
				content.body = alert.message
			} else {
				content.subtitle = alert.subject
				content.body = alert.body
			}
			
			content.badge = 1 as NSNumber
			let sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "patriots.caf"))
			content.sound = sound
			content.userInfo = ["alertID": alert.id]
			
			let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
			nc.add(request, withCompletionHandler: {error in
				if error == nil {
					var updatedIDs = ids
					updatedIDs["\(alert.id)"] = true
					defaults.set(updatedIDs, forKey: "alertIDNotified")
				}
			})
		} else {
			return
		}
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
			let notification = response.notification
			
			NotificationCenter.default.post(name: Notification.Name(rawValue: "openAlert"), object: notification)
		}
		completionHandler()
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
		NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "launchToNotificationSettings"), object: notification, userInfo: nil))
	}
	
}

