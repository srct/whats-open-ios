//
//  SRCTNetworkController.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 26/10/2016.
//  Copyright © 2016 SRCT. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class SRCTNetworkController: NSObject {
    //Use this for testing with the new API, might make it possible to get stuff moving pre official release 
    //https://api.srct.gmu.edu/whatsopen/v2/facilities/?format=json    
   public static func performDownload(completion: @escaping (_ result: Array<Facility>) -> Void) {
    
    let realm = try! Realm()
    let requestURL: NSURL = NSURL(string: "https://api.srct.gmu.edu/whatsopen/v2/facilities/?format=json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
               
                if let dataN = data {

                    //var schedules = Array
                    //Finish this, and fix the function
                    try! realm.write(){
                        let json = try? JSONSerialization.jsonObject(with: dataN, options: [])
                        realm.create(Facility.self, value: json!, update: true)
                    }
                
                
                }
                
                    
                    
                    
            }
            
    }
    
    print(Facility.self)
    task.resume()

    }
    
}


