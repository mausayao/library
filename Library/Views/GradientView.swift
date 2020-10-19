//
//  GradientView.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import UIKit

class GradientView: UIView {
    let startColor = UIColor(white: 1.0, alpha: 0)
    let midColor = UIColor(white: 0, alpha: 0.4)
    var endColor = UIColor(white: 0, alpha: 0.8)
    let startLocation: NSNumber = 0
    let midLocation: NSNumber = 0.6
    let endLocation: NSNumber = 1.0
    let gradient = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradient.locations = [startLocation, midLocation, endLocation]
        gradient.frame = bounds
        layer.addSublayer(gradient)
        layer.cornerRadius = 10
    }
}
