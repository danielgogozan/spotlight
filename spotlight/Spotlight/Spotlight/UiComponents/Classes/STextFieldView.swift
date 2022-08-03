//
//  STextField.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 09.05.2022.
//

import Foundation
import UIKit

struct ViewStyle {
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat = 0.0
    var shadowRadius: CGFloat?
    var shadowColor: UIColor?
    var shadowOffset: CGSize?
    var shadowOpacity: Float?
    var round: Bool = true
}

class STextFieldView: UIView {
    
    // MARK: - Private properties
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private var style: ViewStyle? {
        didSet {
            guard let style = style else { return }
            shadowView.apply(style: style)
        }
    }
    
    private var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    // MARK: - Public properties
    
    @Published var textValue: String?
    
    var hideText = false {
        didSet {
            textField.isSecureTextEntry = hideText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if style?.round ?? false {
            textFieldView.layer.cornerRadius = shadowView.frame.height / 2
            shadowView.layer.cornerRadius = shadowView.frame.height / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Public API
    func customize(style: ViewStyle, placeholder: String, image: UIImage, font: UIFont?, errorFont: UIFont?) {
        self.style = style
        self.placeholder = placeholder
        self.imageView.image = image.withColor(Asset.Colors.redish.color)
        self.textField.font = font
        self.errorLabel.font = errorFont
        self.errorLabel.textColor = Asset.Colors.secondary.color
    }
    
    func displayError(with message: String) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.errorLabel.text = message
            self.errorLabel.isHidden = false
        
            self.textFieldView.layer.borderColor = Asset.Colors.secondary.color.cgColor
            self.textFieldView.layer.borderWidth = 0.5
            self.contentView.layoutIfNeeded()
        }
    }
    
    func clearError() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.errorLabel.text = nil
            self.errorLabel.isHidden = true
            
            self.textFieldView.layer.borderColor = UIColor.clear.cgColor
            self.textFieldView.layer.borderWidth = 0.0
            self.contentView.layoutIfNeeded()
        }
    }
}

// MARK: - Private API
private extension STextFieldView {
    func commonInit() {
        loadNib(from: STextFieldView.self)
        
        textField.delegate = self
    }
}

// MARK: Text Field Delegate
extension STextFieldView: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textValue = textField.text ?? ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
