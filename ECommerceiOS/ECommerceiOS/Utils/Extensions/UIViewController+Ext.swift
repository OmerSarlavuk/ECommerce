//
//  UIViewController+Ext.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit
import Then

public extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel().then {
            $0.text = message
            $0.font = .systemFont(ofSize: 14,
                                  weight: .regular)
            $0.textColor = .white
            $0.backgroundColor = .black.withAlphaComponent(0.7)
            $0.textAlignment = .center
            $0.alpha = 0.0
            $0.numberOfLines = 0
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        

        let maxWidthPercentage: CGFloat = 0.8
        let maxTitleSize = CGSize(width: view.bounds.size.width * maxWidthPercentage, height: view.bounds.size.height)
        var expectedSize = toastLabel.sizeThatFits(maxTitleSize)
        expectedSize.width += 20
        expectedSize.height += 20

        toastLabel.frame = CGRect(
            x: (view.frame.size.width - expectedSize.width) / 2,
            y: view.frame.size.height - expectedSize.height - 40,
            width: expectedSize.width,
            height: expectedSize.height
        )

        view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
