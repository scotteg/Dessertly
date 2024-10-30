//
//  DessertDetailView.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/19/24.
//

import SwiftUI

struct DessertDetailView: View {
    @State private var viewModel = DessertDetailViewModel()
    @State private var dessertDetail: DessertDetail?
    @State private var sortedIngredients: [(ingredient: String, measure: String)] = []
    @State private var sortAscending = true
    @State private var isLoading = true
    @State private var showErrorAlert = false
    @State private var currentErrorMessage: String?

    let dessertID: String

    var body: some View {
        GeometryReader { geometry in
            Group {
                if isLoading {
                    ProgressView()
                        .padding()
                        .accessibilityLabel("Loading dessert details")
                } else if let errorMessage = currentErrorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .accessibilityLabel("Error: \(errorMessage)")
                        Spacer()
                    }
                } else if let detail = dessertDetail {
                    content(for: detail, geometry: geometry)
                        .navigationTitle(dessertDetail?.name ?? "Dessert Detail")
                }
            }
            .alert(isPresented: $showErrorAlert) {
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
        .task {
            await loadDessertDetail()
        }
    }

    @ViewBuilder
    private func content(for detail: DessertDetail, geometry: GeometryProxy) -> some View {
        if geometry.size.width > geometry.size.height {
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
                    .accessibilityLabel("Image of \(dessertDetail?.name ?? "dessert")")
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
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel("Instructions")
    }

    @ViewBuilder
    private func ingredientsSection() -> some View {
        if !sortedIngredients.isEmpty {
            GroupBox(label: HStack {
                Label("Ingredients", systemImage: "cart")
                Spacer()
                Button(action: {
                    Task {
                        await toggleSortOrder()
                    }
                }) {
                    Image(systemName: sortAscending ? "chevron.up" : "chevron.down")
                }
                .accessibilityLabel("Sort ingredients")
                .accessibilityHint("Tap to sort ingredients in \(sortAscending ? "ascending" : "descending") order")
            }) {
                VStack(alignment: .leading) {
                    ForEach(sortedIngredients, id: \.ingredient) { ingredient, measure in
                        HStack {
                            Text(ingredient)
                            Spacer()
                            Text(measure)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(ingredient), \(measure)")

                        Divider()
                    }
                }
                .padding()
            }
            .padding(.horizontal)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("Ingredients")
        }
    }

    private func loadDessertDetail() async {
        await updateLoadingState()

        await viewModel.loadDessertDetail(dessertID: dessertID)
        dessertDetail = await viewModel.dessertDetail

        if let error = await viewModel.errorMessage {
            currentErrorMessage = error
            showErrorAlert = true
        } else if let ingredients = dessertDetail?.ingredients {
            sortedIngredients = await viewModel.sortIngredients(ingredients: ingredients,
                                                                ascending: sortAscending)
        }

        await updateLoadingState()
    }

    private func toggleSortOrder() async {
        sortAscending.toggle()
        if let ingredients = dessertDetail?.ingredients {
            sortedIngredients = await viewModel.sortIngredients(ingredients: ingredients, ascending: sortAscending)
        }
    }

    private func updateLoadingState() async {
        isLoading = await viewModel.isLoading
    }
}

#Preview {
    DessertDetailView(dessertID: "53049")
}
