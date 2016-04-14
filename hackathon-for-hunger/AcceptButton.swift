//
//  AcceptButton.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 11/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class AcceptButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayerFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayerFrame()
    }
    func setLayerFrame() {
        self.setTitle("ACCEPT", forState: .Normal)
        layer.masksToBounds = true
        layer.cornerRadius = 15.0
    }
}
