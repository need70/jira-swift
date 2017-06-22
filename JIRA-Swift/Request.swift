//
//  Request.swift
//  Created by Andriy Kramar on 7/27/16.
//

import UIKit

class Request: NSObject {
    
    func sendPOST(url: String, params: Any, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
        var data: Data?
        
        if params is [String : String] {
            data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } else if (params is String) {
            let string = params as! String
            data = string.data(using: String.Encoding.utf8)!
        }
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    errorBlock(err.localizedDescription)
                }
                
                if let responseData = data {
                    self.handleResponseData(data: responseData, successBlock: successBlock, errorBlock: errorBlock)
                }
            }
        })
        task.resume()
    }
    
    func sendDELETE(url: String, params: Any, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
        var data: Data?
        
        if params is [String : String] {
            data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } else if (params is String) {
            let string = params as! String
            data = string.data(using: String.Encoding.utf8)!
        }
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "DELETE"
        request.httpBody = data
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    errorBlock(err.localizedDescription)
                }
                
                if let responseData = data {
                    self.handleResponseData(data: responseData, successBlock: successBlock, errorBlock: errorBlock)
                }
            }
        })
        task.resume()
    }
    
    func sendGET(url: String, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    errorBlock(err.localizedDescription)
                }
                
                if let responseData = data {
                    self.handleResponseData(data: responseData, successBlock: successBlock, errorBlock: errorBlock)
                }
            }
        })
        task.resume()
    }
    
    func handleResponseData(data: Data, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
        if let convertedString = String(data: data, encoding: String.Encoding.utf8) {
            print("jsonString = \n \(convertedString)")
        }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let dict = json as? [String : Any] { // json is a dictionary
            
            if let errors = dict["errorMessages"] as? [String] {
                let errorString = errors.first
                errorBlock(errorString)
            } else {
                successBlock(dict)
            }
            
        } else if let array = json as? [Any] { // json is an array
            successBlock(array)
        } else {
            successBlock("")
            print("not JSON data recieved")
        }
    }
    
}
