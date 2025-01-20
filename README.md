# Cryptocurrency Tracker iOS Application

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Tools and Technologies](#tools-and-technologies)
4. [Architecture](#architecture)
5. [UI and Functional Details](#ui-and-functional-details)
6. [Error Handling](#error-handling)
7. [Assumptions](#assumptions)
8. [Challenges and Solutions](#challenges-and-solutions)

---

## Introduction

This iOS application provides a platform to track the top 100 cryptocurrencies using the CoinRanking API. The app features a paginated list of cryptocurrencies, detailed coin information with performance charts, and a dedicated favorites section. The goal of this project is to demonstrate proficiency in Swift, UIKit, and SwiftUI, while adhering to best practices in coding, maintainability, and scalability.

## Features

### Screen 1: Top 100 Coins List
- Displays the top 100 coins with pagination (20 coins per page).
- List item includes:
  - Icon
  - Name
  - Current Price
  - 24-hour Performance
- Filtering options:
  - By highest price
  - By best 24-hour performance
- Swipe left to favorite a coin.

### Screen 2: Cryptocurrency Details
- Displays detailed information about a selected coin:
  - Name
  - Performance chart with filters
  - Price
  - Additional statistics

### Screen 3: Favorites Screen
- Displays a list of all favorited coins.
- Includes functionality to view coin details.
- Swipe left to unfavorite a coin.

---

## Tools and Technologies

- **Programming Language:** Swift
- **Frameworks:**
  - UIKit: Used for table view and collection view components.
  - SwiftUI: Used for smaller, interactive UI components such as charts.
- **Networking:** URLSession
- **Charting:** Swift Charts
- **Dependency Management:** Swift Package Manager (SPM)
- **JSON Parsing:** Codable
- **Version Control:** Git
- **Development Environment:** Xcode 14+

---

## Architecture

The application follows the **MVVM (Model-View-ViewModel)** architecture to ensure clear separation of concerns, scalability, and testability. 

- **Model:** Represents the data layer, handling API responses and business logic.
- **ViewModel:** Acts as a bridge between the View and Model, managing state and user interaction.
- **View:** Composed of UIKit and SwiftUI components, responsible for presenting data.
- **Service Layer:** Encapsulates API interactions using protocols and dependency injection for flexibility and testability.

---

## UI and Functional Details

### Filtering
- Implemented using a segmented control at the top of the list view.

### Favoriting
- Swipe left on a coin in the list to add or remove it from favorites.
- Persisted using `UserDefaults` for simplicity.

### Performance Charts
- Built with Swift Charts for interactive data visualization.
- Users can filter performance by time intervals (e.g., 24 hours, 7 days, 1 month).

### SVG Placeholder Handling
- Due to issues with SVG image downloads, a placeholder image is used. Debugging for this is ongoing.

---

## Error Handling

- **Network Errors:**
  - Displays user-friendly error messages for connectivity issues.
- **API Errors:**
  - Handles unexpected API response formats and logs details for debugging.
- **Data Parsing Errors:**
  - Validates API data before usage to ensure reliability.

---

## Assumptions

- The CoinRanking API response will always include the required fields (icon, name, price, performance data).
- Filtering and pagination logic are client-side.
- The app assumes basic network connectivity for operation.

---

## Challenges and Solutions

### SVG Image Support
- **Challenge:** The CoinRanking API provides icons in SVG format, which are not natively supported in iOS.
- **Solution:** Used a placeholder image while exploring third-party libraries for SVG rendering.

### Combining UIKit and SwiftUI
- **Challenge:** Integrating UIKit and SwiftUI seamlessly.
- **Solution:** Utilized `UIHostingController` and protocol-based communication between components.

### Pagination
- **Challenge:** Efficiently loading and displaying large datasets.
- **Solution:** Implemented lazy loading and optimized scrolling performance.

---
