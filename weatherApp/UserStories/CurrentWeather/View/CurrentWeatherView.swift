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
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    private lazy var pressureLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    private lazy var humidityLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tempLabel, pressureLabel, humidityLabel])
        sv.alignment = .center
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 10
        return sv
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
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(90)
        }
    }
}
