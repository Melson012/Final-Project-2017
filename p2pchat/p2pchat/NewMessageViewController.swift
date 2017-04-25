//
//  NewMessageViewController.swift
//  p2pchat
//
//  Created by Melson Fernandes on 28/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {

    let cellid = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancle))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        
        
        fetchUser()
        
        
    }
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] { let user = User()
                user.id = snapshot.key
                
                user.setValuesForKeys(dictionary)
                
                self.users.append(user)
                
                
                
                DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                        
                    
            }
                //print(user.name, user.email)
            
    
            }, withCancel: nil)
    }
    
    func handleCancle()  {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! UserCell
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        //cell.imageView?.image = UIImage(named:"profile-icon-9")
        //cell.imageView?.contentMode = .scaleAspectFill
        
        
        if let profileimageurl = user.ProfileImageUrl {
            cell.profileImageView.loadImagesUsingCacheUrl(urlString: profileimageurl)
            
//            let url = URL(string: profileimageurl)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print(error)
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    cell.profileImageView.image = UIImage(data: data!)
//                }
//                
//                
//            }).resume()
            
            
            
            
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var viewcontroller: ViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
            let user = self.users[indexPath.row]
            self.viewcontroller?.showchatcontrollerForUser(user: user)
        }
    }
}

