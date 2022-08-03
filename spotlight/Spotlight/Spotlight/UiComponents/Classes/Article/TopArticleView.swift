//
//  TopArticleView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit

class TopArticleView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: GradientImageView!
    @IBOutlet private weak var hoverView: UIView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
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
        containerView.layer.cornerRadius = 10
    }
    
    func toCustom() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.hoverView.backgroundColor = .gray
            self.hoverView.layer.opacity = 0.2
        }
    }
    
    func toDefault() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.hoverView.backgroundColor = .white
            self.hoverView.layer.opacity = 0.5
        }
    }
    
    func setup(topHeadline: TopHeadline) {
        authorLabel.text = topHeadline.author
        titleLabel.text = topHeadline.title
        descriptionLabel.text = topHeadline.description
        guard let imageUrl = topHeadline.imageUrl else { return }
        imageView.sd_setImage(with: URL(string: imageUrl), completed: .none)
    }
    
    private func loadFromNib() {
        loadNib(from: TopArticleView.self)
        
        authorLabel.textColor = .white
        authorLabel.font = FontFamily.Nunito.extraBold.font(size: 15)
        
        titleLabel.textColor = .white
        titleLabel.font = FontFamily.NewYorkSmall.semibold.font(size: 20)
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = FontFamily.Nunito.regular.font(size: 15)
    }
}
