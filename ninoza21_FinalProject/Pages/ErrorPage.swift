//
//  ErrorPage.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit

protocol ErrorPageDelegate: AnyObject {
    func reloadButtonTapped()
}

class ErrorPage: UIView {
    
    weak var delegate: ErrorPageDelegate?
    
    let colorLine = ColorLine()
    let contentStack = UIStackView()
    let errorImage = UIImageView()
    let errorLabel = UILabel()
    let reloadButton = UIButton()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupErrorPage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ErrorPage ERROR")
    }
    
    func setupErrorPage() {
        backgroundColor = .white
        setupColorLine()
        setupContentStack()
    }
    
    func setupColorLine() {
        addSubview(colorLine)
        colorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorLine.heightAnchor.constraint(equalToConstant: 1.5),
            colorLine.topAnchor.constraint(equalTo: topAnchor),
            colorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorLine.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupContentStack() {
        addSubview(contentStack)
        
        contentStack.axis = .vertical
        contentStack.distribution = .equalSpacing
        contentStack.alignment = .center
        
        contentStack.addArrangedSubview(errorImage)
        contentStack.addArrangedSubview(errorLabel)
        contentStack.addArrangedSubview(reloadButton)
        
        setupContent()
        
        contentStackConstraints()
    }
    
    func setupContent() {
        errorImage.image = UIImage(named: "data_load_error")
        errorImage.contentMode = .scaleAspectFill
        
        errorLabel.numberOfLines = 2
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.systemFont(ofSize: 20)
        errorLabel.text = "The data couldn't be read\n because it is missing."
        
        reloadButton.backgroundColor = .systemYellow
        reloadButton.layer.cornerRadius = 10
        reloadButton.setTitleColor(.white, for: .normal)
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        reloadButton.addTarget(self, action: #selector(reloadPage), for: .touchUpInside)
                
    }
    
    func contentStackConstraints() {
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.widthAnchor.constraint(equalTo: widthAnchor),
            contentStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorImage.heightAnchor.constraint(equalTo: contentStack.heightAnchor, multiplier: 0.45),
            errorLabel.heightAnchor.constraint(equalTo: contentStack.heightAnchor, multiplier: 0.4),
            reloadButton.heightAnchor.constraint(equalTo: contentStack.heightAnchor, multiplier: 0.15),
            reloadButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.3)
            
        ])
    }
    
    @objc func reloadPage() {
        delegate?.reloadButtonTapped()
    }

}
