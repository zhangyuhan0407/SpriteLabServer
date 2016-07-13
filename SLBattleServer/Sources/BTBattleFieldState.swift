//
//  BTBattleFieldStates.swift
//  SLBattleServer
//
//  Created by yuhan zhang on 7/12/16.
//
//

import Foundation


class BTBattleFieldState: OCTState {
    
    weak var battleField: BTBattleField?
    
    
    init(_ bf: BTBattleField) {
        self.battleField = bf
    }
    
    
    
}














