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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Feedback"
        // Do any additional setup after loading the view.
    }

    @IBAction func sendButtonAction(_ sender: Any) {
        
    }
}

extension FeedbackViewController : UITextViewDelegate {
    
}

extension FeedbackViewController : UITextFieldDelegate {
    
}
