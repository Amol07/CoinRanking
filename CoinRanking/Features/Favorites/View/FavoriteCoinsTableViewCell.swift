//
//  FavoriteCoinsTableViewCell.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import UIKit

/// Custom UITableViewCell subclass to display information about favorite coins.
class FavoriteCoinsTableViewCell: UITableViewCell {
    /// Identifier for reusing the cell.
    static let identifier = "FavoriteCoinsTableViewCell"

    /// ImageView to display the thumbnail of the coin.
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "dollarsign.circle.fill")
		imageView.tintColor = .black
        return imageView
    }()

    /// Label to display the coin's name.
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Label to display the coin's symbol.
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Horizontal stack view to arrange the thumbnail and vertical stack view.
    private let horizontalStackView: UIStackView = {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing = 16
        hStackView.alignment = .center
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        return hStackView
    }()

    /// Vertical stack view to arrange the name and symbol labels.
    private lazy var verticalStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 8
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(symbolLabel)
        return vStackView
    }()

    /// Initializes the cell with the given style and reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView() // Configures the view hierarchy and constraints.
    }

    /// Required initializer for using the cell from a storyboard or nib file.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures the cell with the provided coin entity.
    /// - Parameter coin: A `CoinEntity` containing the coin's details.
    func configure(with coin: CoinEntity) {
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
		loadImage(from: coin.iconURL)
    }

    /// Asynchronously loads an image from the provided URL.
    /// - Parameter urlString: The URL string of the image.
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

    /// Sets up the view hierarchy and constraints.
    private func setupView() {
        self.selectionStyle = .none // Disables the default selection style.

        // Adds subviews to the horizontal stack view.
        horizontalStackView.addArrangedSubview(self.thumbnailImageView)
        horizontalStackView.addArrangedSubview(self.verticalStackView)

        // Adds the horizontal stack view to the content view.
        contentView.addSubview(horizontalStackView)

        // Activates layout constraints for the horizontal stack view.
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
