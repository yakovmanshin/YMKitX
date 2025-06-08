//
//  UITableView+Extensions.swift
//  YMMisc
//
//  Created by Yakov Manshin on 7/29/19.
//  Copyright © 2019 Yakov Manshin. See the LICENSE file for license info.
//

#if canImport(UIKit)

import UIKit

// MARK: - Header and Footer Configuration

extension UITableView {
    
    private static func adjustHeight(of view: UIView) {
        let targetSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        guard view.frame.size.height != targetSize.height else { return }
        
        view.frame.size.height = targetSize.height
    }
    
    /// Automatically adjusts height of the header view to fit the content.
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public func adjustHeaderViewHeight() {
        guard let headerView = self.tableHeaderView else { return }
        
        UITableView.adjustHeight(of: headerView)
        
        // iOS 9 only
        self.layoutIfNeeded()
    }
    
    /// Automatically adjusts height of the footer view to fit the content.
    @available(*, deprecated, message: "This method is deprecated and will be removed")
    public func adjustFooterViewHeight() {
        guard let footerView = self.tableFooterView else { return }
        
        UITableView.adjustHeight(of: footerView)
        
        // iOS 9 only
        self.layoutIfNeeded()
    }
    
}

#endif
