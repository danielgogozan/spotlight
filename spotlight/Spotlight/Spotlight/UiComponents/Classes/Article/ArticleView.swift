//
//  ArticleView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit
import SDWebImage

class ArticleView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    var addToFavorite: (() -> Void)?
    var isAddedToFavorite = false {
        didSet {
            favoriteButton.setImage(Asset.Images.favorite.image.withColor( isAddedToFavorite ? Asset.Colors.redish.color : .white), for: .normal)
        }
    }
    var titleLabelNumberOfLines: Int? {
        didSet {
            guard let titleLabelNumberOfLines = titleLabelNumberOfLines else { return }
            titleLabel.numberOfLines = titleLabelNumberOfLines
        }
    }
    var hideAuthorLabel = false {
        didSet {
            authorLabel.isHidden = hideAuthorLabel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    private func loadFromNib() {
        loadNib(from: ArticleView.self)
        
        titleLabel.font = FontFamily.NewYorkSmall.semibold.font(size: 16)
        authorLabel.font = FontFamily.Nunito.regular.font(size: 12)
        dateLabel.font = FontFamily.Nunito.regular.font(size: 12)
    }
    
    func setup(article: Article?, publishedDate: String, isAddedToFavorite: Bool, addToFavorite: @escaping () -> Void) {
        titleLabel.text = article?.title
        authorLabel.text = article?.author
        dateLabel.text = publishedDate
        self.isAddedToFavorite = isAddedToFavorite
        self.addToFavorite = addToFavorite
        
        guard let imageUrl = article?.imageUrl else { return }
        imageView.sd_setImage(with: URL(string: imageUrl), completed: .none)
        favoriteButton.setImage(Asset.Images.favorite.image.withColor( isAddedToFavorite ? Asset.Colors.redish.color : .white), for: .normal)
    }
    
    @IBAction func onFavoriteButtonTapped(_ sender: Any) {
        addToFavorite?()
    }
    
}
