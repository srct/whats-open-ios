//
//  SRCTNetworkController.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 26/10/2016.
//  Copyright © 2016 SRCT. All rights reserved.
//

import UIKit

class SRCTNetworkController: NSObject {
    
    
   public static func performDownload(completion: @escaping (_ result: Array<Facility>) -> Void) {
        let requestURL: NSURL = NSURL(string: "https://whatsopen.gmu.edu/api/facilities/?format=json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
               
               if let dataN = data {

                    
                    let json = try! JSONSerialization.jsonObject(with: dataN, options: []) as! Array<Any>
                    
                    
                    var facilities = Array<Facility>()
                   
                    for f in json  {
                        let fJson = f as! [String: Any]
                        if let facility = Facility(json: fJson) {
                            facilities.append(facility)
                        }
                 }

                    //print(facilities)
                    completion(facilities)
                    
                }

            }
        }
        
        task.resume()
    }

}
