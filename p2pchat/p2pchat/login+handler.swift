//
//  login+handler.swift
//  p2pchat
//
//  Created by Melson Fernandes on 29/03/2017.
//  Copyright © 2017 codeking. All rights reserved.
//

import UIKit

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func handleSelectorIMView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedimage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedimage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canacled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
}

