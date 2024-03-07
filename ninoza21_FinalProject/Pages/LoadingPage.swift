//
//  LoadingPage.swift
//  ninoza21_FinalProject
//
//  Created by Nino Nozadze on 03.02.24.
//

import UIKit

class LoadingPage: UIView {
    
    let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoadingPage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LoadingPage ERROR")
    }
    
    func setupLoadingPage() {
        createBlur()
        createRefresh()
    }
    
    func createBlur() {
        let blur = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func createRefresh() {
        addSubview(loader)
        loader.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
