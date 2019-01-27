//
//  DatabaseController.swift
//  WhatsOpenKit
//
//  Created by Zach Knox on 9/30/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import Foundation
import RealmSwift

//Realm Model
public class WOPFacilitiesModel: Object {
	public let facilities = List<WOPFacility>()
	public let alerts = List<WOPAlert>()
	@objc public dynamic var lastUpdated = Date()
	@objc public dynamic let id = 0
}


public class WOPDatabaseController {
	
	public static func getConfig() -> Realm.Configuration {
		var config = Realm.Configuration()
		// Set the new schema version. This must be greater than the previously used
		// version (if you've never set a schema version before, the version is 0).
		config.schemaVersion = 3
		// We replace the data stored every 12 hours, do we _really_ need to worry about schema updates?
		// I say nay.
		config.deleteRealmIfMigrationNeeded = true
		
		// If appstore, use an app group for the DB
		#if APPSTORE
		let fileURL = FileManager.default
			.containerURL(forSecurityApplicationGroupIdentifier: "group.edu.gmu.srct.whatsopen")?.appendingPathComponent("Library/Application Support/", isDirectory: true)
		config.fileURL = fileURL!.deletingLastPathComponent().appendingPathComponent("whatsopen.realm")
		#endif
		
		return config
	}
	
	public static func getDefaults() -> UserDefaults {
		#if APPSTORE
		return UserDefaults.init(suiteName: "group.edu.gmu.srct.whatsopen")!
		#else
		return UserDefaults.standard
		#endif
	}
}
