//
//  ProgressBarView.swift
//  Boggle
//
//  Created by Shuo Huang on 11/10/17.
//  Copyright © 2017 Shuo Huang. All rights reserved.
//

import UIKit

protocol ProgressBarViewDelegate {
    func getProgress() -> Int?
    func getTotalTime() -> Int?
}

class ProgressBarView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var delegate : ProgressBarViewDelegate?
    
    override func draw(_ rect: CGRect) {
        drawProgressBar(rect: rect)
    }
    
    func drawProgressBar(rect: CGRect) {
        if let curTime = delegate?.getProgress() {
            if let totalTime = delegate?.getTotalTime() {
                let prog = CGFloat(curTime) / CGFloat(totalTime)
                let roundedRectBounds = CGRect(x: rect.minX + 3, y: rect.midY - 9, width: rect.width - 12, height: 20)
                let width = roundedRectBounds.minX + (roundedRectBounds.maxX - roundedRectBounds.minX) * prog
                let roundedRect = CGRect(x: roundedRectBounds.minX, y: roundedRectBounds.minY, width: width, height: 20)
                UIColor.white.setStroke()
                UIColor.white.setFill()
                let path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
                
                path.fill()
                path.lineWidth = 5
                path.stroke()
            }
        }
    }
}
