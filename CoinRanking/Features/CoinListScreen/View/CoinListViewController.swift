//
//  CoinListViewController.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Combine
import UIKit

class CoinListViewController: UIViewController {

    private var subscribers: Set<AnyCancellable> = []
    private let viewModel = CoinListViewModel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.identifier)
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top 100 Coins"
        self.setupTableView()
        self.bindViewModel()
        Task {
            try? await self.viewModel.fetchCoins()
        }
    }
}

private extension CoinListViewController {
    private func setupTableView() {
        view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.$coins
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &self.subscribers)
    }
}

extension CoinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        let coin = viewModel.coins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
}

extension CoinListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isMarkedAsFavorite = self.viewModel.isFavourite(indexPath.row)
        let title = isMarkedAsFavorite ? "Unfavorite" : "Favorite"
        let backgroundColor: UIColor = isMarkedAsFavorite ? .systemRed : .systemBlue
        let favoriteAction = UIContextualAction(style: .normal, title: title) { _, _, completionHandler in
            self.viewModel.toggleFavorite(at: indexPath.row)
            completionHandler(true)
        }
        favoriteAction.backgroundColor = backgroundColor

        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension CoinListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= viewModel.coins.count - 5 }) {
            Task {
                do {
                    try await viewModel.fetchMoreCoins()
                    tableView.reloadData()
                } catch {
                    print("Failed to fetch more coins: \(error)")
                }
            }
        }
    }
}
