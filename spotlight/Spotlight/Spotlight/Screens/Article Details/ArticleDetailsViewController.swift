//
//  ArticleDetailsViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.03.2022.
//

import UIKit
import SDWebImage

class ArticleDetailsViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var articleImage: UIImageView!
    @IBOutlet private weak var articleHeaderView: TransparentArticleHeaderView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionStackView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var topHeaderConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topDescriptionConstraint: NSLayoutConstraint!
    
    var viewModel: ArticleViewModel!
    var onBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backView = BackView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back(_:))))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
        
        withTransparentNavBar()
        setup()
        setupScrollView()
        setupHeaderFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        descriptionView.layer.cornerRadius = 24
        descriptionView.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc func back(_ sender: UITapGestureRecognizer) {
        onBack?()
    }

}

private extension ArticleDetailsViewController {
    
    private func setup() {
        let article = viewModel.articleSubject.value
        articleHeaderView.setup(date: viewModel.articleDate.value, title: article?.title, author: article?.author)
        descriptionLabel.font = FontFamily.Nunito.semiBold.font(size: 14)
        descriptionLabel.textColor = Asset.Colors.black.color
        
        var description = ""
        
        // add some more content
        for _ in 0...5 {
            description += (article?.description ?? "") + "\n\n"
        }
        descriptionLabel.text = description
        
        guard let imageUrl = article?.imageUrl else { return }
        articleImage.sd_setImage(with: URL(string: imageUrl), completed: .none)
    }
    
    /*
     - according to https://stackoverflow.com/questions/52088023/ios-incorrect-frame-size-at-runtime in viewDidLayoutSubviews we won't have the grandchildren frames up-to-date
     - hence we are creating this method that assigns our header a closure that will receive the correct frame height once it was updated & calculate the proper constraints
     */
    private func setupHeaderFrame() {
        articleHeaderView.onFrameSet = { [weak self] headerFrameHeight in
            guard let self = self else { return }
            self.topDescriptionConstraint.constant = headerFrameHeight / 2 + 10
            self.topHeaderConstraint.constant = (self.view.frame.height / 2) - (headerFrameHeight / 2)
        }
    }
    
    private func setupScrollView() {
        // enabling content layout guide to strech to the top edge of the screen
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
}
