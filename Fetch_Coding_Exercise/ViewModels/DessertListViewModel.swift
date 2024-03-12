//
//  DessertListViewModel.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import Foundation
/* Fetches an array of `Dessert` objects using NetworkService.
The `fetchDesserts()` method makes an asynchronous request to fetch all desserts.
The filteredDesserts method updates the filteredDesserts property whenever
the values of`searchText` or `desserts` changes.*/

class DessertListViewModel: ObservableObject {
    private var networkService = NetworkService()
    
    @Published var searchText: String = "" {
        didSet {
            filterDesserts()
        }
    }
    
    @Published var desserts: [Dessert] = [] {
        didSet {
            filterDesserts()
        }
    }
    
    @Published var filteredDesserts: [Dessert] = []
    
    private func filterDesserts() {
        if searchText.isEmpty {
            filteredDesserts = desserts
        } else {
            filteredDesserts = desserts.filter { dessert in
                dessert.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService as! NetworkService
    }
    @Published var networkError: NetworkError?
    
    @MainActor
    func fetchDesserts() async {
        do {
            let fetchedDesserts = try await networkService.fetchDesserts()
            self.desserts = fetchedDesserts
        } catch let error as NetworkError {
            self.networkError = error
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

