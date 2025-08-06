//
//  UIView+Ext.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit

public extension UIView {
    func onTap(handler: @escaping VoidCallback) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &AssociatedKeys.tapHandler, handler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let handler = objc_getAssociatedObject(self, &AssociatedKeys.tapHandler) as? () -> Void else { return }
        handler()
    }
    
    func applyGradientBackground(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.locations = locations
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            
            // Zaten gradient varsa sil
            self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
}

private struct AssociatedKeys {
    static var tapHandler = "tapHandler"
}
