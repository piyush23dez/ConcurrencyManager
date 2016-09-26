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
    
    enum State {
        
        case isReady, isExecuting, isFinished
        
        func keyPath() -> String {
            
            switch self {
            case .isReady:
                return "isReady"
            case .isExecuting:
                return "isExecuting"
            case .isFinished:
                return "isFinished"
            }
        }
    }
    
    //MARK: Properties
    
    var state: State = .isReady {
        
        willSet {
            willChangeValue(forKey: newValue.keyPath())
           // willChangeValue(forKey: state.keyPath())
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath())
            //didChangeValue(forKey: state.keyPath())
        }
    }
    
    
    //MARK: Override Operation States
    
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
