//
//  PullingViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/12/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit

class PullingViewController: UIViewController {

	@IBOutlet var containerView: UIView!
	weak var currentViewController: UIViewController?
	
	@IBOutlet var pullDown: UIImageView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if animated {
			let haptics = UIImpactFeedbackGenerator(style: .medium)
			haptics.impactOccurred()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		if animated {
			let haptics = UIImpactFeedbackGenerator(style: .medium)
			haptics.impactOccurred()
		}
	}
	
	override func viewDidLoad() {
		
		modalPresentationCapturesStatusBarAppearance = true

		// Dealing with container views and subviews
		// https://spin.atomicobject.com/2015/10/13/switching-child-view-controllers-ios-auto-layout/
		self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
		self.addChild(self.currentViewController!)
		self.addSubview(self.currentViewController!.view, toView: self.containerView)
		self.accessibilityCustomActions = [
			UIAccessibilityCustomAction(name: "Dismiss Detail View", target: self, selector: #selector(PullingViewController.willDismiss))
		]
		super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
	
	@objc func willDismiss() {
		dismiss(animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
