//
//  ChatRoomViewController.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet var chatView: UIView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var messages: [Message] = []
    var Client = ParseClient()
    var flag = false
    var user: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.current()!
        if let uname = currentUser["username"] as? String {
          user = uname
        } else {
          user = "unidentified user"
        }
        // Adjust User Interface

        sendButton.layer.cornerRadius = 5.0
        sendButton.clipsToBounds = true


        // For keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.chatView.addGestureRecognizer(tapGesture)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadTable()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func viewDidAppear(_ animated: Bool) {
        self.scrollToBottom()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    @IBAction func onSendButton(_ sender: Any) {
        
        let message = Message()
        message.from = user!
        message.text = messageTextField.text
        messageTextField.text = ""

        Client.sendMessage(message: message, onSuccess: {
                self.loadTable()
                self.scrollToBottom()
        }) { (error: Error) in
              print(error.localizedDescription)
        }
        
    }
    

    func userInactive(){
        print(" USER INACTIVE ")
        // here is where we will send user activity status to the backend
    }
    
    func userActive(){
        print(" USER ACTIVE ")
        // here too
    }

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {

    }

    // ---------- SCROLL TO BOTTOM FUNCTION: Added By SVM ---------
    func scrollToBottom() {
        tableView.reloadData()
        tableView.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(tableView.contentSize.height - tableView.frame.size.height))
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messageLabel.text = (messages[indexPath.row].text!)
        return cell

    }

    func loadTable() {
        Client.getMessages(onSuccess: { (listOfMessages: [Message]) in
            self.messages = listOfMessages
            self.tableView.reloadData()
            self.scrollToBottom()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }

    func keyboardWillShow(sender: NSNotification) {
        if self.flag == false {
          let userInfo:NSDictionary = sender.userInfo! as NSDictionary
          let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
          let keyboardRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keyboardRectangle.height
          
          self.view.frame.origin.y -= keyboardHeight
          self.flag = true
        }

    }

    func keyboardWillHide(sender: NSNotification) {
        if self.flag == true {
          let userInfo:NSDictionary = sender.userInfo! as NSDictionary
          let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
          let keyboardRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keyboardRectangle.height
          
          self.view.frame.origin.y += keyboardHeight
          self.flag = false
        }
    }


    func tap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
          self.chatView.endEditing(true)
        }
    }
    
    

  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
