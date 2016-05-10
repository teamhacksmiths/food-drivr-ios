//
//  AppDelegate.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import TwitterKit
import Fabric
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setupFacebookAndTwitter()
        //runLoginFlow()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func runLoginFlow() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let _ = AuthService.sharedInstance.getCurrentUser() {
            // Code to execute if user is logged in
            
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("Main") as! DonationsContainerViewController
            let leftViewController = storyboard.instantiateViewControllerWithIdentifier("Left") as! MenuTableViewController
            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            self.window?.rootViewController = slideMenuController
            
            
        } else {
            AuthService.sharedInstance.destroyToken()
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.window?.rootViewController = loginViewController
        }
            self.window?.makeKeyAndVisible()
    }

    private func setupFacebookAndTwitter() -> Bool {
        
        // Mark - loading the ApiKeys.plist file
        guard let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType: "plist") else {
            return true
        }
        // Mark - insert to in dictionary
        guard let dictionary = NSDictionary(contentsOfFile:filePath) else {
            return true
        }
        
        // Mark - configure Facebook
        guard let facebookAppId = dictionary["FACEBOOK_API_APP_ID"] as? String ,
            let facebookDisplayName = dictionary["FACEBOOK_API_DIPLAY_NAME"] as? String ,
            let appURLSchemeSuffix = dictionary["FACEBOOK_API_URL_SCHEME_SUFFIX"] as? String    else {
                return true
        }
        
        FBSDKSettings.setAppID(facebookAppId)
        FBSDKSettings.setDisplayName(facebookDisplayName)
        FBSDKSettings.setAppURLSchemeSuffix(appURLSchemeSuffix)
        
        //Mark - configure Twitter
        guard let twitterAppKey = dictionary["TWITTER_API_APP_KEY"] as? String ,
            let twitterConsumerSecret = dictionary["TWITTER_API_CONSUMER_SECRET"] as? String else {
                return true
        }
        Twitter.sharedInstance().startWithConsumerKey(twitterAppKey, consumerSecret: twitterConsumerSecret)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

