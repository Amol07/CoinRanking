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
						StatisticsSection(coin: coin)
						AboutSection(coin: coin)
						SupplySection(coin: coin)
						if let _ = viewModel.history {
							PerformanceChartSection(viewModel: viewModel)
						}
					case .empty:
						Text("No Results Found!!!")
							.foregroundColor(.gray)
							.padding()
					case .error:
						Text("Something went wrong. Please try again later!!!")
							.foregroundColor(.red)
							.padding()
				}
            }
            .padding(16)
        }
        .navigationTitle("Coin Details")
		.task {
			await viewModel.fetchCoinDetails(timePeriod: "24h")
			await viewModel.fetchPriceHistory(timePeriod: "24h")
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
				Text(coin.formattedPrice)
                    .font(.title2)
				Text(coin.changeText)
					.foregroundColor(coin.isNegativeChange ? .red : .green)
            }
        }
    }
}

struct PerformanceChartSection: View {
	@ObservedObject var viewModel: CoinDetailViewModel

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			// Title
			Text("Performance")
				.font(.headline)

			// Segment Picker
			Picker("Filter", selection: $viewModel.selectedChartFilter) {
				ForEach(ChartFilter.allCases) { filter in
					Text(filter.rawValue).tag(filter)
				}
			}
			.pickerStyle(.segmented)
			.onChange(of: viewModel.selectedChartFilter) { oldValue, newValue in
				Task {
					await viewModel.fetchPriceHistory(timePeriod: newValue.rawValue)
				}
			}

			Chart {
				ForEach(viewModel.history ?? []) { data in
					LineMark(
						x: .value("Time", data.formattedDate),
						y: .value("Price", (Double(data.price ?? "0") ?? 0.0) / 1000)
					)
				}
			}
			.chartXAxis {
				AxisMarks(position: .bottom) { value in
					AxisValueLabel(format: .dateTime)
				}
			}
			.chartYAxis {
				AxisMarks(position: .leading) { value in
					AxisValueLabel {
						if let doubleValue = value.as(Double.self) {
							Text("\(String(format: "$ %.1fK", doubleValue))") // Custom formatting
						}
					}
					AxisGridLine()
				}
			}
			.frame(height: 300)
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
				StatCard(title: "Market Cap", value: "\(coin.formattedMarketCap)")
				StatCard(title: "24H Volume", value: "\(coin.formatted24HourVolume)")
            }
            HStack {
				StatCard(title: "All-Time High", value: "\(coin.formattedAllTimeHigh)")
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
            HStack {
                Text("About")
                    .font(.headline)
                Spacer()
            }

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

