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
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var percentChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var symbolAndPriceContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.addSubview(symbolLabel)
        containerView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        return containerView
    }()

    private lazy var nameAndChangeContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.addSubview(nameLabel)
        containerView.addSubview(percentChangeLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            percentChangeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 10),
            percentChangeLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: percentChangeLabel.centerYAnchor),
            percentChangeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            percentChangeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        return containerView
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

    private lazy var verticalStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 8
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(symbolAndPriceContainerView)
        vStackView.addArrangedSubview(nameAndChangeContainerView)
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
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
        priceLabel.text = CurrencyFormatter.formattedValue(coin.price)
        let changeIsPositive = !((coin.change ?? "0.0").starts(with: "-"))
        percentChangeLabel.text = "\(changeIsPositive ? "▲" : "▼") \(coin.change ?? "0.0") %"
        percentChangeLabel.textColor = changeIsPositive ? .green : .red

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

        horizontalStackView.addArrangedSubview(self.thumbnailImageView)
        horizontalStackView.addArrangedSubview(self.verticalStackView)

        contentView.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
