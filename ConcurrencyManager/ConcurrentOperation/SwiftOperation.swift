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
            
            //After network operation or completion of long running task update state
            if self.isCancelled {
                state = .isFinished
                print("Task Cancelled")
            }
            else {
                state = .isFinished
                print("Task Finished")
            }
            
            
            //Asynchronous logic (eg: n/w calls) with callback {
            //     if self.cancelled {
            //        state = .Finished
            //     }
            //     else {
            //         Perform any final operations on data from server
            //         state = .Finished
            //     }
            // }
        }
    }
}
