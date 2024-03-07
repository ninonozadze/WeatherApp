//
//  FiveDaysForecastCell.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit

class FiveDaysForecastCell: UITableViewCell {
    
    let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        return mainStackView
    }()
        
    let weatherImage = UIImageView()
    
    let smallStackView: UIStackView = {
        let smallStackView = UIStackView()
        smallStackView.axis = .vertical
        smallStackView.distribution = .fillEqually
        smallStackView.alignment = .leading
        smallStackView.translatesAutoresizingMaskIntoConstraints = false
        return smallStackView
    }()
    
    let timeLabel = UILabel()
    let weatherLabel = UILabel()
    
    let temperatureLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureMainStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMainStackView() {
        contentView.addSubview(mainStackView)
        
        setupMainStackView()
        mainStackViewConstraints()
    }
    
    func setupMainStackView() {
        mainStackView.addArrangedSubview(weatherImage)
        mainStackView.addArrangedSubview(smallStackView)
        mainStackView.addArrangedSubview(temperatureLabel)
        setupSmallStackView()
        
        temperatureLabel.textColor = .systemBlue
        temperatureLabel.font = UIFont.systemFont(ofSize: 30)
        temperatureLabel.textAlignment = .right
        
        weatherImage.contentMode = .scaleAspectFit
    }
    
    func setupSmallStackView() {
        smallStackView.addArrangedSubview(timeLabel)
        smallStackView.addArrangedSubview(weatherLabel)
        
        timeLabel.textColor = .darkGray
        weatherLabel.textColor = .darkGray
    }
    
    func mainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            weatherImage.widthAnchor.constraint(equalTo: mainStackView.heightAnchor),
            temperatureLabel.widthAnchor.constraint(equalTo: mainStackView.heightAnchor),
            
            smallStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.5)
            
            
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
