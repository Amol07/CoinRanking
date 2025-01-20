//
//  CoreDataManager.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import CoreData

/// A protocol that defines methods for managing favorite coins in a Core Data context.
protocol CoreDataFavoriteCoinProvider {

    /// Fetches all favorite coins stored in the Core Data database.
    ///
    /// - Returns: An array of `CoinEntity` objects representing the favorite coins.
    func fetchFavoriteCoins() -> [CoinEntity]

    /// Saves a new favorite coin to the Core Data database.
    ///
    /// - Parameter coin: An instance of `Coin` that represents the coin to be saved as a favorite.
    func saveFavoriteCoin(_ coin: Coin)

    /// Removes a favorite coin from the Core Data database using its unique identifier (UUID).
    ///
    /// - Parameter id: A `String` representing the UUID of the coin to be removed.
    /// - Returns: A `Bool` indicating whether the removal was successful (`true`) or not (`false`).
    @discardableResult
    func removeFavoriteCoin(withUUID id: String) -> Bool
}

/// Manages the Core Data stack for the app.
class CoreDataManager {

    // MARK: - Private properties

    /**
     * The persistent container for the app's Core Data stack.
     *
     * This is a lazy-loaded property that creates a persistent container with the name "CoinRanking"
     * and loads the persistent stores. If there's an error loading the stores, it will fatal error.
     */
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoinRanking")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    /**
     * The managed object context for the app's Core Data stack.
     *
     * This is a computed property that returns the view context of the persistent container.
     */
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Public properties

    /// A shared instance of the CoreDataManager.
    static let shared = CoreDataManager()

    // MARK: - Initialiser

    /**
     * Initializes a new CoreDataManager instance.
     *
     * This is a private initializer to ensure that only one instance of CoreDataManager is created.
     */
    private init() {}

    // MARK: - Private methods

    /**
     * Saves the managed object context.
     *
     * This method checks if there are any changes in the context and saves it if there are.
     * If there's an error saving the context, it will fatal error.
     */
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager: CoreDataFavoriteCoinProvider {
    func fetchFavoriteCoins() -> [CoinEntity] {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            debugPrint("Saved coins: \(result)")
            return result
        } catch {
            return []
        }
    }

    func saveFavoriteCoin(_ coin: Coin) {
        let favoriteCoin = CoinEntity(context: context)
        favoriteCoin.iconURL = coin.iconURL
        favoriteCoin.name = coin.name
        favoriteCoin.symbol = coin.symbol
        favoriteCoin.uuid = coin.uuid

        saveContext()
    }

    func removeFavoriteCoin(withUUID id: String) -> Bool {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id)

        guard let filteredCoinEntity = try? context.fetch(fetchRequest).first else { return false }
        context.delete(filteredCoinEntity)
        saveContext()
        return true
    }
}
