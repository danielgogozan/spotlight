//
//  SearchResultViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 15.03.2022.
//

import UIKit
import Combine

protocol SearchParentDelegate: AnyObject {
    func clearSearchKey()
}

class SearchResultViewController: UIViewController {

    @IBOutlet private weak var articlesTableView: UITableView!
    private let searchBar = SearchBarView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Public API
    var viewModel: SearchResultViewModel!
    var onBack: (() -> Void)?
    var onArticleDetails: ((ArticleViewModel) -> Void)?
    var onFilterModal: (() -> Void)?
    var delegate: SearchParentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        bindViewModel()
    }

}

// MARK: - Private API
private extension SearchResultViewController {
    
    func setupNavBar() {
        searchBar.navigationDelegate = self
        searchBar.delegate = self
        searchBar.image = Asset.Images.close.image.withColor(Asset.Colors.black.color)
        searchBar.text = viewModel.query
        
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Images.backArrow.image.withColor(Asset.Colors.black.color),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back(_:)))
    }
    
    func setupTableView() {
        articlesTableView.registerCell(ofType: TagsTableViewCell.self)
        articlesTableView.registerCell(ofType: ArticleViewCell.self)
        articlesTableView.registerCell(ofType: LoadingTableCell.self)
        articlesTableView.registerCell(ofType: InfoTableCell.self)
        articlesTableView.registerHeaderFooter(ofType: NewsTableHeader.self)
        
        articlesTableView.dataSource = self
        articlesTableView.delegate = self
        articlesTableView.rowHeight = UITableView.automaticDimension
        articlesTableView.estimatedRowHeight = 100
        articlesTableView.separatorColor = .clear
    }
    
    func bindViewModel() {
        viewModel.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .data(let data):
                if !data.isEmpty {
                    self.articlesTableView.reloadData()
                }
            case .noMoreDate:
                self.articlesTableView.reloadData()
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        viewModel.selectedCategory
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.articlesTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func back(_ sender: Any) {
        onBack?()
    }
}

// MARK: - Table View
extension SearchResultViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = viewModel.section(of: indexPath.section) else { return UITableViewCell() }
        switch sectionType {
        case .tags:
            return tagCell(indexPath: indexPath)
        case .articles:
            return articleCell(indexPath: indexPath)
        case .loading:
            return loadingCell(indexPath: indexPath)
        case .info:
            return infoCell(indexPath: indexPath)
        }
    }
    
    func tagCell(indexPath: IndexPath) -> TagsTableViewCell {
        let cell = articlesTableView.dequeueCell(ofType: TagsTableViewCell.self, at: indexPath)
        cell.delegate = self
        cell.setup(selectedCategories: [viewModel.selectedCategory.value], onTagSelected: { [weak self] selectedCategory, _ in
            self?.viewModel.setCategory(selectedCategory)
        }, isFilterEnabled: true)
        
        return cell
    }
    
    func articleCell(indexPath: IndexPath) -> ArticleViewCell {
        let cell = articlesTableView.dequeueCell(ofType: ArticleViewCell.self, at: indexPath)
        cell.setup(articleViewModel: viewModel.articleViewModel(at: indexPath.row))
        
        return cell
    }
    
    func loadingCell(indexPath: IndexPath) -> LoadingTableCell {
        let cell = articlesTableView.dequeueCell(ofType: LoadingTableCell.self, at: indexPath)
        cell.startLoading()
        return cell
    }
    
    func infoCell(indexPath: IndexPath) -> InfoTableCell {
        let cell = articlesTableView.dequeueCell(ofType: InfoTableCell.self, at: indexPath)
        cell.setup(image: Asset.Images.noDataFound.image, description: "Oops.. no data found for your search")
        return cell
    }
}

// MARK: - Table View Delegate
extension SearchResultViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = viewModel.section(of: indexPath.section), sectionType == .loading else { return }
        viewModel.getResults()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = viewModel.section(of: section), sectionType == .articles, viewModel.showArticlesResultHeader else { return nil }
        let headerView = tableView.dequeueHeaderFooter(ofType: NewsTableHeader.self, for: section)
        headerView.setup(title: "", buttonText: nil, image: nil, onAction: nil)
        headerView.attributedText = viewModel.resultsHeaderMessage()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = viewModel.section(of: indexPath.section), sectionType == .articles else { return }
        onArticleDetails?(viewModel.articleViewModel(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = viewModel.section(of: section), sectionType == .articles else { return 0 }
        return 45
    }
    
}

// MARK: - Search Bar Delegate
extension SearchResultViewController: SearchDelegate {
    func onSearchButtonTapped(query: String?) {
        delegate?.clearSearchKey()
        onBack?()
    }
}

extension SearchResultViewController: NavigationSearchDelegate {
    func onSearchFocused() {
        onBack?()
    }
}

extension SearchResultViewController: TagsDelegate {
    func onFilterSelected() {
        onFilterModal?()
    }
}
