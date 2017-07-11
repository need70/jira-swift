//
//  Request.swift
//  Created by Andriy Kramar on 7/27/16.
//

import UIKit

let kRequestTimeOut = 15.0

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class Request: NSObject {
    
    fileprivate var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = kRequestTimeOut
        let session = URLSession(configuration: configuration)
        return session
    }
    
    fileprivate func request(for method: RequestMethod, url: String, params: Any?) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)

        switch method {
            case .post, .put:
                var data: Data?
                if params is [String : String] {
                    data = try! JSONSerialization.data(withJSONObject: params as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                } else if (params is String) {
                    let string = params as! String
                    data = string.data(using: String.Encoding.utf8)!
                }
                request.httpBody = data
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = method.rawValue
                return request
                
            default:
                request.httpMethod = method.rawValue
                return request
        }
    }
    
    func send(method: RequestMethod, url: String, params: Any?, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
        let request = self.request(for: method, url: url, params: params)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
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
    
    fileprivate func handleResponseData(data: Data, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
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
