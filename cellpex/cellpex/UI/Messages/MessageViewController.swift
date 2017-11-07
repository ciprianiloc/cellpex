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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextViewHeight), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    @objc private func updateTextViewHeight() {
        let sizeThatFitsTextView = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        messageTextViewHeight.constant = sizeThatFitsTextView.height;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
