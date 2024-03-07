//
//  DeniedPage.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 07.02.24.
//

import UIKit

class DeniedPage: UIView {
    
    private let rainView: UIImageView = {
        let rainView = UIImageView()
        rainView.contentMode = .scaleAspectFit
        rainView.translatesAutoresizingMaskIntoConstraints = false
        return rainView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDeniedPage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("DeniedPage ERROR")
    }
    
    func setupDeniedPage() {
        backgroundColor = .systemCyan
        
        rainView.image = UIImage(named: "Zrain")
        rainView.tintColor = .white
        addSubview(rainView)
                
        NSLayoutConstraint.activate([
            rainView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rainView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rainView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            rainView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        
    }
}
