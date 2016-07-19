//
//  BTSocketStateFighting.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTSocketFighting: BTSocketState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is BTSocketEnding.Type || stateClass is BTSocketDisconnected.Type
    }
    
    
    override func didEnterWithPreviousState(_ previousState: OCTState?) {
        super.didEnterWithPreviousState(previousState)

        
    }
    
}
