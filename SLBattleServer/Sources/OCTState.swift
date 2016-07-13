//
//  OCTState.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//


import Foundation


class OCTState: NSObject {
    
    weak var stateMachine: OCTStateMachine?
    
    
    func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    
    func didEnterWithPreviousState(_ previousState: OCTState?) {
        Logger.debug("previous: \(previousState?.classForCoder) current: \(self.classForCoder)")
    }
    
    
    func willExitWithNextState(_ nextState: OCTState) {
        
    }
    
}




