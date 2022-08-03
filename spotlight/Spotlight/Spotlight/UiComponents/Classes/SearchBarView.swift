//
//  SearchBarView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit
import Combine

protocol NavigationSearchDelegate: AnyObject {
    func onSearchFocused()
}

protocol SearchDelegate: AnyObject {
    func onSearchButtonTapped(query: String?)
}

class SearchBarView: UIView {
    
    // MARK: - Private properties
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Public properties
    var delegate: SearchDelegate?
    var navigationDelegate: NavigationSearchDelegate?
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    @Published var liveText: String = ""
    
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
        containerView.layer.cornerRadius = bounds.height / 2
        containerView.layer.cornerCurve = .continuous
        containerView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        containerView.layer.shadowRadius = bounds.height / 2
        containerView.layer.shadowOpacity = 0.03
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowColor = Asset.Colors.black.color.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = Asset.Colors.searchBorder.color.cgColor
    }
    
    // MARK: - Public API
    func focus() {
        textField.becomeFirstResponder()
    }
    
    func clear() {
        textField.text = nil
    }
    
    @objc
    func imageViewTapped(_ sender: Any) {
        delegate?.onSearchButtonTapped(query: textField.text)
    }
}

// MARK: - Private API
extension SearchBarView {
    
    private func loadFromNib() {
        loadNib(from: SearchBarView.self)
        
        textField.font = FontFamily.Nunito.regular.font(size: 14)
        textField.placeholder = "Search news..."
        textField.delegate = self
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
    }
    
}

// MARK: - Text Field Delegate
extension SearchBarView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else { return true }
        liveText = text.replacingCharacters(in: textRange, with: string)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationDelegate?.onSearchFocused()
        return true
    }
    
}
