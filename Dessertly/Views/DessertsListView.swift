//
//  DessertsListView.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import SwiftUI

struct DessertsListView: View {
    @State private var desserts: [Dessert] = []
    @State private var isLoading = true
    @State private var isShowingError = false
    @State private var currentErrorMessage: String?
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if desserts.isEmpty {
                    Text("No desserts available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(filteredDesserts, id: \.id) { dessert in
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
            .onAppear {
                Task {
                    await loadDesserts()
                    
                    if let error = await ErrorHandler.shared.getCurrentError() {
                        self.currentErrorMessage = error.localizedDescription
                        self.isShowingError = true
                    }
                }
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
        do {
            let fetchedDesserts = try await DessertService.shared.fetchDesserts()
            self.desserts = fetchedDesserts
        } catch {
            await ErrorHandler.shared.report(error: error)
        }
        self.isLoading = false
    }
    
    private var filteredDesserts: [Dessert] {
        if searchQuery.isEmpty {
            return desserts
        } else {
            return desserts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}

#Preview {
    DessertsListView()
}
