//
//  GistCell.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import UIKit

class GistCell: UITableViewCell {
    private var viewModel: GistCellViewModel?
    private let avatarVStack = UIStackView()
    private let avatarImageView = UIImageView()
    private let userLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let lastUpdatedLabel = UILabel()
    private let urlLabel = UILabel()
    private var task: URLSessionTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.setSelected(false, animated: true)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        viewModel?.cancelFetchAvatar()
    }
    
    func set(_ gist: Gist) {
        viewModel = GistCellViewModel(gist: gist)
        
        viewModel?.fetchAvatar { [weak self] image in
            guard let self = self else { return }
            self.avatarImageView.image = image
            self.userLabel.text = gist.owner.login
        }
        
        descriptionLabel.text = viewModel?.gistDescription
        lastUpdatedLabel.text = viewModel?.lastUpdatedString
        urlLabel.text = viewModel?.urlString
        self.contentView.layoutIfNeeded()
    }
    
    private func configure() {
        accessoryType = .disclosureIndicator
        
        let vStack = UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            vStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.distribution = .fillProportionally
        hStack.alignment = .top
        hStack.spacing = 12
        vStack.addArrangedSubview(hStack)
        
        let avatarVStack = UIStackView()
        avatarVStack.translatesAutoresizingMaskIntoConstraints = false
        avatarVStack.axis = .vertical
        avatarVStack.alignment = .center
        avatarVStack.spacing = 8
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),
        ])
        avatarImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.clipsToBounds = true
        avatarVStack.addArrangedSubview(avatarImageView)
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.font = .preferredFont(forTextStyle: .caption1)
        userLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        avatarVStack.addArrangedSubview(userLabel)
        
        hStack.addArrangedSubview(avatarVStack)
                
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .headline)
        descriptionLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        descriptionLabel.numberOfLines = 0
        hStack.addArrangedSubview(descriptionLabel)
        
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.font = .preferredFont(forTextStyle: .caption2)
        lastUpdatedLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        vStack.addArrangedSubview(lastUpdatedLabel)
        
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.font = .preferredFont(forTextStyle: .caption1)
        urlLabel.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        urlLabel.numberOfLines = 0
        vStack.addArrangedSubview(urlLabel)
    }
}
