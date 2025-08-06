//
//  AppFont.swift
//  HoldingApp
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit

enum AppFont {
    enum FontName: String {
        case regular = "Poppins-Regular"
        case medium = "Poppins-Medium"
        case semibold = "Poppins-SemiBold"
        case bold = "Poppins-Bold"
    }
    
    private static var fontCache: [String: UIFont] = [:]
    
    case regular(size: CGFloat)
    case medium(size: CGFloat)
    case semibold(size: CGFloat)
    case bold(size: CGFloat)
    case custom(name: String, size: CGFloat)
    
    var font: UIFont {
        switch self {
        case .regular(let size):
            return cachedFont(name: .regular, size: size)
        case .medium(let size):
            return cachedFont(name: .medium, size: size)
        case .semibold(let size):
            return cachedFont(name: .semibold, size: size)
        case .bold(let size):
            return cachedFont(name: .bold, size: size)
        case .custom(let name, let size):
            return cachedFont(name: name, size: size)
        }
    }
    
    private func cachedFont(name: FontName, size: CGFloat) -> UIFont {
        let key = "\(name.rawValue)_\(size)"
        if let cachedFont = AppFont.fontCache[key] {
            return cachedFont
        } else {
            let font = UIFont(name: name.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
            AppFont.fontCache[key] = font
            return font
        }
    }
    
    private func cachedFont(name: String, size: CGFloat) -> UIFont {
        let key = "\(name)_\(size)"
        if let cachedFont = AppFont.fontCache[key] {
            return cachedFont
        } else {
            let font = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
            AppFont.fontCache[key] = font
            return font
        }
    }
}
