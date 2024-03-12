//
//  DessertImageView.swift
//  Fetch_Coding_Exercise
//
//  Created by Ugonna Oparaochaekwe on 3/11/24.
//

import SwiftUI

/* The `DessertImage` struct can display the images of a dessert as well as the images of its ingredients.
 For each ingredient, a url to that ingredients thumbnail is passed from `DessertDetailModal`.
 If the image is not yet loaded or nothing is found, it displays progress indicators.*/
struct DessertImage: View {
    var imageURL: URL?
    var body: some View {
        VStack (alignment: .center){
            if let imageUrl = imageURL {
                AsyncImage(url: imageUrl, transaction: Transaction(animation: .spring())) { phase in
                    switch phase {
                    case .success(let image):
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 200/255, green: 200/255, blue: 200/255))
                            image
                                .resizable()
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fill)
                        }
                    default:
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 3)
                            ProgressView()
                        }
                    }
                }
            }
        }
        .background(Color.clear)
        .zIndex(0)
    }
}

#Preview {
    DessertImage()
}
