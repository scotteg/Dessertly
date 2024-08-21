//
//  DessertsListView.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import SwiftUI

struct DessertsListView: View {
    @State private var viewModel = DessertsListViewModel()
    @State private var desserts: [Dessert] = []
    @State private var isLoading = true
    @State private var isShowingError = false
    @State private var currentErrorMessage: String?
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if desserts.isEmpty {
                    Text("No desserts available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(desserts, id: \.id) { dessert in
                        NavigationLink(destination: DessertDetailView(dessertID: dessert.id)) {
                            HStack {
                                if let url = URL(string: dessert.thumbnail) {
                                    CachedAsyncImage(url: url)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                }
                                Text(dessert.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Desserts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dessertly")
                        .font(.custom("Lobster-Regular", size: 24))
                        .foregroundColor(.blue)
                        .accessibilityAddTraits(.isHeader)
                }
            }
            .searchable(text: $searchQuery, prompt: "Search for desserts")
            .onChange(of: searchQuery) {
                Task {
                    await updateFilteredDesserts()
                }
            }
            .task {
                await loadDesserts()
            }
            .alert(isPresented: $isShowingError) {
                Alert(
                    title: Text("Error"),
                    message: Text(currentErrorMessage ?? "An error occurred."),
                    dismissButton: .default(Text("OK")) {
                        Task {
                            await ErrorHandler.shared.clearError()
                        }
                    }
                )
            }
        }
    }
    
    private func loadDesserts() async {
        await viewModel.loadDesserts()
        await updateFilteredDesserts()
        isLoading = false
        if let error = await viewModel.errorMessage {
            currentErrorMessage = error
            isShowingError = true
        }
    }
    
    private func updateFilteredDesserts() async {
        await viewModel.updateSearchQuery(searchQuery)
        desserts = await viewModel.filteredDesserts
    }
}

#Preview {
    DessertsListView()
}
