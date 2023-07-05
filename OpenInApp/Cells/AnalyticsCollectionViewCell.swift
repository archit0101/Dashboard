//
//  AnalyticsCollectionViewCell.swift
//  OpenInApp
//
//  Created by Archit Gupta on 19/06/23.
//

import Foundation
import UIKit

final class AnalyticsCollectionViewCell: UICollectionViewCell, ReusableView {
    struct Style {
        
    }
    private let style: Style = .init()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "analyticsLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        imageView.layer.cornerRadius = 16.0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.textColor = UIColor(hex: "#999CA0")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addContainerView()
        addImageView()
        addTitleLabel()
        addSubLabel()
    }
    
    private func addContainerView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func addImageView() {
        containerView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
        }
    }
    
    private func addTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    private func addSubLabel() {
        containerView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview()
        }
    }
    
    func setup(with model: AnalyticsModel) {
        titleLabel.text = model.subtitle
        subLabel.text = model.title
    }
}
