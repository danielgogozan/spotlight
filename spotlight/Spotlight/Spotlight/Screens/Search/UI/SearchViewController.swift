//
//  SearchViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet private weak var historyTable: UITableView!
    private let searchBar = SearchBarView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    var viewModel: SearchViewModel!
    var cancellables: [AnyCancellable] = []
    var onBack: (() -> Void)?
    var onSearchResult: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        bindViewModel()
    }
    
}

// MARK: - Private API
private extension SearchViewController {
    
    func setupNavBar() {
        searchBar.delegate = self
        searchBar.image = Asset.Images.rightArrow.image.withColor(Asset.Colors.black.color)
        searchBar.focus()
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Images.backArrow.image.withColor(Asset.Colors.black.color),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back(_:)))
    }
    
    func setupTableView() {
        historyTable.registerCell(ofType: HistoryTableCell.self)
        historyTable.dataSource = self
        historyTable.delegate = self
        historyTable.rowHeight = UITableView.automaticDimension
        historyTable.estimatedRowHeight = 40
    }
    
    func bindViewModel() {
        viewModel.getHistory()
        
        viewModel.history
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.historyTable.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func back(_ sender: Any) {
        onBack?()
    }
}

// MARK: - Table View
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: HistoryTableCell.self, at: indexPath)
        let searchKey = viewModel.searchTitle(at: indexPath.row)
        cell.setup(title: searchKey) { [weak self] in
            self?.viewModel.remove(searchKey: searchKey)
        }
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.cellForRow(at: indexPath) as? HistoryTableCell else { return }
        onSearchButtonTapped(query: cell.searchKey)
    }
    
}

// MARK: - Search Bar Delegate
extension SearchViewController: SearchDelegate {
    func onSearchButtonTapped(query: String?) {
        guard let query = query else { return }
        viewModel.save(searchKey: query)
        onSearchResult?(query)
    }
}

extension SearchViewController: SearchParentDelegate {
    func clearSearchKey() {
        searchBar.clear()
    }
}
