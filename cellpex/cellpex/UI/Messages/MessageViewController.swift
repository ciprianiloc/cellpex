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

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextViewButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewButtomConstraings: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var underLineTextView: UIView!
    @IBOutlet weak var messageTableView: UITableView!
    let placeholderLabel = UILabel()
    var hasTextView = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if hasTextView {
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHeader") as! MessageHeader
            cell.fromLabel.text = "TestA@testing.com"
            cell.dateLabel.text = "18, Oct 2017"
            cell.subjectLabel.text = "SubjectTest"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
            cell.messageLabel.text = "Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.\nMake a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.\nMake a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.\nMake a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.\nMake a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.\nMake a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.\nMake a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger."

            return cell
        }
    }
    
}

extension MessageViewController : UITableViewDelegate {

}
