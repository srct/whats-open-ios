//
//  Reachability.swift
//  WhatsOpen
//
//  Created by Eyad Hasan on 9/10/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var status:Bool = false
        
        let url = URL(string: "https://api.srct.gmu.edu/whatsopen/v2/facilities/?format=json")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response:URLResponse?
        
        do {
            //let _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
            let _ = try URLSession.dataTaskWithRequest(request as URLRequest, completionHandler: &response)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
    }
}
