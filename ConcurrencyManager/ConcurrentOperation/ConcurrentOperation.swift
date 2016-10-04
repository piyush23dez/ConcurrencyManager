//
//  ConcurrentOperation.swift
//  ConcurrencyManager
//
//  Created by Sharma, Piyush on 9/26/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {
    
    // MARK: - Types
    
    //Step 1: define oppration states
    
    enum State {
        case isReady, isExecuting, isFinished
        
        var keyPath: String {
            switch self {
                case .isReady: return "isReady"
                case .isExecuting: return "isExecuting"
                case .isFinished: return "isFinished"
            }
        }
    }    
        
    //Step 2: setup state observers

    var state: State = .isReady {
        
        willSet {
            willChangeValue(forKey: newValue.keyPath) //new value
            willChangeValue(forKey: state.keyPath)    //current value
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath) //old value
            didChangeValue(forKey: state.keyPath)    //current value
        }
    }
    
    
    //Step 3: override state properties
    
    override var isReady: Bool {
        return super.isReady && state == .isReady
    }
    
    override var isExecuting: Bool {
        return state == .isExecuting
    }
    
    override var isFinished: Bool {
        return state == .isFinished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
}
