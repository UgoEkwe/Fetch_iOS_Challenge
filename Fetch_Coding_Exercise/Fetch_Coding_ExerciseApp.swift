//
//  Fetch_Coding_ExerciseApp.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import SwiftUI

/* This App Fetches desserts from an API and lists them alphabetically.
When a desert is selected from the list, a detail view is shown with instructions and ingredients.*/
@main
struct Fetch_Coding_ExerciseApp: App {
    var body: some Scene {
        WindowGroup {
            DessertListView()
        }
    }
}
