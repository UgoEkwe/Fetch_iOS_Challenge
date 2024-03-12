//
//  DessertDetailViewModel.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import Foundation
/* The `Difficulty` enum represents the difficlty level of a recipe.
It has three cases: `easy`, `medium`, and `hard`. Each case is associated with an int value and a description.
It has a static function `calculateDifficulty()` that calculates the difficulty level of the recipe based on the number of ingredients.*/

enum Difficulty: Int {
    case easy = 1
    case medium = 2
    case hard = 3
    
    var description: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
    
    // Calculate the difficulty based on the number of ingredients.
    static func calculateDifficulty(basedOnIngredientCount ingredientCount: Int) -> Difficulty {
        switch ingredientCount {
        case 0...5:
            return .easy
        case 6...10:
            return .medium
        default:
            return .hard
        }
    }
}

/* Fetches a `DessertDetail` object which contains detailed information about a dessert.
The `detailsFetched` property alerts views that the dessert details have been successfuly fetched and are ready for use.
The `fetchDessertDetail() method makes an asynchronous request to fetch the details of a dessert.
If successful, it calculates the difficulty of the recipe and alerts views that the dessert details have been fetched.*/

class DessertDetailViewModel: ObservableObject {
    private var networkService = NetworkService()
    @Published var dessertDetail: DessertDetail?
    @Published var detailsFetched: Bool = false
    @Published var difficulty: Difficulty = .easy
        
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService as! NetworkService
    }
    @Published var networkError: NetworkError?
    
    @MainActor
    func fetchDessertDetail(for mealId: String) async {
        do {
            let fetchedDessertDetails = try await networkService.fetchDessertDetail(mealId: mealId)
            self.dessertDetail = fetchedDessertDetails.first
            self.detailsFetched = true
            if let ingredientCount = dessertDetail?.ingredients.count {
                difficulty = Difficulty.calculateDifficulty(basedOnIngredientCount: ingredientCount)
            }
        } catch let error as NetworkError {
            self.networkError = error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
