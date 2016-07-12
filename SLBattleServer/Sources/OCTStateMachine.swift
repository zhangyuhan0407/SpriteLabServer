//
//  OCTStateMachine.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

class OCTStateMachine {
    
    var currentState: OCTState?
    
    private var states = [OCTState]()
    
    
    init(_ states: [OCTState]) {
        self.states = states
    }
    
    
    
    func canEnterStates(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    
    func enterState(stateClass: OCTState.Type) -> Bool {
        //        self.currentState = stateForClass(stateClass.dynamicType)
        
        if currentState != nil {
            currentState!.willExitWithNextState(self.stateForClass(stateClass)!)
        }
        
        
        if canEnterStates(stateClass) {
            let prevState = currentState
            self.currentState = stateForClass(stateClass)
            
            currentState?.didEnterWithPreviousState(prevState)
            
            return true
        }
        
        return false
    }
    
    func stateForClass<state: OCTState>(_ stateClass: state.Type) -> state? {
        for com in self.states {
            if let ret = com as? state {
                return ret
            }
            
            //            if com.classForCoder == stateClass {
            //                return com as? state
            //            }
        }
        return nil
    }
}












