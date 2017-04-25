//
//  ViewController.swift
//  p2pchat
//
//  Created by Melson Fernandes on 28/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    //var messagesController: ViewController?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage (named: "newicon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleMessage))
        
        
        
        
        // when user is not logged in
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        //observmessages()
        //observUserMessages()
        
    }
    
    var Messages = [message0]()
    var messagesDictionry = [String: message0]()
    
    func observUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    let Message = message0()
                    Message.setValuesForKeys(dictionary)
                    
                    if let chatPartnerid = Message.chatPartnerID() {
                        self.messagesDictionry[chatPartnerid] = Message
                        
                        self.Messages = Array(self.messagesDictionry.values)
                        self.Messages.sort(by: { (message1, message2) -> Bool in
                            return message1.timestamp!.intValue > message2.timestamp!.intValue
                        })
                    }
                    
                    // this will crash because of background thread, so lets call this on dispatch_async main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let messages = Messages[indexPath.row]
        cell.Messages = messages
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messag = Messages[indexPath.row]
        
        guard let chatpartenerid = messag.chatPartnerID() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatpartenerid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else {
                    return
            }
            let user = User()
            user.id = chatpartenerid
            user.setValuesForKeys(dictionary)
            self.showchatcontrollerForUser(user: user)
            
            
            }, withCancel: nil)
        
//        showchatcontrollerForUser(user: <#T##User#>)
    }

    
    
    func handleMessage(){
        let newMessageController = NewMessageViewController()
        newMessageController.viewcontroller = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn()  {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else {
           fetchuserandsetupNAVbartitle()
        }
    
    }
    
    func fetchuserandsetupNAVbartitle() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupnavbarwith(user: user)
                
                
            }
            
            }, withCancel: nil)
    }
    
    func setupnavbarwith(user: User) {
        //self.navigationItem.title = user.name
        
        
        Messages.removeAll()
        messagesDictionry.removeAll()
        tableView.reloadData()
        
        observUserMessages()
        
       
        let titleview = UIView()
        titleview.frame = CGRect(x: 100, y: 0, width: 100, height: 40)
        //titleview.backgroundColor = UIColor.(white: 1, alpha: 0.5)
        
        
        
        let profileimageview = UIImageView()
        profileimageview.translatesAutoresizingMaskIntoConstraints = false
        profileimageview.contentMode = .scaleToFill
//        profileimageview.layer.cornerRadius = 20
//        profileimageview.clipsToBounds = true
        profileimageview.image = UIImage(named: "message2")
        
        titleview.addSubview(profileimageview)
        profileimageview.leftAnchor.constraint(equalTo: titleview.leftAnchor).isActive = true
        profileimageview.centerYAnchor.constraint(equalTo: titleview.centerYAnchor).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let namelabel = UILabel()
        
        titleview.addSubview(namelabel)
        
        namelabel.text = user.name
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        namelabel.leftAnchor.constraint(equalTo: profileimageview.rightAnchor, constant: 8).isActive = true
        namelabel.centerYAnchor.constraint(equalTo: profileimageview.centerYAnchor).isActive = true
        namelabel.rightAnchor.constraint(equalTo: titleview.rightAnchor).isActive = true
        namelabel.heightAnchor.constraint(equalTo: profileimageview.heightAnchor).isActive = true
        
        
        
        
        //namelabel.centerYAnchor.constraint(titleview.centerXAnchor)
        
        
//        titleview.layer.cornerRadius = 20
//        titleview.layer.masksToBounds = true
        
        //(white: 1, alpha: 0.5)
        
      
        //self.navigationItem.titleView = titleview
        self.navigationItem.titleView = titleview
        //titleview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showchatcontroller)))
        //namelabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showchatcontroller))))
        
    }
    
    func showchatcontrollerForUser(user: User){
        let ChatLogController = chatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        ChatLogController.user = user
        
        navigationController?.pushViewController(ChatLogController, animated: true)
        
        
    }

    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }

}

