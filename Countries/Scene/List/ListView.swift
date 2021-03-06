//
//  ListView.swift
//  Countries
//
//  Created by Kien on 28/06/2021.
//

import SwiftUI

struct ListView: View {
  @StateObject private var viewModel = ListViewModel()
  
  var body: some View {
    NavigationView {
      List {
        if viewModel.isGrouped {
          groupedList
        } else {
          plainList
        }
      }
      .searchable(text: $viewModel.searchText)
      .disableAutocorrection(true)
      .refreshable { await viewModel.refresh() }
      .navigationTitle("Countries")
      .navigationBarItems(leading: leadingButtons, trailing: sortMenu)
      .task {
        if !viewModel.isLoaded {
          await viewModel.load() 
        }
      }
    }
  }
  
  private var groupedList: some View {
    ForEach(viewModel.groups, id: \.self) { section in
      Section(viewModel.sectionName(for: section)) {
        ForEach(viewModel.rows(section: section).indexed(), id: \.1.name_) {
          CountryCell(country: $1, keywords: viewModel.searchText, index: $0, useCase: viewModel.useCase)
            .listRowSeparator(.hidden)
        }
      }
    }
  }
  
  private var plainList: some View {
    Section(viewModel.sectionName()) {
      ForEach(viewModel.rows().indexed(), id: \.1.alpha3Code_) {
        CountryCell(country: $1, keywords: viewModel.searchText, index: $0, useCase: viewModel.useCase)
          .listRowSeparator(.hidden)
      }
    }
  }
  
  private var sortMenu: some View {
    Menu {
      ForEach(Sort.allCases, content: sortMenuItem)
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
  
  private var leadingButtons: some View {
    HStack {
      Button {
        viewModel.showFavoriteOnly.toggle()
      } label: {
        Image(systemName: viewModel.showFavoriteOnly ? "star.fill" : "star.slash.fill" )
      }
      
      Button {
        viewModel.isGrouped.toggle()
      } label: {
        Image(systemName: viewModel.isGrouped ? "rectangle.grid.1x2" : "line.3.horizontal")
      }
    }
  }
  
  private func sortMenuItem(_ sort: Sort) -> some View {
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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ListView()
  }
}
