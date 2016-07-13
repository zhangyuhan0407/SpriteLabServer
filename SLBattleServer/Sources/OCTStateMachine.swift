//
//  OCTStateMachine.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class OCTStateMachine {
    
    var currentState: OCTState?
    
    private var states = [OCTState]()
    
    
    init(_ states: [OCTState]) {
        self.states = states
    }
    
    
    
    func canEnterStates(_ stateClass: AnyClass) -> Bool {
        if currentState == nil {
            return true
        }
        
        return self.currentState!.isValidNextState(stateClass)
    }
    
    
    func enterState(stateClass: OCTState.Type) -> Bool {

        if currentState != nil {
            currentState!.willExitWithNextState(self.stateForClass(stateClass)!)
        }
        
        if canEnterStates(stateClass) {
            let prevState = currentState
            self.currentState = stateForClass(stateClass)
            
            currentState!.didEnterWithPreviousState(prevState)
            return true
        }
        
        return false
    }
    
    func stateForClass<state: OCTState>(_ stateClass: state.Type) -> state? {
        for com in self.states {
            if com.classForCoder == stateClass {
                return com as? state
            }
        }
        return nil
    }
}












