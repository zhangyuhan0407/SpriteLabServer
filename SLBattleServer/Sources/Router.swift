//
//  Router.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 6/30/16.
//
//

import PerfectLib


public func PerfectServerModuleInit() {
    print("PerfectServerModuleInit")
    addURLRoutes()
}



func addURLRoutes() {
    
    let _ = BTBattleFieldManager.sharedInstance
    BTLoop.start()
    
    Routing.Routes["*"] = { request, response in StaticFileHandler().handleRequest(request: request, response: response) }
    
    
    Routing.Routes["/folder"] = {
        request, response in
    
        response.appendBody(string: "<html><title>Hello, Folder!</title><body>Hello, world!</body></html>")
        response.requestCompleted()
    }
    
    
    Routing.Routes[.get, "/nextbattlefieldid"] = { request, response in
        response.appendBody(string: BTBattleFieldManager.sharedInstance.nextBattleFieldID())
        response.requestCompleted()
    }
    
    
    // Add the endpoint for the WebSocket example system
    Routing.Routes[.get, "/synchronization"] = {
        request, response in
        
        // To add a WebSocket service, set the handler to WebSocketHandler.
        // Provide your closure which will return your service handler.
        WebSocketHandler(handlerProducer: {
            (request: WebRequest, protocols: [String]) -> WebSocketSessionHandler? in
            
            // Check to make sure the client is requesting our "echo" service.
            guard protocols.contains("SynchronizationHandler") else {
                return nil
            }
            
            // Return our service handler.
            
            
            return SynchronizationHandler()
        }).handleRequest(request: request, response: response)
    }
    
}
