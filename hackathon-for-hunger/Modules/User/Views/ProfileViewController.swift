//
//  ProfileViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 15/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//  Edits by David Fierstein 11/05/2016

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    

    private let userService: UserService = UserService()

 
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    
    @IBAction func save(sender: AnyObject) {
        print("Save pressed")
        updateUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBar()
        self.title = "Profile"
        let currentUser = AuthService.sharedInstance.getCurrentUser()
        userNameTextField.text = currentUser?.name
        emailTextField.text = currentUser?.email

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileViewController.avatarTapped(_:)))
        avatarView.addGestureRecognizer(tapGestureRecognizer)
        avatarView.invalidateIntrinsicContentSize()
        
        avatarView.contentMode = .ScaleAspectFill
        avatarImageView.contentMode = .ScaleAspectFill
    }
    
    func avatarTapped(img: AnyObject) {
        pickAnImageFromAlbum(img)
    }
    
    func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = image

        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //checkPickingInLandscape()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUser() {
        
        
        var user = UserRegistration()
        user.email = emailTextField.text ?? "donor@hacksmiths.com"
        //user.phone = "3211231234"
        user.name = userNameTextField.text ?? "please enter your name"
        user.password = "password"
        //user.role = .Donor
        
        
        
        userService.updateUser(user).then() {
            updatedUser -> Void in
            print("USER::: \(updatedUser)")
            let userToUpdate = AuthService.sharedInstance.getCurrentUser()
            print("CURRENT USER: \(userToUpdate)")
            
        }
        
        
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    //MARK: - Text and keyboard function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Gesture Recognizer functions
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // Don't let tap GR hide textfields if a textfield is being touched for editing
        if touch.view == userNameTextField || touch.view == emailTextField {
            return false
        }
        // Anywhere else on the screen, allow the tap gesture recognizer to hideToolBars
        return true
    }
    
    // Cancels textfield editing when user touches outside the textfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if userNameTextField.isFirstResponder() || emailTextField.isFirstResponder() {
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent:event)
    }
}