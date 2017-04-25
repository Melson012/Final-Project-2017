//
//  CHMessageCell.swift
//  p2pchat
//
//  Created by Melson Fernandes on 03/04/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit

class CHMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "melson"
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        
        return tv
    }()
    
    static let chatcolor = UIColor(r: 100, g: 70, b: 210)
    
    let bubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = chatcolor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
        
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewleftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // backgroundColor = UIColor.red
        addSubview(bubbleView)
        addSubview(textView)
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewleftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        
        
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
       
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        
        
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 10).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
