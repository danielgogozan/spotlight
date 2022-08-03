//
//  LoginViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 09.05.2022.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var headerView: LoginHeaderView!
    @IBOutlet private weak var bottomView: LoginBottomView!
    @IBOutlet private weak var emailView: STextFieldView!
    @IBOutlet private weak var passwordView: STextFieldView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var loginButton: SButton!
    @IBOutlet private weak var registerButton: SButton!
    @IBOutlet private weak var rememberCheckbox: CheckboxButton!
    @IBOutlet private weak var rememberLabel: UILabel!
    @IBOutlet private weak var forgetPasswordButton: UIButton!
    
    var login: (() -> Void)?
    var loginButtonCoordinates: (x: CGFloat, y: CGFloat)?
    
    var subscriptions: [AnyCancellable] = []
    var viewModel: LoginViewModel!
    var layers: (leftLayer: CAShapeLayer?, rightLayer: CAShapeLayer?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        withTransparentNavBar()
        setupViews()
        addBorder()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loginButtonCoordinates == nil {
            refreshLoginButtonCoordinates()
            draw()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.login()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.view.showToast(with: error.localizedDescription, color: Asset.Colors.redish.color)
                default:
                    break
                }
            } receiveValue: { [weak self] token in
                guard let self = self else { return }
                print("Received token: \(token)")
                self.login?()
            }
            .store(in: &subscriptions)
    }

}

// MARK: - Private API
private extension LoginViewController {
    func setupViews() {
        rememberLabel.font = FontFamily.Nunito.light.font(size: 13)
        forgetPasswordButton.setTitle(L10n.loginForgetPassword, for: .normal)
        forgetPasswordButton.titleLabel?.font = FontFamily.Nunito.light.font(size: 12)
        forgetPasswordButton.setTitleColor(Asset.Colors.secondary.color, for: .normal)
        
        rememberCheckbox.addTarget(self, action: #selector(rememberCheckboxValueChanged(_:)), for: .valueChanged)
        
        loginButton.setTitle(L10n.loginButton, for: .normal)
        loginButton.titleLabel?.font = FontFamily.Nunito.regular.font(size: 14)
        _ = loginButton.applyGradient(colours: [Asset.Colors.primary.color, Asset.Colors.redish.color])
        
        registerButton.setTitle(L10n.loginRegisterButton, for: .normal)
        registerButton.titleLabel?.font = FontFamily.Nunito.regular.font(size: 14)
        setupTextFields()
    }
    
    func setupTextFields() {
        let textFieldStyle = ViewStyle(backgroundColor: .white,
                                       shadowRadius: 2,
                                       shadowColor: Asset.Colors.black.color,
                                       shadowOffset: CGSize(width: 0, height: 1),
                                       shadowOpacity: 0.3,
                                       round: true)
        emailView.customize(style: textFieldStyle,
                            placeholder: L10n.loginEmail,
                            image: Asset.Images.email.image,
                            font: FontFamily.Nunito.regular.font(size: 14),
                            errorFont: FontFamily.Nunito.light.font(size: 10))
        passwordView.customize(style: textFieldStyle,
                               placeholder: L10n.loginPassword,
                               image: Asset.Images.lock.image,
                               font: FontFamily.Nunito.regular.font(size: 14),
                               errorFont: FontFamily.Nunito.light.font(size: 10))
        passwordView.hideText = true
        
        emailView.$textValue
            .print("Email view--")
            .sink { [weak self] text in
                self?.viewModel.email = text
            }
            .store(in: &subscriptions)
        
        passwordView.$textValue
            .sink { [weak self] text in
                self?.viewModel.password = text
            }
            .store(in: &subscriptions)
    }
    
    func bindViewModel() {
        viewModel.emailPublisher
            .print("Email publisher--")
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                guard let self = self,
                      let errorMessage = errorMessage else { return }
                
                defer { self.redraw() }
                
                guard !errorMessage.isEmpty else {
                    self.emailView.clearError()
                    return
                }
                
                self.emailView.displayError(with: errorMessage)
            }
            .store(in: &subscriptions)
        
        viewModel.passwordPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                guard let self = self,
                      let errorMessage = errorMessage else { return }
                
                defer { self.redraw() }
                
                guard !errorMessage.isEmpty else {
                    self.passwordView.clearError()
                    return
                }
                
                self.passwordView.displayError(with: errorMessage)
            }
            .store(in: &subscriptions)
        
        viewModel.credentialsValidator
            .print("Validating credentials...")
            .map { $0 != nil}
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subscriptions)

    }
    
    @objc func rememberCheckboxValueChanged(_ sender: CheckboxButton) {
        print(sender.isChecked)
    }
}

// MARK: - Drawing
private extension LoginViewController {
    func draw() {
        drawLeftEllipse()
        drawRightEllipse()
    }
    
    func redraw() {
        refreshLoginButtonCoordinates()
        scrollView.layer.sublayers?.removeAll(where: { $0 == layers.leftLayer  || $0 == layers.rightLayer })
        draw()
    }
    
    func drawLeftEllipse() {
        let mid = loginButtonCoordinates != nil ? loginButtonCoordinates!.y + loginButton.frame.height / 2 : scrollView.frame.height / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -10, y: 0))
        
        path.addQuadCurve(to: CGPoint(x: 25, y: mid),
                          controlPoint: CGPoint(x: 5, y: mid - 10))
        path.addQuadCurve(to: CGPoint(x: -10, y: scrollView.frame.height),
                          controlPoint: CGPoint(x: 5, y: mid + 10))
        
        path.addLine(to: CGPoint(x: -10, y: 0))
        
        let layer = shapeLayer(with: path)
        layers.leftLayer = layer
        scrollView.layer.addSublayer(layer)
    }
    
    func drawRightEllipse() {
        let mid = loginButtonCoordinates != nil ? loginButtonCoordinates!.y + loginButton.frame.height / 2 : scrollView.frame.height / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: scrollView.frame.width + 10, y: 0))
        
        path.addQuadCurve(to: CGPoint(x: scrollView.frame.width - 25, y: mid),
                          controlPoint: CGPoint(x: scrollView.frame.width - 5, y: mid - 10))
        path.addQuadCurve(to: CGPoint(x: scrollView.frame.width + 10, y: scrollView.frame.height),
                          controlPoint: CGPoint(x: scrollView.frame.width - 8, y: mid + 10))
        
        path.addLine(to: CGPoint(x: scrollView.frame.width + 10, y: 0))
        let layer = shapeLayer(with: path)
        layers.rightLayer = layer
        scrollView.layer.addSublayer(layer)
    }
    
    func shapeLayer(with path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = Asset.Colors.redish.color.cgColor
        shapeLayer.fillColor = Asset.Colors.primary.color.cgColor
        shapeLayer.lineWidth = 5
        return shapeLayer
    }
    
    /*
     - According to https://stackoverflow.com/questions/57446801/border-along-the-edges-of-the-screen the only way to draw borders around device's corners is to use device information
     - For the sake of this exercise app, I will hardcode the iphone13 corner radius for now, which is 47.33
     */
    func addBorder() {
        view.layer.cornerRadius = 47.33
        view.layer.borderWidth = 5
        view.layer.borderColor = Asset.Colors.primary.color.cgColor
    }
    
    func refreshLoginButtonCoordinates() {
        let convertedFrame = scrollView.convert(buttonsStackView.frame, from: contentStackView)
        loginButtonCoordinates = (x: convertedFrame.origin.x, y: convertedFrame.origin.y)
    }
}
