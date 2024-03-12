//
//  DessertDetail.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import Foundation

struct DessertDetailResponse: Decodable {
    let meals: [DessertDetail]
}

/* The `DessertDetail` struct represents structure designed to
   retreive information about a meal from the lookup endpoint.
   This includes the id, name, category, region, instructions,
   url to an image, and a list of ingredients.
*/
struct DessertDetail: Identifiable, Decodable {
    var id: String
    var name: String
    var region: String
    var instructions: String
    var image: URL
    var ingredients: [Ingredient]
}

/* The `Ingredient` struct represents structure designed to
   retreive information about an ingredient from the ingredients endpoint.
   This includes the name and measure.
*/

struct Ingredient: Decodable {
    let name: String
    let measure: String
}
