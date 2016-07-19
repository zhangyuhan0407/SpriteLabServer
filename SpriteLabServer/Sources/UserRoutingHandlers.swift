//
//  UserRoutingHandlers.swift
//  SpriteLabServer
//
//  Created by yuhan zhang on 6/27/16.
//
//


import PerfectLib
import PostgreSQL
import Foundation
import SwiftyJSON



func getUserInfo(request: WebRequest, _ response: WebResponse) {

    
    let id = request.urlVariables["id"]!
    
    if let user = SLUserDAO.sharedInstance.findOne(id: id) {
        
//        user.exp = 60
//        user.characters = ["zc", "zyh"]
//        user.talent = ["fire", "water"]
//        
//        SLUserDAO.sharedInstance.save(user)
        
        response.appendBody(string: "\(user.toJSON())")
        
        let user2 = SLUser(fromJSON: user.toJSON())
        
        user2.exp = 123
        user2.talent = ["123", "456"]
        
        print(user2.toJSON())
        
        
        
    } else {
        
        let u = SLUser(fromDictionary: ["id": "3", "exp":99, "characters": ["char1", "char2"], "talent": ["tal1", "tal2"]])
        
        SLUserDAO.sharedInstance.save(u)
        
        response.appendBody(string: "\(u.toDictionary())")
    }
    
    
    
    response.requestCompleted()
    
    
}



func getUsersInfo(request: WebRequest, _ response: WebResponse) {
    let ids = request.params(named: "ids")
    for id in ids {
        if let user = SLUserDAO.sharedInstance.findOne(id: id) {
            response.appendBody(string: "\(user.toDictionary())")
        } else {
            response.appendBody(string: "\(SLUser.random().toDictionary())")
        }
    }
    
    
    response.requestCompleted()
    
}











