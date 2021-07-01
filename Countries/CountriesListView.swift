//
//  CountriesListView.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI

struct CountriesListView: View {
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    NavigationView {
      List(viewModel.searchResult.indices, id: \.self) {
        CountryCell(index: $0, viewModel: viewModel.searchResult[$0], showIndex: viewModel.showIndex)
      }
      .searchable(text: $viewModel.searchText)
      .disableAutocorrection(true)
      .refreshable { await viewModel.refresh() }
      .listStyle(.insetGrouped)
      .onAppear { async { await viewModel.load() } }
      .navigationTitle("Countries (\(viewModel.searchResult.count))")
      .navigationBarItems(trailing: sortMenu)
    }
  }
  
  private var sortMenu: some View {
    Menu {
      ForEach(CountriesListView.Sort.allCases) { sort in
        Button {
          sort.toggle(&viewModel.currentSort)
        } label: {
          if let image = sort.icon(viewModel.currentSort) {
            Label(sort.label, systemImage: image)
          } else {
            Text(sort.label)
          }
        }
      }
    } label: {
      HStack {
        Text(viewModel.currentSort.shortLabel)
          .font(.caption)
        Image(systemName: viewModel.currentSort.isAscending ? "arrow.up.circle" : "arrow.down.circle")
      }
    } primaryAction: {
      viewModel.currentSort.toggleAscending()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CountriesListView()
  }
}
