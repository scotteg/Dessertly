//
//  DessertDetailView.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/19/24.
//

import SwiftUI

struct DessertDetailView: View {
    let dessertID: String
    
    @State private var dessertDetail: DessertDetail?
    @State private var isLoading = true
    @State private var hasError = false
    
    private let viewModel = DessertDetailViewModel()
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding()
            } else if hasError {
                Text("An error occurred while loading the dessert detail.")
                    .foregroundColor(.red)
                    .padding()
            } else if let detail = dessertDetail {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Dessert Image
                    if let url = URL(string: detail.imageUrl) {
                        CachedAsyncImage(url: url)
                            .scaledToFill()
                            .frame(maxHeight: 300)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // MARK: - Instructions Section
                    GroupBox(label: Label("Instructions", systemImage: "list.bullet")) {
                        Text(detail.instructions ?? "No instructions available.")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Ingredients Section
                    if !detail.ingredients.isEmpty {
                        GroupBox(label: Label("Ingredients", systemImage: "cart")) {
                            VStack(alignment: .leading) {
                                ForEach(detail.ingredients.sorted(by: >), id: \.key) { ingredient, measure in
                                    HStack {
                                        Text(ingredient)
                                        Spacer()
                                        Text(measure)
                                    }
                                    Divider()
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .navigationTitle(isLoading ? "Loading Detail..." : dessertDetail?.name ?? "Dessert Detail")
        .onAppear {
            Task {
                await viewModel.loadDessertDetail(dessertID: dessertID)
                await self.dessertDetail = viewModel.dessertDetail
                self.isLoading = false
                
                if await viewModel.dessertDetail == nil {
                    self.hasError = true
                }
            }
        }
    }
}

#Preview {
    DessertDetailView(dessertID: "53049")
}
