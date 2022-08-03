//
//  LatestNewsViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 14.03.2022.
//

import UIKit
import Combine

class LatestNewsViewController: UIViewController {

    @IBOutlet private weak var newsTableView: UITableView!
    
    private var stopInfiniteScroll = false
    
    var viewModel: LatestNewsViewModel!
    var cancellables: [AnyCancellable] = []
    var onBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleAttributes =  [NSAttributedString.Key.foregroundColor: Asset.Colors.primary.color, NSAttributedString.Key.font: FontFamily.Nunito.bold.font(size: 17)]
        withCustomNavBar(titleTextAttributes: titleAttributes)
        
        navigationItem.title = L10n.hotUpdates
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Images.backArrow.image.withColor(Asset.Colors.black.color),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back(_:)))
        setupTableView()
        bindViewModel()
    }

    @objc func back(_ sender: Any) {
        onBack?()
    }
    
    deinit {
        viewModel.onDeinit()
    }

}

// MARK: - Private
private extension LatestNewsViewController {

    func bindViewModel() {
        viewModel.latestNews
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
            self?.newsTableView.reloadData()
        }
        .store(in: &cancellables)
        
        viewModel.stopInfiniteScroll
            .receive(on: RunLoop.main)
            .sink { [weak self] stopScroll in
                guard let self = self, self.stopInfiniteScroll != stopScroll else { return }
                self.refreshSections(sections: [.loading])
            }
            .store(in: &cancellables)
    }
    
    func setupTableView() {
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 400
        newsTableView.separatorColor = UIColor.clear
        newsTableView.showsVerticalScrollIndicator = false
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        newsTableView.registerCell(ofType: LatestArticleCell.self)
        newsTableView.registerCell(ofType: LoadingTableCell.self)
    }
    
    func refreshSections(sections: [LatestNewsViewModel.LatestNewsSection]) {
        let sectionIndexes = sections.map { $0.rawValue }
        newsTableView.reloadSections(IndexSet(sectionIndexes), with: .fade)
    }
    
}

// MARK: - Table View

extension LatestNewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = viewModel.sectionType(from: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .news:
            let cell = tableView.dequeueCell(ofType: LatestArticleCell.self, at: indexPath)
            cell.setup(articleViewModel: viewModel.article(at: indexPath), showFullDescription: viewModel.showFullDescription(for: indexPath.row)) { [weak self] in
                self?.viewModel.toggleArticle(at: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            return cell
        case .loading:
            let cell = tableView.dequeueCell(ofType: LoadingTableCell.self, at: indexPath)
            return cell
        }
    }
    
}

extension LatestNewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = viewModel.sectionType(from: indexPath.section), sectionType == .loading else { return }
        viewModel.getMoreNews()
    }
    
}
