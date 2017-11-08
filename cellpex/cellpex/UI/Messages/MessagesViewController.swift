//
//  MessagesViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadView.layer.cornerRadius = unreadView.frame.height / 2
    }
}

class MessagesViewController: UIViewController {
    @IBOutlet weak var messageSelector: UISegmentedControl!
    @IBOutlet weak var messagesTanleView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Messages"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectorValueHasChanged(_ sender: Any) {
        messagesTanleView.reloadData()
    }
}

extension MessagesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        cell.fromLabel.text = "TestA@testing.com"
        cell.subjectLabel.text = "SubjectTest"
        cell.dateLabel.text = "18, Oct 2017"
        cell.messageLabel.text = "Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger."
        cell.unreadView.isHidden = true
        if indexPath.row < 5 {
            cell.unreadView.isHidden = false
        } else if indexPath.row < 10 {
            cell.fromLabel.text = "Testtest@verylongemailaddresssss.com"
            cell.subjectLabel.text = "SubjectTestSubjectTestSubjectTestSubjectTtessssest"
            cell.dateLabel.text = "18, Oct 2017"
            cell.messageLabel.text = "Make a symbolic breakpoint at UIViewAler tForUnsati sfiableConstraints to catch this in the debugger.Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger."
        } else if indexPath.row < 15 {
                        cell.messageLabel.text = "Make a symbolic breakpoint"
        }
        return cell
    }

}

extension MessagesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didDeselectRowAt \(indexPath.row)")
        self.performSegue(withIdentifier: "showMessage", sender: self)
    }
}
