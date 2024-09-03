//
//  UIView.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import UIKit

extension UIView {
        func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func roundCorners(radius: Double) {
        layer.cornerRadius = radius
        layer.cornerCurve = .continuous
    }
}
