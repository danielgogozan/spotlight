//
//  HomeViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit
import Combine

class HomeViewController: BaseTableViewController {
    
    private var topArticleViewModels: [ArticleViewModel] = []
    private var newsArticleViewModels: [ArticleViewModel] = []
    private var areTopHeadlinesLoading = true
    private var stopInfiniteScroll = false
    
    var viewModel: HomeViewModel!
    var cancellables: [AnyCancellable] = []
    
    /// Navigation
    var onSearch: (() -> Void)?
    var onArticleDetails: ((ArticleViewModel) -> Void)?
    var onLatestNews: (([ArticleViewModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        setupSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func notificationTapped() {
        // TODO: - Notification tapped
    }
    
    func refreshSections(sections: [HomeSection]) {
        let sectionIndexes = sections.map { $0.rawValue }
        tableView.reloadSections(IndexSet(sectionIndexes), with: .fade)
    }
}

// MARK: - Private
private extension HomeViewController {
    
    private func setupTableView() {
        tableView.registerCell(ofType: HeadlinesTableViewCell.self)
        tableView.registerCell(ofType: TagsTableViewCell.self)
        tableView.registerCell(ofType: ArticleViewCell.self)
        tableView.registerCell(ofType: LoadingTableCell.self)
        tableView.registerHeaderFooter(ofType: NewsTableHeader.self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    private func setupSearchBar() {
        let searchBar = SearchBarView(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        searchBar.navigationDelegate = self
        let notificationButton = UIBarButtonItem(image: Asset.Images.iconNotification.image, style: .plain, target: self, action: #selector(notificationTapped))
        navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = notificationButton
        self.navigationItem.rightBarButtonItem?.tintColor = Asset.Colors.primary.color
    }
    
    private func bindViewModel() {
        viewModel.topHeadlines
            .receive(on: RunLoop.main)
            .sink { [weak self] articleViewModels in
                guard let self = self else { return }
                self.topArticleViewModels = articleViewModels
                self.refreshSections(sections: [.headlines])
            }
            .store(in: &cancellables)
        
        viewModel.topHeadlinesOnLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self = self, self.areTopHeadlinesLoading != isLoading else { return }
                self.areTopHeadlinesLoading = isLoading
                self.refreshSections(sections: [.headlines])
            }
            .store(in: &cancellables)
        
        viewModel.news
            .receive(on: RunLoop.main)
            .sink { [weak self] articleViewModels in
                guard let self = self else { return }
                self.newsArticleViewModels = articleViewModels
                if self.newsArticleViewModels.isEmpty {
                    self.refreshSections(sections: [.news])
                } else {
                    // TODO: - cannot refresh news section because the cells will appear & dissapear so I had to reload data in order to prevent this behavior
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.stopInfiniteScroll
            .receive(on: RunLoop.main)
            .sink { [weak self] stopScroll in
                // prevent refreshing section if unnecessary
                guard let self = self, self.stopInfiniteScroll != stopScroll else { return }
                self.stopInfiniteScroll = stopScroll
                if stopScroll {
                    self.tableView.reloadData()
                } else {
                    self.refreshSections(sections: [.scrollLoading])
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Table View
extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // viewModel.numberOfRows(in: section)
        guard let sectionType = HomeSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .headlines:
            return 1
        case .tags:
            return 1
        case .news:
            return newsArticleViewModels.count
        case .scrollLoading:
            // Important: if viewModel.stopInfiniteScroll would have been used here, it would result into a crash
            // because a table view refresh can start with this section having 1 row and end up with 0 rows
            return self.stopInfiniteScroll ? 0 : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = HomeSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .headlines:
            let cell = tableView.dequeueCell(ofType: HeadlinesTableViewCell.self, at: indexPath)
            cell.setup(articleViewModels: topArticleViewModels, isLoading: areTopHeadlinesLoading)
            cell.navigationDelegate = self
            return cell
        case .tags:
            let cell = tableView.dequeueCell(ofType: TagsTableViewCell.self, at: indexPath)
            cell.setup(selectedCategories: viewModel.selectedCategories) { [weak self] category, isSelected in
                self?.viewModel.toggleCategory(category, isSelected)
            }
            return cell
        case .news:
            let cell = tableView.dequeueCell(ofType: ArticleViewCell.self, at: indexPath)
            cell.setup(articleViewModel: newsArticleViewModels[indexPath.item])
            return cell
        case .scrollLoading:
            let cell = tableView.dequeueCell(ofType: LoadingTableCell.self, at: indexPath)
            cell.startLoading()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = HomeSection(rawValue: indexPath.section), sectionType.rawValue == HomeSection.scrollLoading.rawValue else { return }
        viewModel.getMoreNews()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return nil
        }
        let header = tableView.dequeueHeaderFooter(ofType: NewsTableHeader.self, for: section)
        header.setup(title: L10n.latestNews, buttonText: L10n.seeAll, image: Asset.Images.rightArrow.image) { [weak self] in
            guard let self = self else { return }
            self.onLatestNews?(self.topArticleViewModels)
            self.hideTabBar()
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 45
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == HomeSection.news.rawValue else { return }
        onArticleDetails?(newsArticleViewModels[indexPath.item])
        hideTabBar()
    }
    
}

// MARK: - Search
extension HomeViewController: NavigationSearchDelegate {
    
    func onSearchFocused() {
        hideTabBar()
        onSearch?()
    }
    
}

// MARK: - Headlines Details
extension HomeViewController: HeadlinesNavigationDelegate {
    
    func onArticleDetails(articleViewModel: ArticleViewModel) {
        hideTabBar()
        onArticleDetails?(articleViewModel)
    }
    
}
