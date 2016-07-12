//
//  OCTModel.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 6/28/16.
//  Copyright © 2016 octopus. All rights reserved.
//

public protocol OCTModel {
    
    init(fromDictionary: Dictionary<String, AnyObject>)
    
    func toDictionary() -> Dictionary<String, AnyObject?>
    
//    static func createFromDictionary(dict: Dictionary<String, AnyObject?>) -> Self
    
}
