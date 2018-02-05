//
//  ChatViewController.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 10/23/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import Flurry_iOS_SDK

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var outgoingMessageBubbleImage: JSQMessagesBubbleImage!
    var incomingMessageBubbleImage: JSQMessagesBubbleImage!
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    var users: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Chat"
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        senderId = AuthenticationManager.sharedInstance.userID
        senderDisplayName = AuthenticationManager.sharedInstance.userName
        
        setupMessageBubbles()
        ref = Database.database().reference()
        let senderID = Auth.auth().currentUser?.uid
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingMessageBubbleImage
        } else {
            return incomingMessageBubbleImage
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        //messages array
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = .white
        } else {
            cell.textView!.textColor = .black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
        //Here we are displaying everyones name above their message except for the "Senders"
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20.0
    }
    
    //need to fix
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
//        Flurry.logEvent("Sent message")
        let parameters = ["Sent" : senderDisplayName]
        Flurry.logEvent("Sent message", withParameters: parameters)
        //get reference to database
        let messageRef = ref.child("messages").childByAutoId()
        
        //create a message
//        let message = [
//            "text": text!,
//            "senderId": senderId!,
//            "senderDisplayName": senderDisplayName!
//        ]
        
        let message = [
            "text": text!,
            "to" : users?.userIdKey,
            "from": senderId,
            "senderDisplayName": senderDisplayName!]
        
        //add message to database
        messageRef.setValue(message)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }

    override func viewWillAppear(_ animated: Bool) {
        messages.removeAll()
        databaseHandle = ref.child("messages").observe(.childAdded, with: { (snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let id = value["from"] as! String
                let text = value["text"] as! String
                let name = value["senderDisplayName"] as! String
                //let name = self.senderDisplayName as! String
                let to = value["to"] as! String
                
                if (to == self.users?.userIdKey && id == self.senderId) || (to == self.senderId && id == self.users?.userIdKey) {
                        self.addMessage(id: id, text: text, name: name)
                }
                //self.addMessage(id: id, text: text, name: name)
                self.finishReceivingMessage()
            }
        })
    }

    func addMessage(id: String, text: String, name: String) {
        let message = JSQMessage(senderId: id, displayName: name, text: text)
        messages.append(message!)
    }
    
//    func addMessage(text: String) {
//        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
//        messages.append(message!)
//    }
    
    private func setupMessageBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingMessageBubbleImage = factory?.outgoingMessagesBubbleImage(
            with: UIColor(red:0.97, green:0.57, blue:0.01, alpha:1.00))
        incomingMessageBubbleImage = factory?.incomingMessagesBubbleImage(
            with: .jsq_messageBubbleLightGray())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: databaseHandle)
    }
}

