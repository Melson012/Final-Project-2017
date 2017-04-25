//
//  LoginController.swift
//  p2pchat
//
//  Created by Melson Fernandes on 28/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation


class LoginController: UIViewController {
    
    var messagesController: ViewController?
    var player : AVAudioPlayer!
    
    
    let inputContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 70, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
        
    }()
    
    func handleLoginRegister() {
        if LoginRegisterControl.selectedSegmentIndex == 0 {
            
            handleLogin()
            
        } else {
            
            handleRegister()
        }
        
    }
    
    func handleLogin(){
        
        guard let email = emailTextField.text,let password = passwordTextField.text
            else {
                
                print("Form is not vaild")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.errorTextField.isHidden = false
                self.errorTextField.text = "incorrect Email or Password"
                self.errorTextField.textAlignment = .center
                
                self.view.addSubview(self.errorTextField)
                self.errorTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.errorTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 170).isActive = true
                self.errorTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                self.errorTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
                print("error")
                return
            }
            self.errorTextField.isHidden = true
            self.messagesController?.fetchuserandsetupNAVbartitle()
            self.dismiss(animated: true, completion: nil)
            self.errorTextField.isHidden = true
        })
        
        
        
        
    }
    
    

    
    func handleRegister(){
        
        guard let email = emailTextField.text,let password = passwordTextField.text, let name = nameTextField.text
            else {
            print ("Form is not vaild")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil{
                print (error)
                self.errorTextField.isHidden = false
                self.errorTextField.text = "The password must be 6 characters long "
                
                
                self.errorTextField.textAlignment = .center
                self.view.addSubview(self.errorTextField)
                self.errorTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.errorTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 170).isActive = true
                self.errorTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                self.errorTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
                print("error")
                
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imagename = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("\(imagename).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            //if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1)
            
           
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                      
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "ProfileImageUrl": profileImageUrl]
                        
                        
                        self.registerUserIntodatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        
                    }
                    
                    
                    
                    
                    
                    
                })
            }
        })
    }
    
    private func registerUserIntodatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
       // let values = ["name": name, "email": email, "ProfileImageUrl": metadata.downloadUrl()]
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
            self.messagesController?.fetchuserandsetupNAVbartitle()
            
            self.dismiss(animated: true, completion: nil)
            
            
        })
        
    }
    
    let errorTextField: UILabel = {
        let err = UILabel()
        err.text = "incorrect"
        err.textColor = UIColor.red
        err.backgroundColor = UIColor.lightGray
        err.layer.cornerRadius = 20
        err.layer.masksToBounds = true
        err.translatesAutoresizingMaskIntoConstraints = false
        err.isHidden = true
        return err
    }()
    
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let pass = UITextField()
        pass.placeholder = "Password"
        pass.translatesAutoresizingMaskIntoConstraints = false
        pass.isSecureTextEntry = true
        return pass
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"Hertslogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectorIMView)))
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
    
    
    lazy var LoginRegisterControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
        
        
    }()
    
    
    
    
    func handleLoginRegisterChange() {
        let title = LoginRegisterControl.titleForSegment(at: LoginRegisterControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        
        // change height of input container
        inputsContainerViewHeightAnchor?.constant = LoginRegisterControl.selectedSegmentIndex == 0 ? 100 : 150
        if (LoginRegisterControl.selectedSegmentIndex == 0) {
            nameTextField.isHidden = true
            self.errorTextField.isHidden = true
        }else {
            nameTextField.isHidden = false
            self.errorTextField.isHidden = true
        }
        
    
    
        
       
        
        
        
        // chnage height of nametextfield
        nameTextFieldHeightAnchor?.isActive = false
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: LoginRegisterControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //change height of email textfield
        
        emailtextfieldAnchor?.isActive = false
        emailtextfieldAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: LoginRegisterControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailtextfieldAnchor?.isActive = true
        
        //change height of password texfield
        
        passwordtextfieldAnchor?.isActive = false
        passwordtextfieldAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: LoginRegisterControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordtextfieldAnchor?.isActive = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = UIColor(r: 100, g: 70, b: 210)
        
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(LoginRegisterControl)
        
        
        setInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterControl()
        
    
    
        
    }
   
    func setupLoginRegisterControl()  {
        LoginRegisterControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginRegisterControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        LoginRegisterControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
        LoginRegisterControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: LoginRegisterControl.topAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailtextfieldAnchor: NSLayoutConstraint?
    var passwordtextfieldAnchor: NSLayoutConstraint?
    //var hidenametextfield: NSValue?
    
    
    func setInputsContainerView() {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparator)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparator)
        inputContainerView.addSubview(passwordTextField)
        
        //nametextfield constraints
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //namesparator constraints
        
        nameSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //emailTextfield constraints
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailtextfieldAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailtextfieldAnchor?.isActive = true
        
        //emailsparator constraints
        
        emailSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //passwordtextfield constraints
        
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordtextfieldAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordtextfieldAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterButton()  {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        
    }
}
