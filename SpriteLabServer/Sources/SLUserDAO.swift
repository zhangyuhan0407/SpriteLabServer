//
//  SLUserDAO.swift
//  SpriteLabServer
//
//  Created by yuhan zhang on 6/28/16.
//
//




class SLUserDAO: OCTDAO {
    
    
    static var sharedInstance = SLUserDAO()
    
    
    private init() {}
    
    
    typealias Model = SLUser
    
    
    static var TableName: String = "sluser"
    
    static var PrimaryKey: String = "id"
    
    
    
}
