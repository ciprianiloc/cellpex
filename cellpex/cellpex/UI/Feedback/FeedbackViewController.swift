//
//  FeedbackViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonButomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewButtomConstraint: NSLayoutConstraint!
    
    let placeholderLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Feedback"
        updateButtonState()
        placeholderLabel.text = "Type your message..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtonState), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtonState), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    @IBAction func sendButtonAction(_ sender: Any) {
        let subject = subjectTextField.text ?? ""
        let message = messageTextView.text ?? ""
        NetworkManager.sendFeedback(subject: subject, message: message) {[weak self] (messageReceived : String) in
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
    
    @objc private func updateButtonState() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        let isButtonEnable = (subjectTextField.text?.isEmpty == false || messageTextView.text.isEmpty == false)
        self.sendButton.isEnabled = isButtonEnable
        let buttonCollorName = isButtonEnable ? "button_enable_color" : "button_disabled_color"
        self.sendButton.backgroundColor = UIColor(named: buttonCollorName)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        scrollViewButtomConstraint.constant = keyboardHeight

        
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        scrollViewButtomConstraint.constant = 0
    }
}

extension FeedbackViewController : UITextViewDelegate {
    
}

extension FeedbackViewController : UITextFieldDelegate {
    
}
