//
//  LatestArticleCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 14.03.2022.
//

import UIKit
import SDWebImage

class LatestArticleCell: UITableViewCell {

    @IBOutlet private weak var articleImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: CollapsableLabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    private var article: Article?
    
    var onRefresh: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        articleImage.layer.cornerRadius = 8
        dateLabel.font = FontFamily.Nunito.light.font(size: 12)
        titleLabel.font = FontFamily.NewYorkSmall.semibold.font(size: 14)
        descriptionLabel.font = FontFamily.Nunito.regular.font(size: 14)
        authorLabel.font = FontFamily.Nunito.bold.font(size: 12)
    }
    
    func setup(articleViewModel: ArticleViewModel, showFullDescription: Bool, onRefresh: @escaping (() -> Void)) {
        guard let article = articleViewModel.articleSubject.value else { return }
        self.article = article
        self.onRefresh = onRefresh
        
        articleImage.sd_setImage(with: article.urlToImage, completed: .none)
        dateLabel.text = articleViewModel.articleDate.value
        titleLabel.text = article.title
        authorLabel.text = L10n.publishedBy(article.author ?? "")
        
        descriptionLabel.fullText = article.description
        if showFullDescription {
            descriptionLabel.expand()
        }
        
        guard let message = descriptionLabel.text else { return }
        descriptionLabel.attributedText = descriptionAttributedString(message: message, link: descriptionLabel.isExpanded ? L10n.readLess : L10n.readMore)
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDescriptionLabelTapped(_:))))
    }
    
    @objc
    func onDescriptionLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let message = descriptionLabel.text else { return }
        let link = descriptionLabel.isExpanded ? L10n.readLess : L10n.readMore
        let linkRange = NSString(string: message).range(of: link)
        if sender.didTapAttributedTextInLabel(label: descriptionLabel, inRange: linkRange) {
            if descriptionLabel.isExpanded {
                descriptionLabel.collapse()
            } else {
                descriptionLabel.expand()
            }
            onRefresh?()
        }
    }
}

private extension LatestArticleCell {
    
    func descriptionAttributedString(message: String, link: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let linkRange = NSString(string: message).range(of: link)
        
        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.regular.font(size: 14),
                                                             .foregroundColor: Asset.Colors.black.color]
        let linkAttributes: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.regular.font(size: 14),
                                                             .foregroundColor: Asset.Colors.primary.color]
        
        attributedString.append(NSAttributedString(string: message, attributes: bodyAttributes))
        attributedString.setAttributes(linkAttributes, range: linkRange)
        return attributedString
    }
    
}
