//
//  ProfileViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 15/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//  Edits by David Fierstein 11/05/2016

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    var activityIndicator : ActivityIndicatorView!
    private let profilePresenter = ProfilePresenter(userService: UserService(), authService:  AuthService())

    var imageData: NSData?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    
    @IBAction func save(sender: AnyObject) {
        updateUser()
    }
    
    override func viewDidLoad() {
        self.title = "My Profile"
        super.viewDidLoad()
        profilePresenter.attachView(self)
//        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Please wait")
//        startLoading()
        self.setupMenuBar()
  
        updateUI()

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileViewController.avatarTapped(_:)))
        avatarView.addGestureRecognizer(tapGestureRecognizer)
        avatarView.invalidateIntrinsicContentSize() // let the profile image size be set by constraints, not by the intrinsic size of the photo
        
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUser() {
        
        
        var user = UserUpdate()
        if emailTextField.text != nil && emailTextField.text != "" {
            user.email = emailTextField.text
        }
        if userNameTextField != nil && userNameTextField.text != "" {
            user.name = userNameTextField.text
        }


        profilePresenter.updateUser(user)
        
        
    }
    
    func updateUI() {
        let currentUser = profilePresenter.getUser()

        if currentUser != nil {
            userNameTextField.text = currentUser?.name
            emailTextField.text = currentUser?.email
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
        if touch.view == userNameTextField || touch.view == emailTextField || touch.view == passwordTextField {
            return false
        }
        // Anywhere else on the screen, allow the tap gesture recognizer to hideToolBars
        return true
    }
    
    // Cancels textfield editing when user touches outside the textfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if userNameTextField.isFirstResponder() || emailTextField.isFirstResponder() || passwordTextField.isFirstResponder() {
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent:event)
    }
    

}

extension ProfileViewController: ProfileView {
    
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicator.stopAnimating()
    }
    
    func update(didSucceed user: [String: AnyObject]) {
        //self.finishLoading()
        updateUI()
    }
    
    func update(didFail error: NSError) {
        //self.finishLoading()
        print("Error in saving user profile info: \(error)")
        // The new data didn't save, reload the UI with the current data
        updateUI()
    }
    
    func getUser(didSucceed user: [String: AnyObject]) {
        print("getUser: \(user)")
    }
    
    func getUser(didFail error: NSError) {
        print(error)
    }
}