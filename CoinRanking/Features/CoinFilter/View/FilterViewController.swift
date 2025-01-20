//
//  FilterViewController.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import UIKit

class FilterViewController: UIViewController {

    // MARK: - Private properties
    private let viewModel: FilterViewModel

    private var selectedFilter: FilterOption?
    private var selectedOrder: OrderOption?

    // MARK: - Private views

    // UILabel for displaying the "Filter By" label
    private lazy var filterLabel: UILabel = {
        let filterLabel = UILabel()
        filterLabel.text = "Filter By"
        filterLabel.font = .boldSystemFont(ofSize: 18)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        return filterLabel
    }()

    // UISegmentedControl for selecting a filter option
    private lazy var filterSegmentedControl: UISegmentedControl = {
        let filterSegmentedControl = UISegmentedControl(items: self.viewModel.filterOptions.map { $0.textValue })
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        if let selectedFilter = viewModel.selectedFilter, let index = self.viewModel.filterOptions.firstIndex(of: selectedFilter) {
            filterSegmentedControl.selectedSegmentIndex = index
        }
        return filterSegmentedControl
    }()

    // UILabel for displaying the "Order" label
    private lazy var orderLabel: UILabel = {
        let orderLabel = UILabel()
        orderLabel.text = "Order"
        orderLabel.font = .boldSystemFont(ofSize: 18)
        orderLabel.translatesAutoresizingMaskIntoConstraints = false
        return orderLabel
    }()

    // UISegmentedControl for selecting an order option
    private lazy var orderSegmentedControl: UISegmentedControl = {
        let orderSegmentedControl = UISegmentedControl(items: self.viewModel.orderOptions.map { $0.textValue })
        orderSegmentedControl.addTarget(self, action: #selector(orderChanged(_:)), for: .valueChanged)
        orderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        if let selectedOrder = viewModel.selectedOrder, let index = self.viewModel.orderOptions.firstIndex(of: selectedOrder) {
            orderSegmentedControl.selectedSegmentIndex = index
        }
        return orderSegmentedControl
    }()

    // UIButton for saving the selected filters
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveFilters), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()

    // UIButton for resetting the filters to default values
    private lazy var resetButton: UIButton = {
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        return resetButton
    }()

    // Container view to hold all the UI components
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(filterLabel)
        containerView.addSubview(filterSegmentedControl)
        containerView.addSubview(orderLabel)
        containerView.addSubview(orderSegmentedControl)
        containerView.addSubview(saveButton)
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
        return containerView
    }()

    // Tap gesture to dismiss filter screen
    private lazy var dismissTapGesture: UITapGestureRecognizer = {
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDrawer))
        dismissTapGesture.cancelsTouchesInView = false
        dismissTapGesture.delegate = self
        return dismissTapGesture
    }()

    // MARK: - Initialiser
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.selectedFilter = viewModel.selectedFilter
        self.selectedOrder = viewModel.selectedOrder
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupDrawerView()
    }

    // MARK: - Private methods
    private func setupDrawerView() {
        self.view.addGestureRecognizer(self.dismissTapGesture)

        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    @objc
    private func filterChanged(_ sender: UISegmentedControl) {
        selectedFilter = self.viewModel.filterOptions[sender.selectedSegmentIndex]
    }

    @objc
    private func orderChanged(_ sender: UISegmentedControl) {
        selectedOrder = self.viewModel.orderOptions[sender.selectedSegmentIndex]
    }

    @objc
    private func saveFilters() {
        print("Selected Filter: \(selectedFilter?.textValue ?? "None"), Order: \(selectedOrder?.textValue ?? "None")")
        self.viewModel.save(selectedFilter: selectedFilter, selectedOrder: selectedOrder)
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func resetFilters() {
        self.viewModel.reset()
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func dismissDrawer() {
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            // Check if the touch is inside the containerView
            if containerView.frame.contains(touch.location(in: view)) {
                return false // Ignore the gesture
            }
            return true // Allow the gesture
        }
}
