//
//  SLUser.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 6/27/16.
//  Copyright © 2016 octopus. All rights reserved.
//

//import Foundation


public class SLUser: OCTModel {
    
    public let id: String
    
    public var name: String?
    
    
    public required init(fromDictionary dict: Dictionary<String, AnyObject>) {
        self.id = dict["id"] as! String
        self.name = dict["name"] as? String
    }
    
    
    public func toDictionary() -> Dictionary<String, AnyObject?> {
        return ["id": self.id, "name": self.name]
    }
    
    
//    public static func createFromDictionary(dict: Dictionary<String, AnyObject?>) -> Self {
//        return Self(fromDictionary: dict)
//    }
    
}
