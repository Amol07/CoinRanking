//
//  CoinListTableViewCell.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import SDWebImage
import UIKit

/// A UITableViewCell subclass that displays information about a cryptocurrency.
/// This cell includes a thumbnail image, the coin's name, symbol, price, and percentage change.
class CoinListTableViewCell: UITableViewCell {

    // MARK: - Public properties

    /// The reuse identifier for the CoinListTableViewCell.
    static let identifier = "CoinListTableViewCell"

    // MARK: - Private views

    /// The image view that displays the coin's thumbnail.
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "dollarsign.circle.fill")
		imageView.tintColor = .black
        return imageView
    }()

    /// The label that displays the name of the coin.
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The label that displays the symbol of the coin.
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The label that displays the percentage change of the coin's price.
    private lazy var percentChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The label that displays the current price of the coin.
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// A container view that holds the symbol and price labels.
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

    /// A container view that holds the name and percentage change labels.
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

    /// A horizontal stack view that arranges the thumbnail image and vertical stack view.
    private let horizontalStackView: UIStackView = {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing = 16
        hStackView.alignment = .center
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        return hStackView
    }()

    /// A vertical stack view that arranges the symbol and price container view and the name and change container view.
    private lazy var verticalStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 8
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(symbolAndPriceContainerView)
        vStackView.addArrangedSubview(nameAndChangeContainerView)
        return vStackView
    }()

    // MARK: - Initialiser

    /// Initializes a new CoinListTableViewCell with the specified style and reuse identifier.
    /// - Parameters:
    ///   - style: The cell style.
    ///   - reuseIdentifier: The reuse identifier for the cell.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    /// Required initializer for using the cell in a storyboard or xib.
    /// - Parameter coder: The NSCoder object.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    /// Configures the cell with the provided coin data.
    /// - Parameter coin: The Coin object containing the data to display.
    func configure(with coin: Coin) {
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
        priceLabel.text = CurrencyFormatter.formattedValue(coin.price)
        let changeIsPositive = !((coin.change ?? "0.0").starts(with: "-"))
        percentChangeLabel.text = "\(changeIsPositive ? "▲" : "▼") \(coin.change ?? "0.0") %"
        percentChangeLabel.textColor = changeIsPositive ? .green : .red
		loadImage(from: coin.iconURL)
    }

    // MARK: - Private methods

    /// Loads an image from the specified URL asynchronously.
    /// - Parameter urlString: The URL string of the image to load.
    private func loadImage(from urlString: String) {
        let placeholderImage: UIImage? = {
            let image = UIImage(systemName: "dollarsign.circle.fill")
            return image
        }()

		if urlString.hasSuffix(".svg") {
			thumbnailImageView.image = placeholderImage
		} else {
			thumbnailImageView.sd_setImage(with: URL(string: urlString),
										   placeholderImage: placeholderImage)
		}
    }

    /// Sets up the view hierarchy and layout constraints for the cell.
    private func setupView() {
        self.selectionStyle = .none

        // Add the thumbnail image and vertical stack view to the horizontal stack view.
        horizontalStackView.addArrangedSubview(self.thumbnailImageView)
        horizontalStackView.addArrangedSubview(self.verticalStackView)

        // Add the horizontal stack view to the cell's content view.
        contentView.addSubview(horizontalStackView)

        // Set up constraints for the horizontal stack view.
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
