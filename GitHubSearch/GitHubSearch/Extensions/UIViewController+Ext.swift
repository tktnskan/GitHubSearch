//
//  UIViewController+Ext.swift
//  GitHubSearch
//
//  Created by GJC03280 on 2021/10/14.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertVC(title: "에러", message: "다시 시도해주세요.", buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
