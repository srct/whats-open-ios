//
//  PickingTableViewCell.swift
//  WhatsOpen
//
//  Created by Zach Knox on 12/27/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit

class PickingTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet var pickerView: UIPickerView!
	var pickerStrings: [String] = [String]()
	var pickerItems: [Any?]! //literally just here for convienence
	var pickerChecked = [Bool]() //Should I use a dictionary? maybe, but this is way easier
	var pickFunc: ((String?) -> Bool)!
	
	override func awakeFromNib() {
		self.selectionStyle = .none
		pickerView.dataSource = self
		pickerView.delegate = self
		super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerStrings.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerStrings[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		pickerChecked[row] = !pickerChecked[row]
		pickerView.showsSelectionIndicator = pickerChecked[row]
	}
	
}
