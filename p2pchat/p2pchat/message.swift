//
//  message.swift
//  p2pchat
//
//  Created by Melson Fernandes on 31/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit
import Firebase

class message0: NSObject {
    
    var receiverId : String?
    var senderId: String?
    var text: String?
    var timestamp: NSNumber?
    
    func chatPartnerID() -> String? {
      
        return senderId == FIRAuth.auth()?.currentUser?.uid ? receiverId : senderId
    }

}
