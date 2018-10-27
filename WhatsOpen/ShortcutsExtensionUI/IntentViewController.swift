//
//  IntentViewController.swift
//  ShortcutsExtensionUI
//
//  Created by Zach Knox on 10/3/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import IntentsUI
import WhatsOpenKit
import RealmSwift

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
		
		let facilityIntent = interaction.intent as? WOPViewFacilityIntent
		
		if facilityIntent != nil {
			if interaction.intentHandlingStatus != .failure {
				let realm = try! Realm(configuration: WOPDatabaseController.getConfig())
				let results = realm.objects(WOPFacilitiesModel.self)
				if results.count > 0 {
					let model = results[0]
					let facilities = model.facilities
					let found = facilities.filter({(facility: WOPFacility) -> Bool in
						return facility.slug == (facilityIntent!.facility?.identifier ?? "")
					})
					if found.count > 0 {
						let facility = found.first
						
						let storyboard = UIStoryboard(name: "WOPSharedUI", bundle: Bundle(for: WOPFacilityDetailViewController.self))
						let detailVC = storyboard.instantiateViewController(withIdentifier: "detailView") as! WOPFacilityDetailViewController
						
						detailVC.facility = facility
						
						attachChild(detailVC)
						completion(true, parameters, self.desiredSize)
					} else {
						completion(false, parameters, .zero)
					}
				} else {
					completion(false, parameters, .zero)
				}

			}
			
			completion(false, parameters, .zero)
		} else {
			completion(false, parameters, .zero)
		}
		
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
	
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
