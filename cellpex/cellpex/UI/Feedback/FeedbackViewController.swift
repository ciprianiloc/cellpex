//
//  FeedbackViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Firebase
class FeedbackViewController: UIViewController {
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonButomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var selectSubjectView: UIView!
    
    private var selectSubjectActionSheet: UIAlertController?
    private let placeholderLabel = UILabel()
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
        selectSubjectView.layer.shadowRadius = 2
        selectSubjectView.layer.shadowColor = UIColor.lightGray.cgColor
        selectSubjectView.layer.shadowOpacity = 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtonState), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        selectSubjectActionSheet?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("FeedbackScreen", screenClass: "FeedbackViewController")
    }
    
    @IBAction func selectSubjectAction(_ sender: Any) {
        selectSubjectActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let subjectOptions = ["Report a bug", "Suggest Improvements", "Other"]
        selectSubjectActionSheet?.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler:nil))
        for subjectOption in subjectOptions {
            selectSubjectActionSheet?.addAction(UIAlertAction.init(title: subjectOption, style: .default, handler: {[weak self] (action) in
                DispatchQueue.main.async {
                    self?.subjectLabel.text = subjectOption
                }
            }))
        }
        selectSubjectActionSheet?.popoverPresentationController?.sourceView = selectSubjectView;
        selectSubjectActionSheet?.popoverPresentationController?.sourceRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        self.present(selectSubjectActionSheet!, animated: true)
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let subject = subjectLabel.text ?? ""
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
        let isButtonEnable = (messageTextView.text.isEmpty == false)
        self.sendButton.isEnabled = isButtonEnable
        let sendButtonCollor = isButtonEnable ? UIColor.init(red: 25.0/255.0, green: 74.0/255.0, blue: 177.0/255.0, alpha: 1.0) : UIColor.init(white: 0.86, alpha: 1.0)
        self.sendButton.backgroundColor = sendButtonCollor
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
