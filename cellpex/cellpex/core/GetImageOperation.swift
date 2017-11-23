//
//  GetImageOperation.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/23/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit


extension NSLock {
    
    func withCriticalScope<T>( block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}

class GetImageOperation: Operation {
    let URLString: String?
    let networkOperationCompletionHandler: (Data?, URLResponse?, Error?) -> ()
    weak var request:URLSessionDataTask?
    
    
    init(URLString: String?, networkOperationCompletionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        self.URLString = URLString
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        super.init()
    }
    
    
    override var isAsynchronous: Bool {
        return true
    }
    private let stateLock = NSLock()
    
    private var _executing = false
    
    override private(set) public var isExecuting: Bool {
        get {
            return stateLock.withCriticalScope { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished: Bool = false
    override private(set) public var isFinished: Bool {
        get {
            return stateLock.withCriticalScope { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    public func completeOperation() {
        if isExecuting {
            isExecuting = false
        }
        
        if !isFinished {
            isFinished = true
        }
    }
    
    override public func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        main()
    }
    
    override public func main() {
        if let urlString = URLString {
            if let url = URL(string: urlString) {
                request = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                    self?.networkOperationCompletionHandler(data, response, error)
                    self?.completeOperation()
                }
                request?.resume()
            } else {
                self.networkOperationCompletionHandler(nil, nil, nil)
                self.completeOperation()
            }
        } else {
            self.networkOperationCompletionHandler(nil, nil, nil)
            self.completeOperation()
        }
    }
    
    override func cancel() {
        request?.cancel()
        super.cancel()
    }
}
