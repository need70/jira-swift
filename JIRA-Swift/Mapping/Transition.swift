
import Foundation
import ObjectMapper

class Transition: Mappable {
    
    var transitionId: String?
    var name: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        transitionId  <- map["id"]
        name          <- map["name"]
    }
}


/*
 
 {
 "id": "11",
 "name": "Backlog",
 "to": {
 "self": "https://need70.atlassian.net/rest/api/2/status/10000",
 "description": "",
 "iconUrl": "https://need70.atlassian.net/",
 "name": "Backlog",
 "id": "10000",
 "statusCategory": {
 "self": "https://need70.atlassian.net/rest/api/2/statuscategory/2",
 "id": 2,
 "key": "new",
 "colorName": "blue-gray",
 "name": "To Do"
 }
 },
 "hasScreen": false
 },
 */
