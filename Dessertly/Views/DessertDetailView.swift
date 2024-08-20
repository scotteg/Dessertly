//
//  DessertDetailView.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/19/24.
//

import SwiftUI

struct DessertDetailView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let dessertID: String
    
    @State private var dessertDetail: DessertDetail?
    @State private var isLoading = true
    @State private var hasError = false
    @State private var sortedIngredients: [(ingredient: String, measure: String)] = []
    @State private var sortAscending = true
    
    private let viewModel = DessertDetailViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                ProgressView()
                    .padding()
            } else if hasError {
                Text("An error occurred while loading the dessert detail.")
                    .foregroundColor(.red)
                    .padding()
            } else if let detail = dessertDetail {
                content(for: detail, geometry: geometry)
                    .navigationTitle(isLoading ? "Loading Detail..." : dessertDetail?.name ?? "Dessert Detail")
            }
        }
        .onAppear {
            Task {
                await loadDessertDetail()
                await sortIngredients(for: dessertDetail?.ingredients ?? [:])
            }
        }
    }
    
    @ViewBuilder
    private func content(for detail: DessertDetail, geometry: GeometryProxy) -> some View {
        if verticalSizeClass == .compact {
            landscapeContent(for: detail, geometry: geometry)
        } else {
            portraitContent(for: detail)
        }
    }
    
    private func landscapeContent(for detail: DessertDetail, geometry: GeometryProxy) -> some View {
        HStack(alignment: .top, spacing: 16) {
            if let url = URL(string: detail.imageUrl) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .padding(.leading)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    instructionsSection(detail.instructions)
                    ingredientsSection()
                }
                .frame(maxWidth: geometry.size.width - 200)
                .padding(.trailing)
            }
        }
        .padding(.top, geometry.safeAreaInsets.top)
    }
    
    private func portraitContent(for detail: DessertDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: detail.imageUrl) {
                    CachedAsyncImage(url: url)
                        .scaledToFill()
                        .frame(maxHeight: 300)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                instructionsSection(detail.instructions)
                ingredientsSection()
            }
            .padding(.top)
        }
    }
    
    @ViewBuilder
    private func instructionsSection(_ instructions: String?) -> some View {
        GroupBox(label: Label("Instructions", systemImage: "list.bullet")) {
            Text(instructions ?? "No instructions available.")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func ingredientsSection() -> some View {
        if !sortedIngredients.isEmpty {
            GroupBox(label: HStack {
                Label("Ingredients", systemImage: "cart")
                Spacer()
                Button(action: {
                    Task {
                        sortAscending.toggle()
                        await sortIngredients(for: dessertDetail?.ingredients ?? [:])
                    }
                }) {
                    Image(systemName: sortAscending ? "chevron.up" : "chevron.down")
                }
            }) {
                VStack(alignment: .leading) {
                    ForEach(sortedIngredients, id: \.ingredient) { ingredient, measure in
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
    
    private func sortIngredients(for ingredients: [String: String]) async {
        sortedIngredients = await viewModel.sortIngredients(ingredients: ingredients, ascending: sortAscending)
    }
    
    private func loadDessertDetail() async {
        await viewModel.loadDessertDetail(dessertID: dessertID)
        self.dessertDetail = await viewModel.dessertDetail
        self.isLoading = false
        
        if await viewModel.dessertDetail == nil {
            self.hasError = true
        }
    }
}

#Preview {
    DessertDetailView(dessertID: "53049")
}
