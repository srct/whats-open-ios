//
//  MainTableViewController.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 25/10/2016.
//  Copyright © 2016 SRCT. Some rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    var facilitiesArray = List<Facility>()
    
    @IBOutlet var mainNavigationBar: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        mainNavigationBar.titleView = UIImageView(image: #imageLiteral(resourceName: "Navigation Bar TitleView"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        SRCTNetworkController.performDownload { (facilities) in
            self.facilitiesArray = List(facilities)
            //            print(self.facilitiesArray)
            self.tableView.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //Will want to have two sections (for some parts) eventually, to add headings
        //for open and closed
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = countForOpenAndClosedFacilities(facilitiesArray)
        if(section == 1) {
            return count.open
        }
        else {
            return count.closed
        }
    }
    
    //Returns an array which has the open locations listed first
    //Could be improved in the future because currently this means you're checking
    //open status twice per cell
    func placeOpenFacilitiesFirstInArray(_ facilitiesArray: List<Facility>) -> [Facility] {
        var open = [Facility]()
        var closed = [Facility]()
        
        for i in facilitiesArray {
            if(Utilities.isOpen(facility: i)) {
                open.append(i)
            }
            else {
                closed.append(i)
            }
        }
        // Test
        return open + closed
    }
    
    func countForOpenAndClosedFacilities(_ facilitiesArray: List<Facility>) -> (open: Int, closed: Int) {
        var open = 0
        var closed = 0
        
        for i in facilitiesArray {
            if(Utilities.isOpen(facility: i)) {
                open += 1
            }
            else {
                closed += 1
            }
        }
        
        return (open, closed)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SRCTSimpleTableViewCell
        
        let dataArray = placeOpenFacilitiesFirstInArray(facilitiesArray)
        let facility = dataArray[indexPath.row]
        cell.nameLabel.text = facility.facilityName
        let open = Utilities.isOpen(facility: facility);
        if(open == true){
            cell.openClosedLabel.text = "Open"
            cell.openClosedLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
        }else{
            cell.openClosedLabel.text = "Closed"
            cell.openClosedLabel.backgroundColor = UIColor.red
        }
        
        cell.timeDescriptionLabel.text = Utilities.timeUntilFacility(facility)
        
        self.reloadInputViews()
        return cell
    }
    
    
    @IBAction func SearchButton(_ sender: Any) {
        print("Hello")
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

