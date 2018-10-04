//
//  IntentHandler.swift
//  ShortcutsExtension
//
//  Created by Zach Knox on 10/3/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import Intents
import WhatsOpenKit

class IntentHandler: INExtension {
    
	override func handler(for intent: INIntent) -> Any {
		guard intent is WOPViewFacilityIntent else {
			fatalError("Unhandled intent type: \(intent)")
		}
		return WOPViewFacilityIntentHandler()
	}
    
}
