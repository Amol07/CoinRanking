//
//  CoinDetailView.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Charts
import SwiftUI

// MARK: - CoinDetailView
struct CoinDetailView: View {
	@StateObject private var viewModel: CoinDetailViewModel

	init(coinID: String) {
		_viewModel = StateObject(wrappedValue: CoinDetailViewModel(coinID: coinID))
	}

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
				switch viewModel.state {
					case .loading:
						ProgressView("Loading...")
					case let .loaded(coin):
						HeaderSection(coin: coin)
						PerformanceChartSection(viewModel: viewModel)
						StatisticsSection(coin: coin)
						AboutSection(coin: coin)
						SupplySection(coin: coin)
					case .empty:
						EmptyView()
					case .error:
						EmptyView()
				}
            }
            .padding(16)
        }
        .navigationTitle("Coin Details")
		.task {
			await viewModel.fetchCoinDetails(timePeriod: "24h")
		}
    }
}

// MARK: - HeaderSection
struct HeaderSection: View {
    let coin: CoinViewModel

    var body: some View {
        HStack(spacing: 16) {
			if let url = URL(string: coin.iconURL) {
				SVGImageView(url: url, width: 60, height: 60)
			}

            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()

            VStack(alignment: .leading) {
				Text("Price: $\(coin.formattedPrice)")
                    .font(.title2)
                Text("Change: \(coin.change) %")
                    .foregroundColor(coin.change.starts(with: "-") ? .red : .green)
            }
        }
    }
}

// MARK: - PerformanceChartSection
struct PerformanceChartSection: View {
	@ObservedObject var viewModel: CoinDetailViewModel

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text("Performance")
				.font(.headline)

			Picker("Filter", selection: $viewModel.selectedChartFilter) {
				ForEach(ChartFilter.allCases) { filter in
					Text(filter.rawValue).tag(filter)
				}
			}
			.pickerStyle(SegmentedPickerStyle())

			Chart {
				ForEach(viewModel.getFilteredChartData().indices, id: \.self) { index in
					LineMark(
						x: .value("Time", index),
						y: .value("Price", viewModel.getFilteredChartData()[index])
					)
				}
			}
			.chartYAxis {
				AxisMarks(position: .leading)
			}
			.frame(height: 200)
		}
	}
}

// MARK: - StatisticsSection
struct StatisticsSection: View {
    let coin: CoinViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)

            HStack {
				StatCard(title: "Market Cap", value: "$\(coin.formattedMarketCap)")
				StatCard(title: "24H Volume", value: "$\(coin.formatted24HourVolume)")
            }
            HStack {
				StatCard(title: "All-Time High", value: "$\(coin.formattedAllTimeHigh)")
                StatCard(title: "Rank", value: "#\(coin.rank)")
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - AboutSection
struct AboutSection: View {
    let coin: CoinViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About")
                .font(.headline)

            Text(coin.description)
                .font(.body)

			if let url = URL(string: coin.webUrl) {
				Link(destination: url) {
					Text("Official Website")
				}
			}
        }
    }
}

// MARK: - SupplySection
struct SupplySection: View {
	let coin: CoinViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Supply Details")
                .font(.headline)

            HStack {
				StatCard(title: "Circulating", value: coin.formattedCirculatingSupply)
				StatCard(title: "Total", value: coin.formattedTotalSupply)
				StatCard(title: "Max", value: coin.formattedMaxSupply)
            }
        }
    }
}

#Preview {
	CoinDetailView(coinID: "Qwsogvtv82FCd")
}

