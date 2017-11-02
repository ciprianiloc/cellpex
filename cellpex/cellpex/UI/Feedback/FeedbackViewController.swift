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
    let placeholderLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Feedback"
        updateButtonState()
        placeholderLabel.text = "Type here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtonState), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtonState), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    @IBAction func sendButtonAction(_ sender: Any) {
        let confimAlert = UIAlertController(title: nil, message: "Thank you for your feedback!", preferredStyle: .alert)
        confimAlert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { [weak self] _ in
            guard let `self` = self else {return}
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(confimAlert, animated: true)
    }
    
    @objc private func updateButtonState() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        let isButtonEnable = (subjectTextField.text?.isEmpty == false || messageTextView.text.isEmpty == false)
        self.sendButton.isEnabled = isButtonEnable
        let buttonCollorName = isButtonEnable ? "button_enable_color" : "button_disabled_color"
        self.sendButton.backgroundColor = UIColor(named: buttonCollorName)
    }
}

extension FeedbackViewController : UITextViewDelegate {
    
}

extension FeedbackViewController : UITextFieldDelegate {
    
}
