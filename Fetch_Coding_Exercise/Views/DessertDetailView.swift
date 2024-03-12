//
//  DessertDetailView.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import SwiftUI

/* The `DessertDetailView` struct shows detailed information about a specific dessert.
It takes `dessertID` as input which is then used to fetch the detailed information.
The observed object `dessertDetailViewModel` is used to retreive the dessert detail data from the data source.
The detail data is fetched when the view appears.
A pseudo-modal is presented once the data has been retreived then displays it.
Error messages are displayed on change of the networkError property in the viewmodel.
The design for this view was inspired by https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App*/

struct DessertDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    let dessertID: String
    @ObservedObject var dessertDetailViewModel = DessertDetailViewModel()
    @State private var presentModal = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                VStack (alignment: .center){
                    // If the dessert details are fetched, display the image.
                    // Image should present as a full background behind the modal
                    if let dessertDetail = dessertDetailViewModel.dessertDetail {
                        VStack{
                            DessertImage(imageURL: dessertDetail.image)
                                .frame(width: geometry.size.width, height: 450)
                        }
                    } else {
                        // If the dessert details aren't fetched yet, display a loading indicator.
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.bottom)
                .edgesIgnoringSafeArea(.top)
                .background(Color.clear)
                .zIndex(0)
                if presentModal {
                    DessertDetailModal(geometry: geometry, dessertDetail: dessertDetailViewModel.dessertDetail!, difficulty: dessertDetailViewModel.difficulty)
                        .background(Color(.secondarySystemBackground))
                        .frame(height: geometry.size.height * 0.7)
                        .cornerRadius(20)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                        .offset(y: geometry.size.height * 0.45)
                }
                Button(action: {
                    //Dismiss the modal first so dessertDetail does not become nil
                    presentModal = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundColor(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
                        Image(systemName: "arrow.left")
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                .padding()
                .padding(.top,20)
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                Task {
                    await dessertDetailViewModel.fetchDessertDetail(for: dessertID)
                }
            }
            .onChange(of: dessertDetailViewModel.detailsFetched) {
                // Present the modal only when the data has been retreived
                if dessertDetailViewModel.detailsFetched {
                    withAnimation {
                        presentModal = true
                    }
                }
            }
        }
    }
}

/* The `DessertDetailModal` struct shows the detail data of a dessert in a pseudo-modal format.
It takes `dessertDetail` and `difficulty` as inputs. `dessertDetail` contains the detailed information of the dessert,
and `difficulty` indicates the difficulty level of preparing the dessert.
The design for this view was inspired by https://dribbble.com/shots/20792040-Cookpedia-Food-Recipe-Mobile-App*/

struct DessertDetailModal: View {
    @Environment(\.dismiss) var dismiss
    var geometry: GeometryProxy
    let dessertDetail: DessertDetail
    let difficulty: Difficulty
    
    var body: some View {
        ScrollView {
            Spacer()
            HStack{
                VStack (alignment: .leading){
                    Text(dessertDetail.name)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing)
                    Text("\(dessertDetail.region)")
                        .foregroundColor(Color.gray)
                        .font(.headline)
                }
                Spacer()
                VStack (alignment: .trailing){
                    VStack (alignment: .center){
                        // Display indicator of difficulty based on the value and description set in DessertDetailViewModel
                        HStack {
                            ForEach(0..<difficulty.rawValue, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(difficulty == .easy ? Color.green : difficulty == .medium ? Color.orange : Color.red)
                            }
                        }
                        .font(.headline)
                        Text(difficulty.description)
                            .foregroundColor(Color.gray)
                            .font(.headline)
                    }
                }
            }
            .padding(.bottom, 10)
            Spacer()
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(.headline)
                    .fontWeight(.black)
                    .padding(.bottom, 5)
                ForEach(dessertDetail.ingredients, id: \.name) { ingredient in
                    HStack {
                        DessertImage(imageURL: URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")-Small.png"))
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.06)
                            .padding(.trailing)
                        Text("\(ingredient.name)")
                        Spacer()
                        Text("\(ingredient.measure)")
                    }
                    .padding([.leading, .trailing])
                    .font(.body)
                }
            }
            .padding(.bottom, 15)
            Spacer()
            VStack(alignment: .leading){
                Text("Instructions")
                    .font(.headline)
                    .fontWeight(.black)
                    .padding(.bottom, 5)
                Text(dessertDetail.instructions)
                    .padding(.bottom)
                Spacer()
            }
            .padding(.bottom)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .padding(.top, 35)
        .interactiveDismissDisabled()
    }
}
