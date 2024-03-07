//
//  InfoDetail.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit

class InfoDetail: UIStackView {
    
    let infoImage = UIImageView()
    let infoLabel = UILabel()
    
    init(name: String) {
        super.init(frame: .zero)
        
        setupInfoDetail(name: name)
    }
   
   required init(coder: NSCoder) {
       fatalError("InfoDetail ERROR")
   }
   
    private func setupInfoDetail(name: String) {
        axis = .vertical
        distribution = .fillEqually
        alignment = .center
        
        addArrangedSubview(infoImage)
        addArrangedSubview(infoLabel)
        
        infoImage.tintColor = .systemYellow
        infoImage.contentMode = .scaleAspectFit
        infoImage.image = UIImage(named: name)
        
        infoLabel.textAlignment = .center        
    }

}
