//
//  ViewController.swift
//  ConcurrencyManager
//
//  Created by Sharma, Piyush on 9/4/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg", "http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"]

class Downloader {
    
    class func downloadImgageWithURL(url: String) -> UIImage? {
        
        do {
            let data = try Data(contentsOf: URL(string: url)!)
            return UIImage(data: data)
        }
        catch let error {
            print(error)
        }
        return nil
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      let time = self.getTimeIntervalFor(method: performOperationsWithPriorities)
      print("time taken for running method: \(time)")
    }
    
    @IBAction func buttonTouched(_ sender: AnyObject) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadImages() {
        
        let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
        let image2 = Downloader.downloadImgageWithURL(url: imageURLs[1])
        let image3 = Downloader.downloadImgageWithURL(url: imageURLs[2])
        let image4 = Downloader.downloadImgageWithURL(url: imageURLs[3])
        print(image1, image2, image3, image4)
    }
    
    //DispatchQueue for downloading images
    func getImagesUsingDisptachQueue() {
        
        //Dispatch queues
        
        //System provided global 'concurrent disptach queue'
        let concurrentQueue = DispatchQueue.global(qos: .background)
        
        //User created 'concurrent dispatch queue'
        //let customConcurrentQueue = DispatchQueue(label: "com.apple.concurrent", qos: .default, attributes: .concurrent)
        
        //User created serial dispatch queue
        //let serialQueue = DispatchQueue(label: "com.apple.serial")
        
        
        //Perform server operations on background thread
        concurrentQueue.async {
            //let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
    
            //Perform UI updates on main thread
            DispatchQueue.main.async {
                //Update UI
                //self.imageView.image = image1
            }
        }
        
        //Perform server operations on background thread
        concurrentQueue.async {
            //let image2 = Downloader.downloadImgageWithURL(url: imageURLs[1])

            //Perform UI updates on main thread
            DispatchQueue.main.async {
                //Update UI
                //self.imageView.image = image2

            }
        }
    }
    
    //OperationQueue for downloading images - order of execution decided by system
    func getImagesUsingOperationQueue() {
        
        let operationQueue = OperationQueue()
        
        //Perform server operations on background thread
        operationQueue.addOperation {
            //let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            //Perform UI updates on main thread
            OperationQueue.main.addOperation {
                //Update UI
                //self.imageView.image = image1
                print("Operation 1 finihsed")
            }
        }
        
        //Perform server operations on background thread
        operationQueue.addOperation {
            //let image2 = Downloader.downloadImgageWithURL(url: imageURLs[1])
            
            //Perform UI updates on main thread
            OperationQueue.main.addOperation {
                //Update UI
                //self.imageView.image = image2
                print("Operation 2 finihsed")
            }
        }
        
    }
    
    //BlockOperation for downloading images with dependancy - order of execution based on dependency
    func getImagesUsingBlockOperation() {
        let queue = OperationQueue()
        var operations = [Operation]()
        
        let operation1 = BlockOperation {
            //let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            OperationQueue.main.addOperation {
                //Update UI
                print("Operation1 completed")
            }
        }
        
        let operation2 = BlockOperation {
            let image2 = Downloader.downloadImgageWithURL(url: imageURLs[1])
            
            //Perform UI updates on main thread
            OperationQueue.main.addOperation {
                //Update UI
                print(image2)
                print("Operation2 completed")
            }
        }
        
        //Execute operation1 after operation2 is finished
        operation1.addDependency(operation2)
        
        operations.append(operation1)
        operations.append(operation2)
        queue.addOperations(operations, waitUntilFinished: true)
    }
    
    //BlockOperations with priority- order of execution decided by priority
    func performOperationsWithPriorities() {
        let queue = OperationQueue()
        
        let operation1 = BlockOperation {}
        let operation2 = BlockOperation {}
        
        operation1.completionBlock = {
            print("Operation1 finished")
        }
        
        operation2.completionBlock = {
            print("Operation2 finished")
        }
        
        operation1.queuePriority = .low
        operation2.queuePriority = .high
        
        queue.maxConcurrentOperationCount = 1
        queue.addOperations([operation1, operation2], waitUntilFinished: true)
    }
    
    //Custom Operation Class - order of execution is in sequnce
    func performCustomOperation() {
        let queue = OperationQueue()
        
        let customOperation1 = SwiftOperation()
        customOperation1.completionBlock = {
            print("Custom operation 1 is completed")
        }
        
        let customOperation2 = SwiftOperation()
        customOperation2.completionBlock = {
            print("Custom operation 2 is completed")
        }
        
        queue.maxConcurrentOperationCount = 1
        queue.addOperation(customOperation1)
        queue.addOperation(customOperation2)
    }
    
    func longRunningTaskUsingDispatchGroup() {
        let queue = DispatchQueue.global(qos: .background)
        let group = DispatchGroup()
        
        var finalArray = [Int]()
        
        for index in 1...10 {
            group.enter()
            
            queue.async(group: group, execute: {
                print("Appending item... \(index)")
                DispatchQueue.main.async {
                    finalArray.append(index)
                }
                group.leave()
            })
        }
        
        group.notify(qos: .background, queue: .main) {
            print("All Done \(finalArray.count)")
        }
    }
    
        
    func createDispatchGroup() {
        let queue = DispatchQueue.global(qos: .background)
        let group = DispatchGroup()
        
        //do some work
        group.enter()
        queue.async {
            print("Task 1 started")
            self.delay(seconds: 10, closure: {
                print("Task 1 finished")
                group.leave()
            })
        }
        
        //do some more work
        group.enter()
        queue.async {
            print("Task 2 started")
            self.delay(seconds: 20, closure: {
                print("Task 2 finished")
                group.leave()
            })
        }

        //add some work
        group.enter()
        queue.async {
            print("Task 3 started")
            print("Task 3 finished")
            group.leave()
        }
        
        // synchronize on task scheduling completion by waiting on the group to block the current thread.
        group.notify(qos: .background, queue: .main) {
            // This closure will be executed when all tasks are complete
            print("All tasks completed")
        }
        
        // synchronize on task completion by waiting on the group to block the current thread.
        //print("block while waiting on task completion")
        //let _ = group.wait()
        print("continue")
    }
    
    func delay(seconds delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(Int(delay))) {
            closure()
        }
    }
    
     class Person {
        var name: String
        var age: Int
        
        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }
        
        func update(name: String, age: Int) {
            self.name = name
            self.age = age
        }
    }
    
    var person = Person (name: "Leo", age: 22)

    func threadSafeMultiThreading() {
        let locker  = NSRecursiveLock()
        let queue1 = DispatchQueue(label: "Serial1")
        let queue2 = DispatchQueue(label: "Serial2")
        
        queue1.async {
            self.delay(seconds: 1, closure: {
                locker.lock()
                self.person.update(name: "Jack", age: 20)
                locker.unlock()
            })
        }
        
        queue2.async {
            self.delay(seconds: 1, closure: {
                locker.lock()
                self.person.update(name: "Lucy", age: 25)
                locker.unlock()
                
            })
        }
        
        perform(#selector(ViewController.handleAsyncResult), with: nil, afterDelay: 4)
    }
    
    func handleAsyncResult() {
     print(person.name,person.age)
    }

    
    //Returns time interval for operation
    func getTimeIntervalFor(method performBlock: (() -> Void)) -> TimeInterval {
        let start = Date()
        performBlock()
        let end = Date()
        
        let timeInterval = end.timeIntervalSince(start)
        return timeInterval
    }
}

