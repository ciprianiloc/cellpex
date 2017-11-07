//
//  MessageViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/1/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    let placeholderLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isEnabled = (messageTextView.text.isEmpty == false)
        placeholderLabel.text = "Type here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewHasChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    @objc private func textViewHasChanged() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        messageTextViewHeight.constant = sizeThatFitsTextView.height;
        sendButton.isEnabled = true
        if messageTextView.text.isEmpty {
            sendButton.isEnabled = false
            messageTextViewHeight.constant = 35
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
    }
    
}
