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
        AuthProvider.sharedInstance.destroyUser()
        AuthProvider.sharedInstance.destroyToken()
        delegate.runLoginFlow()
    }
}