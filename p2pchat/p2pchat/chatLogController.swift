//
//  chatLogController.swift
//  p2pchat
//
//  Created by Melson Fernandes on 29/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit
import Firebase

class chatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            
            Readmessages()
        }
    }
    
    var messagesarray = [message0]()
    
    func Readmessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {
                    print(snapshot)
                    return
                }
                let message = message0()
                // Potential of crashing if keys don't match
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerID() == self.user?.id {
                    self.messagesarray.append(message)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
                }, withCancel: nil)
            }, withCancel: nil)
    }

    
    lazy var inputtxtfield: UITextField = {
        let ttxtfield = UITextField()
        ttxtfield.placeholder = "Enter Message..."
        ttxtfield.translatesAutoresizingMaskIntoConstraints = false
        ttxtfield.delegate = self
        return ttxtfield
        
    }()
    
    let cellid = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(CHMessageCell.self, forCellWithReuseIdentifier: cellid)
        
        
        setInputComponets()
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print(messagesarray.count)
        return messagesarray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CHMessageCell
        
        //cell.backgroundColor = UIColor(r: 100, g: 70, b: 210)
        
        let message5 = messagesarray[indexPath.item]
        
        cell.textView.text = message5.text
        
        setupCell(cell: cell, message6: message5)
        
        
        
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message5.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: CHMessageCell, message6: message0){
        
        if message6.senderId == FIRAuth.auth()?.currentUser?.uid {
            
            cell.bubbleView.backgroundColor = CHMessageCell.chatcolor
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewleftAnchor?.isActive = false
            
        } else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewleftAnchor?.isActive = true
            
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        if  let text = messagesarray[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerviewbottomanchor: NSLayoutConstraint?
    
    func setInputComponets(){
        let conView = UIView()
        conView.backgroundColor = UIColor.white
        conView.layer.borderColor = UIColor.gray.cgColor
        conView.layer.borderWidth = 1
    
        conView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(conView)
        
        conView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        conView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        conView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        conView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendbutt = UIButton(type: .system)
        sendbutt.setTitle("Send", for: .normal)
        sendbutt.translatesAutoresizingMaskIntoConstraints = false
        
        sendbutt.addTarget(self, action: #selector(handlesending), for: .touchUpInside)
        
        conView.addSubview(sendbutt)
        
        sendbutt.rightAnchor.constraint(equalTo: conView.rightAnchor).isActive = true
        sendbutt.centerYAnchor.constraint(equalTo: conView.centerYAnchor).isActive = true
        sendbutt.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendbutt.heightAnchor.constraint(equalTo: conView.heightAnchor).isActive = true
        
        
        conView.addSubview(inputtxtfield)
        
        inputtxtfield.leftAnchor.constraint(equalTo: conView.leftAnchor, constant : 9).isActive = true
        inputtxtfield.centerYAnchor.constraint(equalTo: conView.centerYAnchor).isActive = true
        inputtxtfield.rightAnchor.constraint(equalTo: sendbutt.leftAnchor).isActive = true
        sendbutt.heightAnchor.constraint(equalTo: conView.heightAnchor).isActive = true

        
        
    }
    
    func handlesending(){
        let ref = FIRDatabase.database().reference().child("messages")
        let childref = ref.childByAutoId()
        let receiverId = user!.id!
        let senderId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        let values = ["text": inputtxtfield.text!, "receiverId": receiverId, "senderId": senderId, "Timestamp": timestamp] as [String : Any]
        
        //childref.updateChildValues(values)
        
        childref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                
                return
        }
            
            self.inputtxtfield.text = nil
            
            let USmessagerREF = FIRDatabase.database().reference().child("user-messages").child(senderId)
            
            let messageID = childref.key
            USmessagerREF.updateChildValues([messageID: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(receiverId)
            recipientUserMessagesRef.updateChildValues([messageID: 1])
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlesending()
        return true
    }
}
