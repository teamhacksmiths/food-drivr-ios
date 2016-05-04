//
//  ActivityIndicatorView.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 04/05/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//
import UIKit
import Foundation
import NVActivityIndicatorView

class ActivityIndicatorView: UIView
{
    var messageFrame = UIView()
    var activityIndicator: NVActivityIndicatorView!
    var title: String!
    var indicatorColor: UIColor!
    var loadingViewColor: UIColor!
    
    init(inview:UIView, loadingViewColor:UIColor, indicatorColor:UIColor, msg:String){
        
        self.indicatorColor = indicatorColor
        self.loadingViewColor = loadingViewColor
        self.title = msg
        super.init(frame: CGRectMake(inview.frame.midX - 100, inview.frame.midY - 25 , 200, 50))
        initalize()
        
    }
    
    func initalize(){
        messageFrame.frame = self.bounds
        activityIndicator =  NVActivityIndicatorView(frame: CGRectMake(10, 10, 30, 30), type: .BallBeat, color:  indicatorColor, padding: 0)
        activityIndicator.hidesWhenStopped = true
        let strLabel = UILabel(frame:CGRect(x: self.bounds.origin.x + 60, y: 0, width: self.bounds.width - (self.bounds.origin.x + 60) , height: 50))
        strLabel.text = title
        strLabel.textColor = UIColor.whiteColor()
        messageFrame.layer.cornerRadius = 10
        messageFrame.backgroundColor = loadingViewColor
        messageFrame.alpha = 0.8
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
        
        
    }
    
    convenience init(inview:UIView) {
        
        self.init(inview: inview,loadingViewColor: UIColor.blackColor(),indicatorColor:UIColor.whiteColor(), msg: "Loading..")
    }
    convenience init(inview:UIView,messsage:String) {
        
        self.init(inview: inview,loadingViewColor: UIColor.blackColor(),indicatorColor:UIColor.whiteColor(), msg: messsage)
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating()
    {
        if !self.subviews.contains(messageFrame){
            activityIndicator.startAnimation()
            self.addSubview(messageFrame)
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
    }
    
    func stopAnimating()
    {
        if self.subviews.contains(messageFrame){
            
            activityIndicator.stopAnimation()
            messageFrame.removeFromSuperview()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

        }
    }
}
