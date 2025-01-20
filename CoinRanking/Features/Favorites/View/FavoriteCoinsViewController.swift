//
//  FavoriteCoinsViewController.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import Combine
import SwiftUI
import UIKit

class FavoriteCoinsViewController: UIViewController {

    private let viewModel = FavoriteCoinsViewModel()
    private var subscribers: Set<AnyCancellable> = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteCoinsTableViewCell.self, forCellReuseIdentifier: FavoriteCoinsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()

	/// Label to display the coin's name.
	private lazy var noResultsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .gray
		label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Your favourite crypto coins will appear here..."
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite Coins"
        self.setupUI()
        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("View will appear is called in FavoriteCoinsViewController")
        self.viewModel.loadFavoriteCoins()
    }

    /// Sets up the required custom views and adds it to the view hierarchy with constraints.
    func setupUI() {
        view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

		view.addSubview(self.noResultsLabel)

		NSLayoutConstraint.activate([
			self.noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			self.noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			self.noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
    }

    /// Binds the view model's `favoriteCoins` property to the table view.
    /// Reloads the table view whenever the `favoriteCoins` array changes.
    func bindViewModel() {
        viewModel.$favoriteCoins
            .receive(on: DispatchQueue.main)
            .sink { _ in
				self.noResultsLabel.isHidden = !self.viewModel.favoriteCoins.isEmpty
                self.tableView.reloadData()
            }
            .store(in: &self.subscribers)
    }
}

extension FavoriteCoinsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favoriteCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCoinsTableViewCell.identifier, for: indexPath) as? FavoriteCoinsTableViewCell else {
            return UITableViewCell()
        }
        let coin = viewModel.favoriteCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
}

extension FavoriteCoinsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let imageName = "star.fill"
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.removeFavoriteCoin(at: indexPath.row)
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemBlue
        favoriteAction.image = UIImage(systemName: imageName)

        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.favoriteCoins[indexPath.row]
        let coinDetailView = CoinDetailView(coinID: coin.uuid)
        let hostingController = UIHostingController(rootView: coinDetailView)
        self.present(hostingController, animated: true)
    }
}
