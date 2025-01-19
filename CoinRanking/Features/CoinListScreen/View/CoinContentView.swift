//
//  CoinContentView.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 19/01/25.
//
import SwiftUI

struct CoinContentView: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.iconURL)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                Color.gray
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(coin.price)
                .font(.subheadline)
                .foregroundColor(.green)
        }
        .padding()
//        .background(BlurView(style: .systemMaterial))
        .cornerRadius(12)
    }
}
