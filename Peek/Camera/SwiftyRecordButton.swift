//
//  SwiftyRecordButton.swift
//  swiftyprac
//
//  Created by Christopher Norman on 8/19/17.
//  Copyright © 2017 yakuza. All rights reserved.
//

import UIKit

class SwiftyRecordButton: SwiftyCamButton{
    
    private var circleBorder: CALayer!
    private var innerCircle: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButton()
    }
    
    private func drawButton(){
        
        self.backgroundColor = UIColor.clear
        
        circleBorder = CALayer()
         circleBorder.backgroundColor  = UIColor.clear.cgColor
         circleBorder.borderWidth = 6.0
         circleBorder.borderColor = UIColor.darkGray.cgColor
         circleBorder.bounds = self.bounds
         circleBorder.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
         circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at:0)
    }
    
}
