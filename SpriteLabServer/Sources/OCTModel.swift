//
//  OCTModel.swift
//  SpriteLabClient
//
//  Created by yuhan zhang on 6/28/16.
//  Copyright © 2016 octopus. All rights reserved.
//

public protocol OCTModel {
    
    init(fromDictionary: ［String: AnyObject?])
    
    func toDictionary() -> [String: AnyObject?]
    
}

