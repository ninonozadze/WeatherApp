//
//  WeekdayHeader.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 04.02.24.
//

import UIKit

class WeekdayHeader: UITableViewHeaderFooterView {
    
    let weekday = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeader() {
        addSubview(weekday)
        weekday.textColor = .darkGray
        
        weekday.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weekday.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weekday.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setup(with weekday: String) {
        self.weekday.text = weekday
    }

}
