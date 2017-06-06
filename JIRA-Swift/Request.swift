//
//  Request.swift
//  Created by Andriy Kramar on 7/27/16.
//

import UIKit

class Request: NSObject {
    
    func sendPOST(url: String, params: [String : String], sBlock: @escaping anyBlock, eBlock: @escaping errorBlock) {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    eBlock(err)
                }
                
                if let responseData = data {
                    let dict = self.handleResponseData(responseData)
                    sBlock(dict)
                }
            }
        })
        task.resume()
    }
    
    func sendGET(url: String, sBlock: @escaping anyBlock, eBlock: @escaping errorBlock) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    eBlock(err)
                }
                
                if let responseData = data {
                    let obj = self.handleResponseData(responseData)
                    sBlock(obj)
                }
            }
        })
        task.resume()
    }
    
    func handleResponseData(_ data: Data) -> Any {
        
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        if let dict = json as? [String : Any] { // json is a dictionary
            return dict
        } else if let array = json as? [Any] { // json is an array
            return array
        } else {
            print("JSON is invalid")
        }
        return (Any).self
    }
    
}
