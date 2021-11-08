//
//  UITableView+ext.swift
//  GitHubSearch
//
//  Created by Jinyung Yoon on 2021/10/28.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExccessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
