//
//  MessagesManager.swift
//  cellpex
//
//  Created by Ciprian Iloc on 17/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

final class MessagesManager: NSObject {
    var inboxMessages = [InboxMessagesModel]()
    var sentMessages = [SentMessagesModel]()

    var lastRequestedPage = 1
    private var responseHandler : (()->())?
    private(set) var shoulShowRefreshFooter = true
    
    func reloadInboxMessages(successHandler: @escaping ()->()){
        self.lastRequestedPage = 1
        self.responseHandler = successHandler
        NetworkManager.getMessages(endPoint: WebServices.getInboxMessages, successHandler: { [weak self](messages : [[String: Any?]?]?) in
            self?.loadInboxMessages(messagesArray: messages)

        }) { (errorMessage : String) in
            
        }
    }
    func reloadSentMessages(successHandler: @escaping ()->()) {
        self.lastRequestedPage = 1
        self.responseHandler = successHandler
        NetworkManager.getMessages(endPoint: WebServices.getSendMessages, successHandler: { [weak self](messages : [[String: Any?]?]?) in
            self?.loadSentMessages(messagesArray: messages)
        }) { (errorMessage : String) in
            
        }
    }
    
    func requestInboxNextPage(successHandler: @escaping ()->()) {
        lastRequestedPage = lastRequestedPage + 1
        self.responseHandler = successHandler
        let endPoint = WebServices.getInboxMessages + "?pag=\(lastRequestedPage)"
        NetworkManager.getMessages(endPoint: endPoint, successHandler: { [weak self](messages : [[String: Any?]?]?) in
            self?.loadInboxMessages(messagesArray: messages)
        }) { (errorMessage : String) in
            
        }
    }
    
    func requestSentNextPage(successHandler: @escaping ()->()) {
        lastRequestedPage = lastRequestedPage + 1
        self.responseHandler = successHandler
        let endPoint = WebServices.getSendMessages + "?pag=\(lastRequestedPage)"
        NetworkManager.getMessages(endPoint: endPoint, successHandler: { [weak self](messages : [[String: Any?]?]?) in
            self?.loadSentMessages(messagesArray: messages)
        }) { (errorMessage : String) in
            
        }
    }
    
    private func loadInboxMessages(messagesArray:[[String: Any?]?]?) {
        self.shoulShowRefreshFooter = false
        if let listOfMessages = messagesArray {
            self.shoulShowRefreshFooter = (listOfMessages.count == 20)
            for message in listOfMessages {
                let messageModel = InboxMessagesModel(dictionary: message)
                self.inboxMessages.append(messageModel)
            }
        }
        self.responseHandler?()
    }
    
    private func loadSentMessages(messagesArray:[[String: Any?]?]?) {
        self.shoulShowRefreshFooter = false
        if let listOfMessages = messagesArray {
            self.shoulShowRefreshFooter = (listOfMessages.count == 20)
            for message in listOfMessages {
                let messageModel = SentMessagesModel(dictionary: message)
                self.sentMessages.append(messageModel)
            }
        }
        self.responseHandler?()
    }
}
