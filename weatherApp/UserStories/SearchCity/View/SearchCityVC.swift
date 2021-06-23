//
//  SearchCityVC.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit
import SnapKit

class SearchCityViewController: UIViewController {
    
    var viewModel: SearchCityViewModel!
    
    // MARK: - private properties
    private lazy var locationTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "My location"
        tf.textAlignment = .center
        tf.delegate = self
        return tf
    }()
    
    private lazy var geolocationButton: UIButton = {
        var b = UIButton()
        b.layer.cornerRadius = 10
        b.setTitle("My geolocation", for: .normal)
        b.addTarget(self, action: #selector(geolocationHandler), for: .touchUpInside)
        b.backgroundColor = UIColor.Button.enabled
        return b
    }()
    
    private lazy var showWeatherButton: UIButton = {
        var b = UIButton()
        b.layer.cornerRadius = 10
        b.setTitle("Show weather", for: .normal)
        b.addTarget(self, action: #selector(showWeatherHandler), for: .touchUpInside)
        b.isEnabled = false
        b.backgroundColor = UIColor.Button.notEnabled
        return b
    }()
    
    private var bottomConstraint: Constraint!
    
    // MARK: - initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotificationHandler(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupSubviews() {
        view.backgroundColor = .white
        title = "Search city"
        
        view.addSubview(showWeatherButton)
        showWeatherButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50).constraint
        }
        
        view.addSubview(geolocationButton)
        geolocationButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(showWeatherButton.snp.top).offset(-15)
        }
        
        view.addSubview(locationTextField)
        locationTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualTo(geolocationButton.snp.top).offset(-20)
        }
    }
    
    // MARK: - public functions
    
    // MARK: - private functions
    @objc private func geolocationHandler() {
        viewModel.needsToSaveLocation = true
        viewModel.shouldSearchByLocation = true
        viewModel.obtainCurrentLocation()
    }
    
    @objc private func showWeatherHandler() {
        locationTextField.resignFirstResponder()
        viewModel.requestWeatherData(text: locationTextField.text)
    }
    
    @objc private func keyboardNotificationHandler(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.minY ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
                                ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        if endFrameY >= UIScreen.main.bounds.size.height {
            self.bottomConstraint?.update(offset: -20)
        } else {
            self.bottomConstraint?.update(offset: -(endFrame?.size.height ?? 0 + 20))
        }

        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.view.layoutSubviews() },
                       completion: nil)
    }
    
    private func presentMessage(title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension SearchCityViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            showWeatherButton.isEnabled = !updatedText.isEmpty || viewModel.lastLocation != nil
            showWeatherButton.backgroundColor = showWeatherButton.isEnabled ? UIColor.Button.enabled : UIColor.Button.notEnabled
            viewModel.shouldSearchByLocation = updatedText.isEmpty
        }
        return true
    }
}

// MARK: - ViewModelDelegate

extension SearchCityViewController: SearchCityViewModelDelegate {
    func didReceiveLocation(lat: CGFloat, lon: CGFloat) {
        showWeatherButton.isEnabled = true
        showWeatherButton.backgroundColor = UIColor.Button.enabled
        
        presentMessage(title: "Location received", "lat: \(lat), lon: \(lon)")
    }
    
    func presentError(title: String, _ errorDescription: String) {
        presentMessage(title: title, errorDescription)
    }
    
    func presentView(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
}
