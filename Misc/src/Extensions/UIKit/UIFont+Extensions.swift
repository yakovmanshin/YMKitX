//
//  UIFont+Extensions.swift
//  YMMisc
//
//  Created by Yakov Manshin on 8/9/20.
//  Copyright © 2020 Yakov Manshin. See the LICENSE file for license info.
//

#if canImport(UIKit)

import UIKit

extension UIFont {
    
    /// Returns an instance of `UIFont` with the specified style and weight, that supports Dynamic Type.
    ///
    /// - Parameters:
    ///   - textStyle: *Required.* The text style to use as base.
    ///   - weight: *Required.* The font weight to apply.
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public static func preferredFont(for textStyle: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
    
}

#endif
