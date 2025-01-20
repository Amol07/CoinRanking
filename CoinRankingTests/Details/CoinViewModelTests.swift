//
//  CoinViewModelTests.swift
//  CoinRankingTests
//
//  Created by Amol Prakash on 20/01/25.
//

@testable import CoinRanking
import XCTest

final class CoinViewModelTests: XCTestCase {

    private var mockCoin: CoinDetails!
	private var viewModel = CoinViewModel(coin: DummyData.coinDetailResponse.data.coin!)

    func testUUID() {
        XCTAssertEqual(viewModel.uuid, "Qwsogvtv82FCd")
    }

    func testIconURL() {
        XCTAssertEqual(viewModel.iconURL, "https://cdn.coinranking.com/Sy33Krudb/btc.svg")
    }

    func testName() {
        XCTAssertEqual(viewModel.name, "Bitcoin")
    }

    func testSymbol() {
        XCTAssertEqual(viewModel.symbol, "BTC")
    }

    func testFormattedPrice() {
        XCTAssertEqual(viewModel.formattedPrice, "$ 9371.00")
    }

    func testChangeTextNegative() {
        XCTAssertEqual(viewModel.changeText, "▼ -0.52 %")
    }

    func testIsNegativeChange() {
        XCTAssertTrue(viewModel.isNegativeChange)
    }

    func testFormattedMarketCap() {
		XCTAssertEqual(viewModel.formattedMarketCap, CurrencyFormatter.formattedValue(DummyData.coinDetailResponse.data.coin?.marketCap))
    }

    func testFormatted24HourVolume() {
        XCTAssertEqual(viewModel.formatted24HourVolume, CurrencyFormatter.formattedValue(DummyData.coinDetailResponse.data.coin?.the24HVolume))
    }

    func testFormattedAllTimeHigh() {
        XCTAssertEqual(viewModel.formattedAllTimeHigh, CurrencyFormatter.formattedValue(DummyData.coinDetailResponse.data.coin?.allTimeHigh?.price))
    }

    func testRank() {
        XCTAssertEqual(viewModel.rank, "1")
    }

    func testFormattedCirculatingSupply() {
        XCTAssertEqual(viewModel.formattedCirculatingSupply, CurrencyFormatter.formattedValue(DummyData.coinDetailResponse.data.coin?.supply?.circulating))
    }

    func testFormattedTotalSupply() {
        XCTAssertEqual(viewModel.formattedTotalSupply, CurrencyFormatter.formattedValue(DummyData.coinDetailResponse.data.coin?.supply?.total))
    }

    func testFormattedMaxSupply() {
		XCTAssertEqual(viewModel.formattedMaxSupply, CurrencyFormatter.formattedValue(DummyData.coinDetailResponse.data.coin?.supply?.max))
    }

    func testDescription() {
        XCTAssertEqual(viewModel.description, "Bitcoin is the first decentralized digital currency.")
    }

	func testNumberOfExchanges() {
		XCTAssertEqual(viewModel.numberOfExchanges, "190")
	}

    func testWebUrl() {
        XCTAssertEqual(viewModel.webUrl, "https://bitcoin.org")
    }
}
