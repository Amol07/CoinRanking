//
//  FilterViewController.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//

import UIKit

class FilterViewController: UIViewController {
    private let viewModel: FilterViewModel

    private var selectedFilter: FilterOption?
    private var selectedOrder: OrderOption?

    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupDrawerView()
    }

    private func setupDrawerView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])

        let filterLabel = UILabel()
        filterLabel.text = "Filter By"
        filterLabel.font = .boldSystemFont(ofSize: 18)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(filterLabel)

        let filterSegmentedControl = UISegmentedControl(items: self.viewModel.filterOptions.map { $0.textValue })
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(filterSegmentedControl)

        if let selectedFilter = viewModel.selectedFilter, let index = self.viewModel.filterOptions.firstIndex(of: selectedFilter) {
            filterSegmentedControl.selectedSegmentIndex = index
        }

        let orderLabel = UILabel()
        orderLabel.text = "Order"
        orderLabel.font = .boldSystemFont(ofSize: 18)
        orderLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(orderLabel)

        let orderSegmentedControl = UISegmentedControl(items: self.viewModel.orderOptions.map{ $0.textValue })
        orderSegmentedControl.addTarget(self, action: #selector(orderChanged(_:)), for: .valueChanged)
        orderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(orderSegmentedControl)

        if let selectedOrder = viewModel.selectedOrder, let index = self.viewModel.orderOptions.firstIndex(of: selectedOrder) {
            orderSegmentedControl.selectedSegmentIndex = index
        }

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveFilters), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(saveButton)

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(resetButton)

        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            filterLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            filterSegmentedControl.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 8),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            orderLabel.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 16),
            orderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            orderSegmentedControl.topAnchor.constraint(equalTo: orderLabel.bottomAnchor, constant: 8),
            orderSegmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            orderSegmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            saveButton.topAnchor.constraint(equalTo: orderSegmentedControl.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            resetButton.topAnchor.constraint(equalTo: orderSegmentedControl.bottomAnchor, constant: 16),
            resetButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    @objc private func filterChanged(_ sender: UISegmentedControl) {
        selectedFilter = self.viewModel.filterOptions[sender.selectedSegmentIndex]
    }

    @objc private func orderChanged(_ sender: UISegmentedControl) {
        selectedOrder = self.viewModel.orderOptions[sender.selectedSegmentIndex]
    }

    @objc private func saveFilters() {
        print("Selected Filter: \(selectedFilter?.textValue ?? "None"), Order: \(selectedOrder?.textValue ?? "None")")
        self.viewModel.save(selectedFilter: selectedFilter, selectedOrder: selectedOrder)
        dismiss(animated: true, completion: nil)
    }

    @objc private func resetFilters() {
        self.viewModel.reset()
        dismiss(animated: true, completion: nil)
    }
}
