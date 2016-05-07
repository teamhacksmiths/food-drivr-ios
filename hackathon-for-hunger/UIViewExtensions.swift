//
//  UIViewExtensions.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/17/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

extension UIView {
    func addBorderTop(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorderUtility(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}

extension UIViewController {
    func logout() {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate  else {
            return
        }
        AuthService.sharedInstance.destroyUser()
        AuthService.sharedInstance.destroyToken()
        delegate.runLoginFlow()
    }
    
    func setupMenuBar() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!]
        let menuBtn = UIButton()
        menuBtn.setImage(UIImage(named: "hamburger"), forState: .Normal)
        menuBtn.frame = CGRectMake(0, 0, 30, 30)
        menuBtn.addTarget(self, action: #selector(UIViewController.toggleMenu), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func toggleMenu() {
        self.slideMenuController()?.openLeft()
    }

}

extension UISegmentedControl {
    func removeBorders() {
        //setBackgroundImage(imageWithColor(UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)), forState: .Selected, barMetrics: .Default)
        setDividerImage(imageWithColor(UIColor.clearColor()), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}