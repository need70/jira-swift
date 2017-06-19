//
//  Attachment.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class Attachment: Mappable {
    
    var fileName: String?
    var author: User?
    var size: CLongLong?
    var createdDate: String?
    var mimeType: String?
    var content: String?
    var thumbnail: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        fileName    <- map["filename"]
        author      <- map["author"]
        size        <- map["size"]
        createdDate <- map["created"]
        mimeType    <- map["mimeType"]
        content     <- map["content"]
        thumbnail   <- map["thumbnail"]
    }
    
    func formattedDate() -> String {
        if let created = createdDate {
            return Utils.formattedDateFrom(dateStr: created)
        }
        return ""
    }
    
    func prettySizeString() -> String {
        if size != nil {
            let str = ByteCountFormatter.string(fromByteCount: size!, countStyle: .binary)
            return str
        }
        return "N/A"
    }
}

