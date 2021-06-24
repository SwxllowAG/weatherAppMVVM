//
//  CurrentWeatherView.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit
import SnapKit

class CurrentWeatherViewController: UIViewController {
    var weatherData: WeatherData? {
        didSet {
            guard let weather = weatherData else { return }
            tempLabel.text = "temperature: \(weather.temp)"
            pressureLabel.text = "pressure: \(weather.pressure)"
            humidityLabel.text = "humidity: \(weather.humidity)"
        }
    }

    // MARK: - private properties
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var pressureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tempLabel, pressureLabel, humidityLabel])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()

    // MARK: - initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.height.equalTo(90)
        }
    }
}
