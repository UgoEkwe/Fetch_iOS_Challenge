//
//  NetworkService.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import Foundation

/* 'decodingError`: This error occurs when there's an issue with decoding the data received from the server.
`httpError`: This error means there was an issue with the network request itself.
`noData`: This error is for the case when no data was received.*/
enum NetworkError: Error {
    case decodingError
    case httpError
    case noData
}

/*This protocol abstracts network-related logic, decoupling that logic to make the view models easier to test and/or maintain.*/
protocol NetworkServiceProtocol {
    func fetchDesserts() async throws -> [Dessert]
    func fetchDessertDetail(mealId: String) async throws -> [DessertDetail]
}

/* `fetchDesserts()`: This method fetches a list of `Dessert` objects from TheMealDB API. If successful, the fetched data is decoded into an array of `Dessert` objects.
If an error occurs during this process, it is wrapped in a `NetworkError` and passed to the `completion` closure.

`fetchDessertDetail()`: This method fetches detailed information about a single dessert identified by `mealId`.
If successful, the fetched data is transformed into a `DessertDetail` object, which is then passed to the `completion` closure.
If an error occurs at any point during this process, it is wrapped in a `NetworkError` and passed to the `completion` closure.
 
Ingredients are fetched and decoded dynamically*/
class NetworkService: NetworkServiceProtocol{
    func fetchDesserts() async throws -> [Dessert] {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let dessertData = try decoder.decode(DessertResponse.self, from: data)
        return dessertData.meals
    }
    
    func fetchDessertDetail(mealId: String) async throws -> [DessertDetail] {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let mealData = jsonObject as? [String: [MealData]],
              let meal = mealData["meals"]?.first else {
            throw NetworkError.decodingError
        }
        
        var ingredients: [Ingredient] = []
        var count = 1
        while let ingredientName = meal["strIngredient\(count)"] as? String,
              let ingredientMeasure = meal["strMeasure\(count)"] as? String,
              !ingredientName.isEmpty,
              !ingredientMeasure.isEmpty {
            ingredients.append(Ingredient(name: ingredientName, measure: ingredientMeasure))
            count += 1
        }
        
        let id = meal["idMeal"] as? String ?? ""
        let name = meal["strMeal"] as? String ?? ""
        let region = meal["strArea"] as? String ?? ""
        let instructions = meal["strInstructions"] as? String ?? ""
        let imageURL = URL(string: meal["strMealThumb"] as? String ?? "") ?? URL(fileURLWithPath: "")
        
        let dessertDetail = DessertDetail(
            id: id,
            name: name,
            region: region,
            instructions: instructions,
            image: imageURL,
            ingredients: ingredients
        )
        return [dessertDetail]
    }
}

/* `MealData` is a typealias for a dictionary that maps a string to any type (`[String: Any]`).
This type is used to help decode JSON data received from the network into a more manageable form for further processing.*/
typealias MealData = [String: Any]
