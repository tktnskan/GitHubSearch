//
//  UITableView+ext.swift
//  GitHubSearch
//
//  Created by GJC03280 on 2021/10/28.
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
