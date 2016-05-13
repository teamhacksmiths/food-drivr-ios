//
//  ProfileViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 15/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //typealias JsonDict = [String: AnyObject]
    private let userService: UserService = UserService()
    //TODO: move to Presenter
//    init(userService:UserService){
//        super.init()
//        self.userService = userService
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
 
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        print("Save pressed")
        updateUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBar()
        self.title = "Profile"

        
//        let token = (AuthService.sharedInstance.getToken()?.token)! as String
//        let currentUser = AuthService.sharedInstance.getCurrentUser()
//        let currentID = (currentUser?.id)! as Int
//        let updatedUser = [
//            "auth_token": token,
//            "email": "placeholder@holder.com",
//            "id": currentID,
//            "name": "Test User2",
//            "role_id": 0
//        ]
//        
//        userService.updateUser(updatedUser as! JsonDict)
//        print("NEW USER: \(AuthService.sharedInstance.getCurrentUser())")
        
        //updateUser()
//        let user = AuthService.sharedInstance.getCurrentUser()
//
//        userNameTF.text = user?.name
//        emailTF.text = user?.email
//        
//        let token = AuthService.sharedInstance.getToken()
//
//        print("token: \(token)")
//        print("USER: \(user)")
//
//        let session = NSURLSession.sharedSession()
//        let urlString = "https://wastenotfoodtaxi.herokuapp.com/api/v1/users/" + (token?.token)!
//        let url = NSURL(string: urlString)!
//        let request = NSMutableURLRequest(URL: url)
//        
//        request.HTTPMethod = "PATCH"
//        request.addValue((token?.token)!, forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
////        var HTTPBodyString = "{{\"user\": {\"phone\": \"6665555555\", \"name\": \"Test Driver2\"}}"
//        
//            
//        var HTTPBodyString = "{\"user\": {\"phone\": \"+1 123 456 789\", \"description\": \"A dummy driver user\", \"name\": \"Driver User8\", \"email\": \"driver@hacksmiths.com\", \"company\": \"Hacksmiths\", \"avatar\": \"http://avatarurl.com\", \"role_id\": 1, \"setting_attributes\": {\"notifications\": true,\"active\": true}}}"
//        
//       // var HTTPBodyString = "{\"user\": {\"name\": \"Driver User7\", \"email\": \"driver@hacksmiths.com\", \"company\": \"Hacksmiths\", \"avatar\": \"http://avatarurl.com\", \"role_id\": 1, \"setting_attributes\": {\"notifications\": true,\"active\": true}}}"
//        
//        request.HTTPBody = HTTPBodyString.dataUsingEncoding(NSUTF8StringEncoding)
//        
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            // Check for a successful response
//            // GUARD: Was there an error?
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            // GUARD: Did we get a successful 2XX response?
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//            
//            // GUARD: Was there any data returned?
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//            
//            // - Parse the data
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                parsedResult = nil
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            print("parsedResult: \(parsedResult)")
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                self.userNameTF.text = user?.name
//                self.emailTF.text = user?.email
//                
//                guard let userDict = parsedResult["user"] as? NSDictionary else {
//                    print("Cannot make dict from \(parsedResult)")
//                    return
//                }
//                AuthService.sharedInstance.storeCurrentUser(userDict as! [String : AnyObject])
//            })
//            
//
//            
////            guard let userDict = parsedResult["user"] as? NSDictionary,
////                name = userDict["name"] as? String, email = userDict["email"] as? String else {
////                    print("Cannot find keys 'photos' and 'photo' in \(parsedResult)")
////                    return
////            }
//            
//
//        }
//        
//        task.resume()
//        sleep(3)
//
//        print(AuthService.sharedInstance.getCurrentUser())
//        userNameTF.text = AuthService.sharedInstance.getCurrentUser()?.name

    }
    
    func updateUser() {
        
        let userToUpdate = AuthService.sharedInstance.getCurrentUser()
        
        var user = UserRegistration()
        user.email = "email@email.com"
        user.phone = "3211231234"
        user.name = "donor17"
        user.password = "password"
        user.role = .Donor
        
        
        
        userToUpdate?.name = "Driver16)"
        userService.updateUser(user).then() {
            user -> Void in
            print(userToUpdate)
        }
        
        
        
//        let token = (AuthService.sharedInstance.getToken()?.token)! as String
//        
//        let currentID = (user?.id)! as Int
//        
//        let settings = Setting()
//        settings.active = 1
//        settings.notifications = 1
//        
//        let updatedUser: [String: AnyObject] = [
//            "phone": "13211234",
//            "description": "A new description",
//            "name": "Test User2",
//            "email": "new@hacksmiths.com",
//            "company": "Hacksmiths",
//            "avatar": "http://avatarurl.com",
//            "role_id": 1,
//            "setting_attributes": settings
//
//        ]
        
        //userService.updateUser(updatedUser)
        //print("NEW USER: \(AuthService.sharedInstance.getCurrentUser())")
        
        

        
        
        
//        let session = NSURLSession.sharedSession()
//        let urlString = "https://wastenotfoodtaxi.herokuapp.com/api/v1/users/" + token
//        print("urlString: \(urlString)")
//        let url = NSURL(string: urlString)!
//        let request = NSMutableURLRequest(URL: url)
//        
//        request.HTTPMethod = "PATCH"
//        request.addValue(token, forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        var HTTPBodyString = "[{\"op\": \"replace\", \"path\": \"/name\", \"value\": \"Driver 13\"}]"
//        
////        var HTTPBodyString = "{\"user\": {\"phone\": \"+1 123 456 789\", \"description\": \"A dummy driver user\", \"name\": \"" + userName! + "\", \"email\": \"driver@hacksmiths.com\", \"company\": \"Hacksmiths\", \"avatar\": \"http://avatarurl.com\", \"role_id\": 1, \"setting_attributes\": {\"notifications\": true,\"active\": true}}}"
//        
//        print(HTTPBodyString)
//        
//        request.HTTPBody = HTTPBodyString.dataUsingEncoding(NSUTF8StringEncoding)
//        
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            // Check for a successful response
//            // GUARD: Was there an error?
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            // GUARD: Did we get a successful 2XX response?
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//            
//            // GUARD: Was there any data returned?
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//            
//            // - Parse the data
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                parsedResult = nil
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            print("parsedResult: \(parsedResult)")
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                //self.userNameTF.text = userName
//                self.emailTF.text = user?.email
//                
//                guard let userDict = parsedResult["user"] as? NSDictionary else {
//                    print("Cannot make dict from \(parsedResult)")
//                    return
//                }
//                AuthService.sharedInstance.storeCurrentUser(userDict as! [String : AnyObject])
//            })
//            
//            
//            
//            //            guard let userDict = parsedResult["user"] as? NSDictionary,
//            //                name = userDict["name"] as? String, email = userDict["email"] as? String else {
//            //                    print("Cannot find keys 'photos' and 'photo' in \(parsedResult)")
//            //                    return
//            //            }
//            
//            
//        }
//        
        //task.resume()
        
        //print(AuthService.sharedInstance.getCurrentUser())
        //userNameTF.text = userName  //AuthService.sharedInstance.getCurrentUser()?.name

    }
    /* //
        let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: "https://wastenotfoodtaxi.herokuapp.com/api/v1/users/5WUjNbdsSmUYs9FboeEP")!
        let request = NSURLRequest(URL: url)
        
        
        // Initialize task for getting data
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Check for a successful response
            // GUARD: Was there an error?
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // - Parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }

            
            guard let userDict = parsedResult["user"] as? NSDictionary,
                name = userDict["name"] as? String, email = userDict["email"] as? String else {
                    print("Cannot find keys 'photos' and 'photo' in \(parsedResult)")
                    
                    return
            }
            
            print(parsedResult)
            self.userNameLabel.text = name
            self.emailTF.text = email

        }
        
        task.resume()
        */
    //}
    
//    {
//    "user": {
//    "phone": "+1 123 456 789",
//    "description": "An dummy driver user",
//    "name": "Driver User 2",
//    "email": "driver@hacksmiths.com",
//    "company": "Hacksmiths",
//    "avatar": "http://avatarurl.com",
//    "role_id": 1,
//    "setting_attributes": {
//    "notifications": true,
//    "active": true
//    }
//    }
//    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}