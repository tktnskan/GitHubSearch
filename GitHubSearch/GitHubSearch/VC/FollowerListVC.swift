//
//  FollowerListVC.swift
//  GitHubSearch
//
//  Created by GJC03280 on 2021/10/13.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {

    enum Section {
        case main
    }
    
    var username: String = ""
    var page: Int = 1
    var followers:[Follower] = []
    var filteredFollowers:[Follower] = []
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    var isLoadingMoreFollower: Bool = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,Follower>!
    
    let githubProfileButton = GFButton(color: .systemPurple, title: "Github Profile", systemImageName: "person")
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchController()
        configureVC()
        configureGitHubButton()
        getFollowers(page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    func configureGitHubButton() {
        githubProfileButton.addTarget(self, action: #selector(didTouchedgithubProfileButton), for: .touchUpInside)
        view.addSubview(githubProfileButton)
        NSLayoutConstraint.activate([
            githubProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            githubProfileButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(getTabBarHeight() + 10)),
            githubProfileButton.heightAnchor.constraint(equalToConstant: 44),
            githubProfileButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func createColumnFlowLayout(columnNumber: CGFloat = 3) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / columnNumber
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "유저 아이디를 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func getUserInfo(completed: @escaping (User) -> Void) {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                completed(user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func getFollowers(page: Int) {
        showLoadingView()
        isLoadingMoreFollower = true
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollower = false
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
                isLoadingMoreFollower = false
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateUI(with followers: [Follower]) {
        self.hasMoreFollowers = !(followers.count < 100)
        
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "팔로잉 중인 유저가 없네요..."
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers)
    }
    
    func updateData(on followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped() {
        getUserInfo { [weak self] user in
            guard let self = self else { return }
            self.addUserToFavorites(user: user)
        }
    }
    
    @objc func didTouchedgithubProfileButton() {
        getUserInfo { [weak self] user in
            guard let self = self else { return }
            guard let url = URL(string: user.htmlUrl) else {
                self.presentGFAlert(title: "주소 오류", message: "유저 주소가 정확하지 않습니다.", buttonTitle: "Ok")
                return
            }
            self.presentSafariVC(with: url)
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        Task {
            if let error = try? await PersistenceManager.updateWith(favorite: favorite, actionType: .add) {
                self.presentGFAlert(title: "실패", message: error.rawValue, buttonTitle: "Ok")
            } else {
                presentGFAlert(title: "성공", message: "\(user.login) 님이 Favorite에 추가되었습니다.", buttonTitle: "Ok")
            }
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offSetY > contentHeight - height {
            guard !isLoadingMoreFollower, hasMoreFollowers else { return }
            page += 1
            getFollowers(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeFollower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        
        let nextVC = UserInfoVC()
        nextVC.username = activeFollower.login
        nextVC.delegate = self
        let navi = UINavigationController(rootViewController: nextVC)
        present(navi, animated: true)
        
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(page: page)
    }
}
