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

class Request {
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = kRequestTimeOut
        let session = URLSession(configuration: configuration)
        return session
    }
    
    private func request(for method: RequestMethod, url: String, params: Any?) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)

        switch method {
            case .post, .put:
                var data: Data?
                if params is [String : Any] {
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
                
                if let responseData = data, let httpResponse = response as? HTTPURLResponse {
                    print("statusCode = \(httpResponse.statusCode)")
                    self.handleResponseData(data: responseData, response: httpResponse, successBlock: successBlock, errorBlock: errorBlock)
                }
            }
        })
        task.resume()
    }
    
    private func handleResponseData(data: Data, response: HTTPURLResponse, successBlock: @escaping anyBlock, errorBlock: @escaping stringBlock) {
        
        if let convertedString = String(data: data, encoding: String.Encoding.utf8) {
            print("jsonString = \n \(convertedString)")
        }
        
        if response.statusCode == 404 { //check for tempo plugin)
            errorBlock("Oops, you got 404, perhaps plugin not installed.")
            return
        }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let dict = json as? [String : Any] { // json is a dictionary

            if let errDict = dict["errors"] as? [String : String], let errString = errDict.values.first {
                errorBlock(errString)
                return
            }
            
            if let errors = dict["errorMessages"] as? [String], let errorString = errors.first {
                errorBlock(errorString)
                return
            }
            successBlock(dict)
            
        } else if let array = json as? [Any] { // json is an array
            successBlock(array)
        } else {
            successBlock("")
            print("not JSON data recieved")
        }
    }
}
