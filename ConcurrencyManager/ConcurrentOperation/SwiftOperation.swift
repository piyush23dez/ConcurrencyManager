//
//  SwiftOperation.swift
//  ConcurrencyManager
//
//  Created by Sharma, Piyush on 9/26/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation


// This enum contains all the possible states a photo record can be in
enum RestaurantInventoryState {
  case unknown, downloaded, failed
}

struct RestaurantModel {
  var state = RestaurantInventoryState.unknown
  var data = [String : Any]()
}

class SwiftOperation: ConcurrentOperation {
    var restaurantModel: RestaurantModel
    var networkProvider: NetworkProvider
    
    init(restaurantModel: RestaurantModel, networkProvider: NetworkProvider) {
        self.restaurantModel = restaurantModel
        self.networkProvider = networkProvider
    }
    
    // step1    
    override func start() {
        if self.isCancelled {
            state = .isFinished
        }
        else {
            state = .isReady
            main()
        }
    }
    
    // step2
    override func main() {
        
        if self.isCancelled {
            state = .isFinished
            return
        }
        
        state = .isExecuting
        
        networkProvider.fetchInventory() { jsonData in
            if let json = jsonData, !json.isEmpty {
                guard let serializedDictionary = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else { return }
                restaurantModel.state = .downloaded
                restaurantModel.data = serializedDictionary
            } else {
                restaurantModel.state = .failed
            }
                                               
            //After network operation or completion of long running task update state
            if isCancelled {
                state = .isFinished
                print("Task Cancelled")
            }
            else {
                state = .isFinished
                print("Task Finished")
            }
        }
    }   
}
