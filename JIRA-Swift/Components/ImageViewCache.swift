//
//  ImageViewCache.swift
//  AnotherSwiftApp
//
//  Created by Andrey Kramar on 5/10/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ImageViewCache: UIImageView {
    
    var task: URLSessionDataTask?
    var curentImageUrl: String?
    var placeHolderImage: UIImage?
    
    public func loadImage(url: String) {
        self.loadImage(url: url, placeHolder: nil)
    }
    
    public func loadImage(url: String, placeHolder: UIImage?) {
        placeHolderImage = placeHolder        
        if let holder = placeHolderImage {
            self.image = holder
        }
        
        let filePath = self.getPath(url: url)
        if (FileManager.default.fileExists(atPath: filePath)) {
            if let image = UIImage(contentsOfFile: filePath) {
                self.setImageAnimated(img: image)
                return
            }
        }
        
        if task != nil && task?.state == .running && url == curentImageUrl {
            return
        } else {
            task?.cancel()
        }
        
        curentImageUrl = url
        makeRequest(url: URL(string: url)!)
    }
    
    private func makeRequest(url: URL) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            self.imageFrom(data: data!, url: url.absoluteString)
        })
        task?.resume()
    }
    
    private func imageFrom(data: Data, url: String) {
        let newImage = UIImage(data: data)
        let filePath = getPath(url: url)
        let filePathUrl = URL(fileURLWithPath: filePath)
        
        do {
            try data.write(to: filePathUrl)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        DispatchQueue.main.async {
            if let holder = self.placeHolderImage {
                self.image = holder
            }
            if newImage != nil {
                self.setImageAnimated(img: newImage!)
            }
        }
    }
    
    private func setImageAnimated(img: UIImage) {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.image = img
        }, completion: nil)
    }
    
    private func pathForFolder() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let folderPath = documentsPath + "/ImageViewCache"
        
        if (FileManager.default.fileExists(atPath: folderPath) == false) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return folderPath
    }
    
    private func getPath(url: String) -> String {
        let file = MD5(string: url)
        let fileUrl = pathForFolder() + "/" + file
        return fileUrl
    }
    
    private func MD5(string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in messageData.withUnsafeBytes {messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)}
        }
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }
}
