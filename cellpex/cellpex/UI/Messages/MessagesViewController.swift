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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let messagesManager = MessagesManager()
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Messages"
        spinner.startAnimating()
        messagesManager.reloadInboxMessages {
            DispatchQueue.main.async { [weak self] in
                self?.messagesTableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectorValueHasChanged(_ sender: Any) {
        messagesManager.inboxMessages.removeAll()
        messagesManager.sentMessages.removeAll()
        messagesTableView.reloadData()
        spinner.startAnimating()
        if messageSelector.selectedSegmentIndex == 1 {
            messagesManager.reloadSentMessages {
                DispatchQueue.main.async { [weak self] in
                    self?.messagesTableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            }
        } else {
            messagesManager.reloadInboxMessages {
                DispatchQueue.main.async { [weak self] in
                    self?.messagesTableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ("showMessage" == segue.identifier) {
            let messageVC = segue.destination as! MessageViewController
            if messageSelector.selectedSegmentIndex == 0 {
                let message = messagesManager.inboxMessages[selectedIndex]
                messageVC.requestInboxMessageDetails(mesageModel: message)
            } else {
                let message = messagesManager.sentMessages[selectedIndex]
                messageVC.requestSentMessageDetails(mesageModel: message)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ///let numberOfRow = (messageSelector.selectedSegmentIndex == 0) ? messagesManager.inboxMessages.count : messagesManager.sentMessages.count
      ///  if indexPath.row > (numberOfRow - 1){
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, cell.bounds.size.width)
      //  }
    }

}

extension MessagesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "showMessage", sender: self)
    }
}
