//
//  OCTState.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//



class OCTState {
    
    weak var stateMachine: OCTStateMachine?
    
    
    func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    
    func didEnterWithPreviousState(_ previousState: OCTState?) {
        
    }
    
    
    func willExitWithNextState(_ nextState: OCTState) {
        
    }
    
}



class BTSocketState: OCTState {
    weak var socket: BTSocket?
    
    init(socket: BTSocket) {
        self.socket = socket
    }
    
}
