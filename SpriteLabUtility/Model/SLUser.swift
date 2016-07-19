//
//  SLUser.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 6/27/16.
//  Copyright © 2016 octopus. All rights reserved.
//

//import Foundation


public let KeyID = "id"
public let KeyExp = "exp"
public let KeyCharacters = "characters"
public let KeyTalent = "talent"



public class SLUser: OCTModel {
    
    public let id: String
    
    public var exp: Int
    
    public var characters: [String]
    
    public var talent: [String]
    
    
    
    public required init(fromDictionary dict: Dictionary<String, AnyObject>) {
        self.id = dict[KeyID] as! String
        self.exp = dict[KeyExp] as! Int
        self.characters = dict[KeyCharacters] as! [String]
        self.talent = dict[KeyTalent] as! [String]
        
        
        
        
    }
    
    
    public func toDictionary() -> Dictionary<String, AnyObject?> {
        return [KeyID: self.id, KeyExp: self.exp, KeyCharacters: self.characters, KeyTalent: self.talent]
    }
    
    
    
}
