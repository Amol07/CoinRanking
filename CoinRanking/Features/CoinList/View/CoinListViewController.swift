//
//  CoinListViewController.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Combine
import SwiftUI
import UIKit

class CoinListViewController: UIViewController {

    private var subscribers: Set<AnyCancellable> = []
    private let viewModel = CoinListViewModel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: CoinListTableViewCell.identifier)
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()

    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top 100 Coins"
        FavoriteCoinHandler.shared.updateFavoriteCoins()
        self.setupNavigationBar()
        self.setupTableView()
        self.setupLoader()
        self.bindViewModel()
        Task {
            await self.viewModel.fetchCoins()
        }
    }
}

private extension CoinListViewController {

    func setupNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filter",
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapFilterButton))
        navigationItem.rightBarButtonItem = filterButton
    }

    func setupLoader() {
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    func didTapFilterButton() {
        let filterViewController = FilterViewController(viewModel: viewModel.filterViewModel)
		filterViewController.modalPresentationStyle = .overFullScreen
        present(filterViewController, animated: true, completion: nil)
    }

    func setupTableView() {
        view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func bindViewModel() {
        viewModel.$coins
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &self.subscribers)

        viewModel.$isFetching
            .receive(on: DispatchQueue.main)
            .sink { isFetching in
                if isFetching, self.viewModel.coins.isEmpty {
                    self.loader.startAnimating()
                } else { self.loader.stopAnimating()}
            }
            .store(in: &subscribers)
    }
}

extension CoinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListTableViewCell.identifier, for: indexPath) as? CoinListTableViewCell else {
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
        let imageName = isMarkedAsFavorite ? "star.fill" : "star"
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.toggleFavorite(at: indexPath.row)
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemBlue
        favoriteAction.image = UIImage(systemName: imageName)

        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.coins[indexPath.row]
        let coinDetailView = CoinDetailView(coinID: coin.uuid)
        let hostingController = UIHostingController(rootView: coinDetailView)
        self.present(hostingController, animated: true)
    }
}

extension CoinListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if viewModel.shouldFetchMoreRecords,
			indexPaths.contains(where: { $0.row >= viewModel.coins.count - 5 }) {
            Task {
                await viewModel.fetchMoreCoins()
                tableView.reloadData()
            }
        }
    }
}
