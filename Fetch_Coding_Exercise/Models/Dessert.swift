//
//  Dessert.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import Foundation
struct DessertResponse: Decodable {
    let meals: [Dessert]
}

/* The `Dessert` struct represents a basic structure to retreive information
   about each meal from the Dessert category endpoint. This information includes
   the id, name, and a URL to an image of the dessert.
*/
struct Dessert: Identifiable, Decodable {
    var id: String
    var name: String
    var image: URL

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case image = "strMealThumb"
    }
}

