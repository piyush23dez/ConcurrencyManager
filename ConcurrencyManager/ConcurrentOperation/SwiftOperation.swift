//
//  SwiftOperation.swift
//  ConcurrencyManager
//
//  Created by Sharma, Piyush on 9/26/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation


class SwiftOperation: ConcurrentOperation {
    
    override func start() {
        if self.isCancelled {
            state = .isFinished
        }
        else {
            state = .isReady
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .isFinished
        }
        else {
            state = .isExecuting
            
            //Simulate operation
            for index in 1...5 {
                print("Printing index: \(index)")
                sleep(1)
            }
            
            if self.isCancelled {
                state = .isFinished
            }
            else {
                state = .isFinished
            }
        }
    }
}
