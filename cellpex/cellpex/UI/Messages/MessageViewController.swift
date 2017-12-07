//
//  MessageViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/1/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!

}


class MessageViewController: BaseViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextViewButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewButtomConstraings: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var underLineTextView: UIView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var fromOrToLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectToLabel: UILabel!
    @IBOutlet weak var messageHeader: UIView!

    
    let placeholderLabel = UILabel()
    var hasTextView = true
    private var messageText = ""
    private var messageID = ""
    private var senderId = ""
    private var shouldDisplayTheMessage = false
    private var screenType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beforeMessageIsLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("\(screenType)MessageScreen", screenClass: "MessageViewController")
    }
    
    func beforeMessageIsLoad() {
        spinner.startAnimating()
        messageHeader.isHidden = true
        messageTextView.isHidden = true
        sendButton.isHidden = true
        underLineTextView.isHidden = true
    }
    
    private func updateSubviews(isSystem:Bool) {
        hasTextView = !isSystem
        if isSystem {
            tableViewButtomConstraings.isActive = false
            messageTextView.removeFromSuperview()
            sendButton.removeFromSuperview()
            underLineTextView.removeFromSuperview()
            var buttomConstraints : NSLayoutYAxisAnchor
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                buttomConstraints = guide.bottomAnchor
            } else {
                buttomConstraints = self.bottomLayoutGuide.bottomAnchor
            }
            messageTableView.bottomAnchor.constraint(equalTo: buttomConstraints).isActive = true
        } else {
            messageTextView.isHidden = false
            sendButton.isHidden = false
            underLineTextView.isHidden = false
            sendButton.isEnabled = (messageTextView.text.isEmpty == false)
            placeholderLabel.text = "Type your message..."
            
            placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
            placeholderLabel.sizeToFit()
            messageTextView.addSubview(placeholderLabel)
            placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
            placeholderLabel.textColor = UIColor.lightGray
            placeholderLabel.isHidden = !messageTextView.text.isEmpty
            NotificationCenter.default.addObserver(self, selector: #selector(self.textViewHasChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        }
    }
    
    func requestInboxMessageDetails(mesageID : String?) {
        let messageId = mesageID ?? ""
        screenType = "Inbox"
        NetworkManager.getMessage(messageId: messageId, endPoint: WebServices.getInboxMessage, successHandler: { [weak self](messageDictionary: [String : Any?]?) in
            self?.shouldDisplayTheMessage = true
            DispatchQueue.main.async {
                let model = InboxMessageModel.init(dictionary: messageDictionary)
                let isSystem = (model.system == "1")
                self?.updateSubviews(isSystem: isSystem)
                self?.messageText = model.message ?? ""
                self?.messageID = model.id ?? ""
                self?.senderId = model.senderId ?? ""
                
                self?.subjectToLabel.text = model.subject
                self?.userLabel.text = model.user
                self?.dateLabel.text = model.date
                self?.fromOrToLabel.text = "From:"
                self?.messageHeader.isHidden = false
                self?.spinner.stopAnimating()
                self?.messageTableView.reloadData()
            }
        }) { (errorMessage: String) in
            
        }
    }
    
    func requestSentMessageDetails(mesageID : String?) {
        let messageId = mesageID ?? ""
        hasTextView = false
        screenType = "Sent"
        NetworkManager.getMessage(messageId: messageId, endPoint: WebServices.getSendMessage, successHandler: { [weak self](messageDictionary: [String : Any?]?) in
            self?.shouldDisplayTheMessage = true
            DispatchQueue.main.async {
                let model = SentMessageModel.init(dictionary: messageDictionary)
                self?.messageText = model.message ?? ""
                self?.messageID = model.id ?? ""
                self?.senderId = model.receiverId ?? ""
                self?.updateSubviews(isSystem: true)
                self?.subjectToLabel.text = model.subject
                self?.userLabel.text = model.user
                self?.dateLabel.text = model.date
                self?.fromOrToLabel.text = "To:"
                self?.messageHeader.isHidden = false
                self?.spinner.stopAnimating()
                self?.messageTableView.reloadData()
            }
        }) { (errorMessage: String) in
            
        }
    }
    func stringFromHTML( string: String?) -> NSAttributedString? {
        guard let messageString = string else {
            return nil
        }
        let message = messageString + "<style>body{font-family: \(dateLabel.font.fontName); font-size:18px;}</style>"
        do {
            return try NSAttributedString(data: (message.data(using: .utf8))!,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    @objc private func textViewHasChanged() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        messageTextViewHeight.constant = CGFloat.minimum(sizeThatFitsTextView.height, self.view.frame.height/2) + 10
        sendButton.isEnabled = true
        if messageTextView.text.isEmpty {
            sendButton.isEnabled = false
            messageTextViewHeight.constant = 35
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if hasTextView {
            let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
            messageTextViewHeight.constant = CGFloat.minimum(sizeThatFitsTextView.height, size.height/4) + 10
            if messageTextView.text.isEmpty {
                messageTextViewHeight.constant = 35
            }
        }
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        NetworkManager.sendReply(messageId: messageID, senderId: senderId, message: messageTextView.text) {[weak self] (messageReceived: String) in
            guard let `self` = self else {return}
            let confimAlert = UIAlertController(title: nil, message: messageReceived, preferredStyle: .alert)
            confimAlert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            DispatchQueue.main.async {
                self.present(confimAlert, animated: true)
            }
        }
    }
    @IBAction func redirectToUserOnWeb(_ sender: Any) {
        NetworkManager.redirectToWeb(parentVC: self, endPoint: "user&id=\(senderId)")
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        messageTextViewButtomConstraint.constant = keyboardHeight + 10
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        messageTextViewButtomConstraint.constant = 10
    }
}

extension MessageViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shouldDisplayTheMessage ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
       // cell.messageLabel.text = self.stringFromHTML(string: self.messageText)
        cell.messageLabel.attributedText = self.stringFromHTML(string: self.messageText)
        return cell
    }
    
}

extension MessageViewController : UITableViewDelegate {

}
