//
//  UserCell.swift
//  p2pchat
//
//  Created by Melson Fernandes on 31/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var Messages: message0? {
        didSet{
            
            setNAmeandProfileImage()
            
            
            //cell.textLabel?.text = messages.receiverId
            self.detailTextLabel?.text = Messages?.text
            
            if let seconds = Messages?.timestamp?.doubleValue {
                let timestampDate  = NSDate(timeIntervalSince1970: seconds)
                
                let dateformate =  DateFormatter()
                dateformate.dateFormat = "hh:mm:ss a"
                timelable.text = dateformate.string(for: timestampDate)
                

            }
            
            
            
        }
    }
    
    private func setNAmeandProfileImage() {
       
        if let id = Messages?.chatPartnerID() {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                
                if let dictionry = snapshot.value as? [String: AnyObject]
                {
                    self.textLabel?.text = dictionry["name"] as? String
                    
                    if let profileImageUrl = dictionry["ProfileImageUrl"] as? String {
                        self.profileImageView.loadImagesUsingCacheUrl(urlString: profileImageUrl)
                    }
                }
                //                print(snapshot)
                }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "profile-icon-9")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timelable: UILabel = {
       
        let lable = UILabel()
        lable.text = "HH:MM:SS"
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = UIColor.lightGray
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timelable)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timelable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timelable.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        timelable.centerYAnchor.constraint(equalTo: (textLabel?.centerYAnchor)!).isActive = true
        timelable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timelable.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
