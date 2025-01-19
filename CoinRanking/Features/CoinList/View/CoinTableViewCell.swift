//
//  CoinTableViewCell.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 19/01/25.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    static let identifier = "CoinTableViewCell"

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let horizontalStackView: UIStackView = {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing = 16
        hStackView.alignment = .center
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        return hStackView
    }()

    private let verticalStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 8
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        return vStackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with coin: Coin) {
        nameLabel.text = coin.name
        priceLabel.text = coin.btcPrice
        symbolLabel.text = coin.symbol
        symbolLabel.setTextColor(hex: coin.color)

        Task { @MainActor in
            thumbnailImageView.image = await loadImage(from: coin.iconURL)
        }
    }

    private func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }

    private func setupView() {
        self.selectionStyle = .none

        verticalStackView.addArrangedSubview(self.nameLabel)
        verticalStackView.addArrangedSubview(self.symbolLabel)
        verticalStackView.addArrangedSubview(self.priceLabel)

        horizontalStackView.addArrangedSubview(self.thumbnailImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)

        contentView.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
