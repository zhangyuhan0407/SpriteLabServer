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
        user.name = "zyh"
        SLUserDAO.sharedInstance.save(user)
        
        if let user2 = SLUserDAO.sharedInstance.findOne(id: id) {
            response.appendBody(string: "user name: \(user2.name)")
        } else {
            response.appendBody(string: "user2 save error")
        }
        
        
    } else {
        response.appendBody(string: "user empty")
    }
    
    
    
    
    
    
    
    
    
//    let result = pg.exec("select * from users")
//    let status = result.status()
//    
//    
//    var params = Dictionary<String, String>()
//    
//    if status == .CommandOK || status == .TuplesOK {
//        
//        if result.numFields() == 0 || result.numTuples() == 0 {
//            response.appendBody(string: "result empty")
//        }
//        
//        for i in 0..<result.numFields() {
//            params.updateValue(result.getFieldString(tupleIndex: 0, fieldIndex: i)!, forKey: result.fieldName(index: i)!)
//        }
//        
//        response.appendBody(string: "\(params)")
//    }
//    else {
//        response.appendBody(string: "query error")
//    }
    
    
//    let date = NSDate()
//    let id = request.urlVariables["id"]
//    
////    var dict = Dictionary<String, AnyObject>()
////    dict.updateValue(date, forKey: "date")
////    dict.updateValue(id!, forKey: "id")
////    
////    let cao = ["id": id!]
//    
//    let json = JSON(["id": id!, "date": date])
    
    
//    response.appendBody(string: "\(json)")
    response.requestCompleted()
    
    
}
