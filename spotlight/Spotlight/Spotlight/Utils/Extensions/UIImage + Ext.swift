//
//  UIImage + Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit

extension UIImage {
    func withColor(_ color: UIColor?) -> UIImage {
        guard let color = color else { return self }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }.withRenderingMode(.alwaysOriginal)
    }
}
