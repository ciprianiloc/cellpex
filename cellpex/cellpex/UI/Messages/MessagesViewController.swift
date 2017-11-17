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
    @IBOutlet weak var messagesTableView: UITableView!
    let messagesManager = MessagesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Messages"
        messagesManager.reloadInboxMessages {
            DispatchQueue.main.async { [weak self] in
                self?.messagesTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectorValueHasChanged(_ sender: Any) {
        if messageSelector.selectedSegmentIndex == 1 {
            messagesManager.reloadSentMessages {
                DispatchQueue.main.async { [weak self] in
                    self?.messagesTableView.reloadData()
                }
            }
        } else {
            messagesManager.reloadInboxMessages {
                DispatchQueue.main.async { [weak self] in
                    self?.messagesTableView.reloadData()
                }
            }
        }
    }
}

extension MessagesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messageSelector.selectedSegmentIndex == 0) ? messagesManager.inboxMessages.count : messagesManager.sentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        if messageSelector.selectedSegmentIndex == 0 {
            let message = messagesManager.inboxMessages[indexPath.row]
            cell.fromLabel.text = message.user
            cell.subjectLabel.text = message.subject
            cell.dateLabel.text = message.date
            cell.messageLabel.text = message.shortMessage
            var isViewed = false
            if let messageIsViewed = message.viewed, messageIsViewed == "yes" {
                isViewed = true
            }
            cell.unreadView.isHidden = isViewed
        } else {
            let message = messagesManager.sentMessages[indexPath.row]
            cell.fromLabel.text = message.user
            cell.subjectLabel.text = message.subject
            cell.dateLabel.text = message.date
            cell.messageLabel.text = message.shortMessage
            var isViewed = false
            if let messageIsViewed = message.viewed, messageIsViewed == "yes" {
                isViewed = true
            }
            cell.unreadView.isHidden = isViewed
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
