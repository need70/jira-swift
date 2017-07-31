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
    var svgView: SVGView?
    
    public func loadImage(url: String?) {
        
        guard let path = url else { return }
        self.loadImage(url: path, placeHolder: nil)
    }
    
    public func loadImage(url: String?, placeHolder: UIImage?) {
        
        placeHolderImage = placeHolder
        if let holder = placeHolderImage {
            self.image = holder
        }

        if let url = url {
            for view in self.subviews {
                view.removeFromSuperview()
            }
            
            let filePath = self.getPath(url: url)
            if (FileManager.default.fileExists(atPath: filePath)) {
                if let image = UIImage(contentsOfFile: filePath) {
                    self.setImageAnimated(img: image)
                    return
                } else { //not png or jpeg, trying to load as svg
                    self.svgView = SVGView.init(frame: self.frame)
                    svgView!.loadSVGfromPath(filePath)
                }
            }
            
            if let task = task, task.state == .running, url == curentImageUrl {
                return
            } else {
                task?.cancel()
            }
            
            curentImageUrl = url
            makeRequest(url: URL(string: url)!)
        }
    }
    
    private func makeRequest(url: URL) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let responseData = data else { return }
            self.imageFrom(data: responseData, url: url.absoluteString)
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
        
        if (newImage == nil) { //not png or jpeg, trying to load as svg
            loadSVGImage(url)
        } else {
            loadUIImage(newImage)
        }
    }
    
    func loadSVGImage(_ url: String) {
        DispatchQueue.main.async {
            self.svgView = SVGView.load(url: url, view: self)
        }
    }
    
    func loadUIImage(_ newImage: UIImage?)
    {
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

class SVGView : UIWebView, UIWebViewDelegate {
    var viewForImage: UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func load(url: String, view: UIImageView) -> SVGView {
        
        var frame: CGRect = .zero
        frame.size = view.frame.size
        let svgView = SVGView(frame: frame)
        
        svgView.backgroundColor = .clear
        svgView.isOpaque = false
        
        svgView.delegate = svgView
        svgView.viewForImage = view
        svgView.loadSVGfromUrl(url)
        
        return svgView
    }
    
    private func loadSVGfromUrl(_ url: String) {
        self.scrollView.isScrollEnabled = false
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        self.loadRequest(request)
    }
    
    func loadSVGfromPath(_ path: String) {
        self.scrollView.isScrollEnabled = false
        let url = URL(fileURLWithPath: path)
        let text2 = try? String(contentsOf: url, encoding: String.Encoding.utf8)
        if let text2 = text2 {
            self.loadHTMLString(text2, baseURL: nil)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let viewForImage = viewForImage {
            self.frame.size = viewForImage.frame.size
            self.viewForImage?.image = nil
            viewForImage.addSubview(self)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("error")
    }

}
