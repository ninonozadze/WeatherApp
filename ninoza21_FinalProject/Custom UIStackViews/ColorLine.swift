//
//  ColorLine.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit

class ColorLine: UIStackView {
        
    let purple = UIView()
    let orange = UIView()
    let green = UIView()
    let blue = UIView()
    let yellow = UIView()
    let red = UIView()
    
    init() {
        super.init(frame: .zero)
        setupColorLine()
    }
   
    required init(coder: NSCoder) {
        fatalError("ColorLine ERROR")
    }
   
    private func setupColorLine() {
        self.axis = .horizontal
        self.distribution = .fillEqually

        purple.backgroundColor = .systemPurple
        orange.backgroundColor = .systemOrange
        green.backgroundColor = .systemGreen
        blue.backgroundColor = .systemBlue
        yellow.backgroundColor = .systemYellow
        red.backgroundColor = .systemRed

        addArrangedSubview(purple)
        addArrangedSubview(orange)
        addArrangedSubview(green)
        addArrangedSubview(blue)
        addArrangedSubview(yellow)
        addArrangedSubview(red)
    }
}
