//
//  DessertListView.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import SwiftUI

/* The `DessertListView` struct presents a list of desserts vertically.
When a user clicks on a dessert it presents a detail view of that dessert.
The observed object `dessertViewModel` is used to retrieve the list of desserts from the data source.
The list of desserts is filtered based on the Published variable `searchText`.
The initial list of desserts is fetched when the view appears.
Error messages are displayed on change of networkSError property in view mdoel.
The design for this view was inspired by https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App*/
struct DessertListView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var dessertViewModel = DessertListViewModel()
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack{
                    HStack {
                        VStack(alignment: .leading){
                            Text("Hello,")
                                .font(.title3)
                                .foregroundColor(Color(.systemGray2))
                            Text("What would you like")
                                .font(.title.bold())
                            Text("to cook today?")
                                .font(.title.bold())
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    .padding(.top, 35)
                    
                    HStack {
                        TextField("Search any recipes", text: $dessertViewModel.searchText)
                            .padding(10)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                    .background(Color(.systemGray4))
                    .cornerRadius(20)
                    .padding(.horizontal, 35)
                    
                    Spacer()
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(dessertViewModel.filteredDesserts) { dessert in
                                NavigationLink(destination: DessertDetailView(dessertID: dessert.id)) {
                                    VStack {
                                        Spacer()
                                        VStack {
                                            DessertImage(imageURL: dessert.image)
                                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                                                .clipped()
                                                .cornerRadius(25)
                                            Text(dessert.name.uppercased())
                                                .fontWeight(.heavy)
                                        }
                                        Spacer()
                                            .padding(.bottom)
                                    }
                                    .accentColor(colorScheme == .dark ? Color.white : Color.black)
                                    .padding(.vertical)
                                }
                            }
                        }
                    }
                    .padding(.top, 40)
                    
                    // A tip encouraging the user to swipe
                    VStack{
                        HStack{
                            Image(systemName: "arrow.up")
                                .foregroundColor(colorScheme == .dark ? Color(red: 100/255, green: 100/255, blue: 100/255) : .black)
                                .padding(.trailing, 10)
                            Text("Swipe")
                                .padding(10)
                            Image(systemName: "arrow.down")
                                .foregroundColor(colorScheme == .dark ? Color(red: 100/255, green: 100/255, blue: 100/255) : .black)
                                .padding(.leading, 10)
                        }
                    }
                }
                .background(Color(.secondarySystemBackground))
                .onAppear {
                    Task {
                        await dessertViewModel.fetchDesserts()
                    }
                }
            }
        }
    }
}

struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}
