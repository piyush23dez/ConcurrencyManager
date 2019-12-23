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
        
      let time = self.getTimeIntervalFor(method: getImagesUsingBlockOperation)
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
            let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            //Perform UI updates on main thread
            OperationQueue.main.addOperation {
                //Update UI
                print(image1)
                print("Operation 1 finihsed")
            }
        }
        
        //Perform server operations on background thread
        operationQueue.addOperation {
            let image2 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            //Perform UI updates on main thread
            OperationQueue.main.addOperation {
                //Update UI
                print(image2)
                print("Operation 2 finihsed")
            }
        }
    }
    
    //BlockOperations for downloading images - order of execution decided by system
    func getImagesUsingBlockOperation() {
        let queue = OperationQueue()
        
        let blockOperation1 = BlockOperation {
            let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            OperationQueue.main.addOperation {
                //update ui
                print(image1)
                print("Block Operation1 completed")
            }
        }
        
        let blockOperation2 = BlockOperation {
            let image2 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            //perform ui updates on main thread
            OperationQueue.main.addOperation {
                //update ui
                print(image2)
                print("Block Operation2 completed")
            }
        }
        
        //order of execution decided by system
        queue.addOperation(blockOperation1)
        queue.addOperation(blockOperation2)
    }

    //BlockOperations for downloading images with dependancy - order of execution based on dependency
    func getImagesUsingBlockOperationDependency() {
        let queue = OperationQueue()
        var operations = [Operation]()
        
        let operation1 = BlockOperation {
            let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            OperationQueue.main.addOperation {
                //update ui
                print(image1)
                print("Block Operation1 completed")
            }
        }
        
        let operation2 = BlockOperation {
            let image2 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            //Perform UI updates on main thread
            OperationQueue.main.addOperation {
                //update ui
                print(image2)
                print("Block Operation2 completed")
            }
        }
        
        //Execute operation1 after operation2 is finished
        operation1.addDependency(operation2)
        
        operations.append(operation1)
        operations.append(operation2)
        queue.addOperations(operations, waitUntilFinished: true)
    }
    
    //BlockOperations for downloading images with maxConcurrentOperationCount - order of execution is decided by sequence of addding operations in queue & maxConcurrentOperationCount property
    func getImagesUsingBlockOperationMaxCount() {
        let queue = OperationQueue()
        
        let blockOperation1 = BlockOperation {
            let image1 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            OperationQueue.main.addOperation {
                //update ui
                print(image1)
                print("Block Operation1 completed")
            }
        }
        
        let blockOperation2 = BlockOperation {
            let image2 = Downloader.downloadImgageWithURL(url: imageURLs[0])
            
            //perform ui updates on main thread
            OperationQueue.main.addOperation {
                //update ui
                print(image2)
                print("Block Operation2 completed")
            }
        }
        
        queue.maxConcurrentOperationCount = 1
        queue.addOperation(blockOperation2)// will be executed first
        queue.addOperation(blockOperation1)// will be executed after
    }

    
    //BlockOperations with priority- order of execution decided by priority & maxConcurrentOperationCount property
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
    
    //Custom Operation - order of execution is decided by system if simply adding operations in queue without(dependency, maxConcurrentOperatinCount or priorities)
    func performCustomOperation() {
        let queue = OperationQueue()
        
        let customOperation1 = SwiftOperation()
        customOperation1.completionBlock = {
            if customOperation1.isCancelled {
                 return
            }
            print("Custom operation 1 is completed")
        }
        
        let customOperation2 = SwiftOperation()
        customOperation2.completionBlock = {
            if customOperation2.isCancelled {
                 return
            }
            print("Custom operation 2 is completed")
        }
        
        queue.addOperation(customOperation1)
        queue.addOperation(customOperation2)
    }
    
    func longRunningTaskUsingDispatchGroup() {
        let queue = DispatchQueue.global(qos: .background)
        let group = DispatchGroup()
        let locker = NSLock()
        var finalArray = [Int]()
        
        for index in 1...10 {
            group.enter()
            
            queue.async(group: group, execute: {
                print("Appending item... \(index)")
                
                //thread safe access to array
                locker.lock()
                finalArray.append(index)
                locker.unlock()
                
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
        
        //synchronize on task scheduling completion by waiting on the group to block the current thread.
        group.notify(qos: .background, queue: .main) {
            // This closure will be executed when all tasks are complete
            print("All tasks completed")
        }
        
        //synchronize on task completion by waiting on the group to block the current thread.
        //print("block while waiting on task completion")
        //let _ = group.wait()
        print("continue")
    }
    
    /*
        While DispatchGroup provides a nice and easy way to synchronize a group of asynchronous operations 
        DispatchSemaphore provides a way to synchronously wait for a group of 
        asynchronous tasks.This is very useful in command line tools or scripts, where we don’t have an application run loop, 
        and instead just execute synchronously in a global context until done.
        Like DispatchGroup, the semaphore API is very simple in that we only increment or decrement an internal counter,
        by either calling wait() or signal(). Calling wait() before a signal() will block the current queue until a signal
        is received.
    */
    
    func performOperationWithSemaphore() {
        
        // creating the semaphore with a resource count of 1
        let semaphore = DispatchSemaphore(value: 1)
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        let queue = DispatchQueue.global(qos: .background)
        
        queue.async {           
            for i in 0...10 {
                print(i)
             }
            
            //end access to resource
            semaphore.signal()
        }
        
        // synchronize access to a shared resource using the semaphore
        if case .timedOut = semaphore.wait(timeout: waitTime) {
            print("OMG! Someone was holding on that semaphore!")
        }
        else {
            print("success")
        }
    }
    
    func delay(seconds delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(Int(delay))) {
            closure()
        }
    }
    
    
    //Returns time interval for operation
    func getTimeIntervalFor(method performBlock: (() -> Void)) -> CFTimeInterval {
        
        let start = CACurrentMediaTime()
        performBlock()
        let end = CACurrentMediaTime()
        
        return end - start
    }
    
    
    
   //MARK: Thread safe examples
    
    class Foo {
       var value: Int = 0
       func doIt() {
          for index in 0..<10 {
             value = index
          }
         print(value)
       }
    }

    func threadSafeOperation() {
        let foo = Foo()
        let queue = DispatchQueue.global(qos: .default)
        let locker = NSLock()
    
        for _ in 0..<4 {
          queue.async {
            locker.lock()
            foo.doIt()
            locker.unlock()
           }
        }   
    }
    
    private var value: Int = 0
    func incrementSafe() {
        let queue = DispatchQueue(label: "com.apple.serial")
        queue.sync {
            value += 1
        }
    }

    func deadlock() {
     let queue = DispatchQueue(label: "com.apple.queue")
      //On Serial Dispatch Queue, we have to wait in order to execute Task 2 on the thread that is executing Task 1 right now.
        queue.async {
         //Task1
         queue.sync {
             //Task2
         }
       }
    }
    
    //Thread Safe property   
    private var someValue: Int = 0
    private let serialQueue: DispatchQueue = DispatchQueue(label: "com.queue.serial")

    var state: Int {
     get {
       return serialQueue.sync { someValue }
     }

     set (newValue) {
       serialQueue.sync { someValue = newValue }
     }
   }
    
    
class SafeArray<T> {
    var array = [T]()
    let queue = DispatchQueue(label: "com.concurrent.queue", attributes: .concurrent)
    
    func append(_ item: T) {
        queue.async(flags: .barrier) {
            self.array.append(item)
        }
    }
    
    func values() -> [T] {
        var result = [T]()
        queue.sync {
            result = array
        }
        return result
    }
}

let safeArray = SafeArray<Int>()
var array = [Int]()

DispatchQueue.concurrentPerform(iterations: 10) {  index in
    safeArray.append(index)
}
}

