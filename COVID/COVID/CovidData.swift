//
//  CovidData.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/8/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation

class CovidData {
    
    init() {
        currData()
    }
    var confirmedCount = "";
    var recoveredCount = "";
    var criticalCount = "";
    var deathCount = "";

    let headers = [
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "e2a05bd873msh763971796116de0p1ebf75jsn0d40cbf09b87"
    ]
    
    func printData() {
        print("Confirmed Count: \(self.confirmedCount)")
        print("Recovered Count: \(self.recoveredCount)")
        print("Critical Count: \(self.criticalCount)")
        print("Death Count: \(self.deathCount)")
    }
    
    func currData() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-data.p.rapidapi.com/totals?format=json")! as URL,
             cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in

            if error != nil {
                print("Error in gathering covid data")
                print(error!)
                return
            }

            var err: NSError?
            do
            {
                // convert data returned into JSON
                let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String:Any]]

                // gather the case data
                let confirmed = myJson[0]["confirmed"]
                let critical = myJson[0]["critical"]
                let deaths = myJson[0]["deaths"]
                let recovered = myJson[0]["recovered"]
                
                self.confirmedCount = confirmed as! String
                self.criticalCount = critical as! String
                self.deathCount = deaths as! String
                self.recoveredCount = recovered as! String
                
                self.printData()
            }
            catch let error as NSError {
                err = error
                print(err!)
            }
        }
        task.resume()
    }

}
