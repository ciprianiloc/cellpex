//
//  MessageViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/1/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class MessageHeader: UITableViewCell {
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!

}


class MessageViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextViewButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewButtomConstraings: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var underLineTextView: UIView!
    @IBOutlet weak var messageTableView: UITableView!
    let placeholderLabel = UILabel()
    var hasTextView = true
    private var fromText = ""
    private var dateText = ""
    private var subjectText = ""
    private var messageText = ""
    private var shouldDisplayTheMessage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        if hasTextView {
            shouldReplayMessageViews(hide : true)
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
        } else {
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
        }
    }
    
    func requestInboxMessageDetails(mesageModel : InboxMessagesModel) {
        let messageId = mesageModel.id ?? ""
        NetworkManager.getMessage(messageId: messageId, endPoint: WebServices.getInboxMessage, successHandler: { [weak self](messageDictionary: [String : Any?]?) in
            self?.shouldDisplayTheMessage = true
            let model = InboxMessageModel.init(dictionary: messageDictionary)
            self?.fromText = model.user ?? ""
            self?.dateText = model.date ?? ""
            self?.messageText = model.message ?? ""
            self?.subjectText = model.subject ?? ""
            DispatchQueue.main.async {
                self?.shouldReplayMessageViews(hide : false)
                self?.spinner.stopAnimating()
                self?.messageTableView.reloadData()
            }
        }) { (errorMessage: String) in
            
        }
    }
    
    func requestSentMessageDetails(mesageModel : SentMessagesModel) {
        let messageId = mesageModel.id ?? ""
        NetworkManager.getMessage(messageId: messageId, endPoint: WebServices.getSendMessage, successHandler: { [weak self](messageDictionary: [String : Any?]?) in
            let model = SentMessageModel.init(dictionary: messageDictionary)
            self?.fromText = model.user ?? ""
            self?.dateText = model.date ?? ""
            self?.messageText = model.message ?? ""
            self?.subjectText = model.subject ?? ""
            self?.shouldDisplayTheMessage = true
            DispatchQueue.main.async {
                self?.shouldReplayMessageViews(hide : false)
                self?.spinner.stopAnimating()
                self?.messageTableView.reloadData()
            }
        }) { (errorMessage: String) in
            
        }
    }
    func stringFromHTML( string: String?) -> NSAttributedString?
    {
            do {
                return try NSAttributedString(data: (string?.data(using: .utf8))!,
                                              options: [
                                                .documentType: NSAttributedString.DocumentType.html,
                                                .characterEncoding: String.Encoding.utf8.rawValue
                    ], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
    }
    
    private func shouldReplayMessageViews(hide : Bool) {
        self.messageTextView.isHidden = hide
        self.sendButton.isHidden = hide
        self.underLineTextView.isHidden = hide
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shouldDisplayTheMessage ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHeader") as! MessageHeader
            cell.fromLabel.text = self.fromText
            cell.dateLabel.text = self.dateText
            cell.subjectLabel.text = self.subjectText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
           // cell.messageLabel.text = self.stringFromHTML(string: self.messageText)
            cell.messageLabel.attributedText = self.stringFromHTML(string: self.messageText)
            return cell
        }
    }
    
}

extension MessageViewController : UITableViewDelegate {

}
