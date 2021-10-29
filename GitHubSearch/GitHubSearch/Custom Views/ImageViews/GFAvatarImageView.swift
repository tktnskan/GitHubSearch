//
//  GFAvatarImageView.swift
//  GitHubSearch
//
//  Created by GJC03280 on 2021/10/18.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeholderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadAvatarImage(fromURL url: String) {
        Task {
            let image = try await NetworkManager.shared.downloadImage(from: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
