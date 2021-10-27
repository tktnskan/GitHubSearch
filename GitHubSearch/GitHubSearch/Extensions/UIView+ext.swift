//
//  UIView+ext.swift
//  GitHubSearch
//
//  Created by Jinyung Yoon on 2021/10/27.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
