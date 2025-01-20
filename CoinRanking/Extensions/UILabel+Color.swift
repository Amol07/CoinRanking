//
//  UILabel+Color.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import UIKit

extension UILabel {
    /// Sets the text color of the label using a hex color string.
    /// - Parameter hex: A string representing the hex color (e.g., "#FF5733" or "FF5733").
    func setTextColor(hex: String?) {
        guard let hex else {
            self.textColor = .black
            return
        }
        // Remove the hash symbol if it exists
        var hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexColor.hasPrefix("#") {
            hexColor.removeFirst()
        }

        // Ensure the hex string is valid
        guard hexColor.count == 6 else {
            print("Invalid hex color string: \(hex)")
            return
        }

        // Convert hex string to RGB values
        var rgb: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        // Set the text color
        self.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
