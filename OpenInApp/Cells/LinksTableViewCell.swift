//
//  LinksTableViewCell.swift
//  OpenInApp
//
//  Created by Archit Gupta on 20/06/23.
//

import Foundation
import UIKit
final class LinksTableViewCell: UITableViewCell, ReusableView {
    var copyLink: String = ""
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAction))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var LogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .black
        label.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = UIColor(hex: "#999CA0")
        label.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        return label
    }()
    
    private lazy var titleSubtitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 2.0
        return stack
    }()
    
    private lazy var numberOfClicks: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var clicksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Clicks"
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = UIColor(hex: "#999CA0")
        return label
    }()
    
    private lazy var clicksStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [numberOfClicks, clicksLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .trailing
        stack.spacing = 2.0
        return stack
    }()
    
    private lazy var logotitleSubtitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [LogoImage, titleSubtitleStack])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 12.0
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logotitleSubtitleStack, clicksStack])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var copyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E8F1FF")
        view.layer.cornerRadius = 8.0
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAction))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(hex: "#0E6FFF")
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()
    
    private lazy var copyImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "copy"))
        imageView.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
        return imageView
    }()
    
    @objc private func copyAction(_gesture: UITapGestureRecognizer) {
        UIPasteboard.general.string = copyLink
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hex: "#F5F5F5")
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addContainerView()
        addMainStack()
        addCopyView()
        addLinkLabel()
        addCopyImage()
    }
    
    private func addContainerView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func addMainStack() {
        containerView.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    private func addCopyView() {
        containerView.addSubview(copyView)
        copyView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(mainStack.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    private func addLinkLabel() {
        copyView.addSubview(linkLabel)
        linkLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(213)
            make.centerY.equalToSuperview()
        }
    }
    
    private func addCopyImage() {
        copyView.addSubview(copyImage)
        copyImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func setup(model: LinksModel) {
        self.titleLabel.text = model.title
        self.subLabel.text = model.created_at
        self.numberOfClicks.text = String(model.total_clicks)
        self.linkLabel.text = model.web_link
        let imageURL = model.original_image
        setImageFromURL(urlString: imageURL, to: self.LogoImage)
        self.copyLink = model.web_link
    }
}

extension LinksTableViewCell {
    func setImageFromURL(urlString: String, to imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            // Invalid URL
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle error
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                // Invalid data or unable to create UIImage
                return
            }

            DispatchQueue.main.async {
                imageView.image = image
            }
        }

        task.resume()
    }
}
