//
//  PersistenceManager.swift
//  GitHubSearch
//
//  Created by GJC03280 on 2021/10/22.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType) async throws -> GFError? {
        
        do {
            var favorites = try await retrieveFavorites()
            switch actionType {
            case .add:
                guard !favorites.contains(favorite) else {
                    return GFError.alreadyInFavorites
                }
                favorites.append(favorite)
            case .remove:
                favorites.removeAll { $0.login == favorite.login }
            }
            return save(favorites: favorites)
        } catch {
            throw error
        }
    }
    
    static func retrieveFavorites() async throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw GFError.unableToFavorites
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorites
        }
    }
}
