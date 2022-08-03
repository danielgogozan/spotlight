//
//  FavoriteViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit
import Combine

class FavoriteViewController: BaseViewController {
    
    // MARK: - Private properties
    @IBOutlet private weak var favCollectionView: UICollectionView!
    @IBOutlet private weak var scrollToTopView: UIView!
    @IBOutlet private weak var scrollToTopImageView: UIImageView!
    
    private var subscribers: [AnyCancellable] = []
    private var lastYContentOffset: CGFloat = 0
    private var focusSearchView: Bool = false

    // MARK: - Public properties & API
    var viewModel: FavoriteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupNavBar()
        setupScrollView()
        setupCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        viewModel.getAll()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Private API
private extension FavoriteViewController {
    
    func setupNavBar() {
        let titleAttributes =  [NSAttributedString.Key.foregroundColor: Asset.Colors.primary.color, NSAttributedString.Key.font: FontFamily.Nunito.bold.font(size: 17)]
        withCustomNavBar(titleTextAttributes: titleAttributes)
        navigationItem.title = L10n.favoritesScreenTitle
    }
    
    func setupScrollView() {
        scrollToTopView.addBlurEffect(blurEffectStyle: .extraLight)
        scrollToTopView.layer.cornerRadius = 5
        scrollToTopView.clipsToBounds = true
        scrollToTopImageView.image = Asset.Images.iconSearch.image.withColor(Asset.Colors.primary.color)
        scrollToTopView.alpha = 0
    }
    
    func setupCollectionView() {
        favCollectionView.registerCell(ofType: FavoriteCollectionViewCell.self)
        favCollectionView.registerCell(ofType: SearchBarCollectionCell.self)
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favCollectionView.showsVerticalScrollIndicator = false
    }
    
    func bindViewModel() {
        viewModel.articleViewModels
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.favCollectionView.reloadData()
            }
            .store(in: &subscribers)
    }
    
    @IBAction func scrollToTopTapped(_ sender: UITapGestureRecognizer) {
        self.favCollectionView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - Collection View Data Source
extension FavoriteViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.section(for: indexPath.section) {
        case .search:
            return setupSearchCell(indexPath: indexPath)
        case .articles:
            return setupArticlesCell(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SearchBarCollectionCell else { return }
        hideScrollToTopView()
        if focusSearchView {
            cell.focus = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) as? SearchBarCollectionCell != nil else { return }
        focusSearchView = true
    }
    
    func setupArticlesCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favCollectionView.dequeueCell(ofType: FavoriteCollectionViewCell.self, at: indexPath)
        guard let articleViewModel = viewModel.articleViewModel(at: indexPath.item) else { return UICollectionViewCell() }
        
        cell.setup(articleViewModel: articleViewModel) { [weak self] in
            guard let self = self else { return }
            self.viewModel.getAll()
        }
        return cell
    }
    
    func setupSearchCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favCollectionView.dequeueCell(ofType: SearchBarCollectionCell.self, at: indexPath)
        cell.liveTextSubject
            .sink { [weak self] text in
                self?.focusSearchView = text.isEmpty ? false : true
                self?.viewModel.searchKey = text
            }
            .store(in: &subscribers)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch viewModel.section(for: section) {
        case .search:
            return CGSize(width: 0, height: 0)
        case .articles:
            return CGSize(width: 0, height: 60)
        }
    }
    
}

// MARK: - Collection View Delegate
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.section(for: indexPath.section) {
        case .search:
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout  else { return CGSize(width: 300, height: 150) }
            let width = view.frame.width - (layout.sectionInset.right + layout.sectionInset.left)
            return CGSize(width: width, height: 40)
        case .articles:
            if viewModel.cellWidth == 0,
               let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                let totalSpace = layout.sectionInset.left + layout.sectionInset.right + (viewModel.noColumns * viewModel.cellSpacing - 1)
                viewModel.cellWidth = (view.frame.width - totalSpace) / viewModel.noColumns
            }
            return CGSize(width: viewModel.cellWidth, height: viewModel.cellWidth * viewModel.cellHeightMultiplicator)
        }
    }
    
}

// MARK: - Scroll View Delegate
extension FavoriteViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastYContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !favCollectionView.indexPathsForVisibleItems.isEmpty && !favCollectionView.indexPathsForVisibleItems.contains(where: { $0.section == 0})
        else {
            hideScrollToTopView()
            return
        }
        
        if lastYContentOffset < scrollView.contentOffset.y {
            hideScrollToTopView()
        } else if lastYContentOffset > scrollView.contentOffset.y {
            showScrollToTopView()
        }
    }
    
    func hideScrollToTopView() {
        guard scrollToTopView.alpha == 1 else { return }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.scrollToTopView.alpha = 0
        }
    }
    
    func showScrollToTopView() {
        guard scrollToTopView.alpha == 0 else { return }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.scrollToTopView.alpha = 1
        }
    }
}
