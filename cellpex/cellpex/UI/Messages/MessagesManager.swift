//
//  MessagesManager.swift
//  cellpex
//
//  Created by Ciprian Iloc on 17/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

final class MessagesManager: NSObject {
    var messages = [InboxMessagesModel]()
    var originalEndPoint : String
    var lastRequestedPage = 1
    private var responseHandler : (()->())?
    private(set) var shoulShowRefreshFooter = true
    
    init(endPoint : String) {
        originalEndPoint = endPoint
    }
    
    func requestFirstTimeMessages(successHandler: @escaping ()->()) {
        self.lastRequestedPage = 1
        self.responseHandler = successHandler
    }
    
    func reloadMessages(successHandler: @escaping ()->()) {
        self.lastRequestedPage = 1
        self.responseHandler = successHandler
    }
    
    func requestNextPage(successHandler: @escaping ()->()) {
        lastRequestedPage = lastRequestedPage + 1
        self.responseHandler = successHandler
        let endPoint = originalEndPoint + "?pag=\(lastRequestedPage)"
    }
    
    private func loadProducts(messagesArray:[[String: Any?]?]?) {
        self.shoulShowRefreshFooter = false
        if let listOfMessages = messagesArray {
            self.shoulShowRefreshFooter = (listOfMessages.count == 20)
            for message in listOfMessages {
//                let messageModel = MessageModel()
//                self.messages.append(messageModel)
            }
        }
        self.responseHandler?()
    }
}
