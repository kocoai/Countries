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
      List {
        if viewModel.isGrouped {
          ForEach(viewModel.regions, id: \.self) { section in
            Section(section) {
              ForEach(viewModel.rowsForSection(section: section), id: \.country.name_) { cellVM in
                CountryCell(index: 0, viewModel: cellVM, showIndex: viewModel.showIndex)
                  .listRowSeparator(.hidden)
              }
            }
          }
        } else {
          Section(viewModel.sectionName) {
            ForEach(viewModel.rows, id: \.country.name_) {
              CountryCell(index: 0, viewModel: $0, showIndex: viewModel.showIndex)
                .listRowSeparator(.hidden)
            }
          }
        }
      }
      .searchable(text: $viewModel.searchText)
      .disableAutocorrection(true)
      .refreshable { await viewModel.refresh() }
      .onAppear { async { await viewModel.load() } }
      .navigationTitle("Countries")
      .navigationBarItems(trailing: sortMenu)
    }
  }
  
  private var sortMenu: some View {
    Menu {
      ForEach(Sort.allCases, content: sortMenuItem)
      Button("Group by Region") {
        viewModel.groupByRegion()
      }
    } label: {
      if viewModel.isGrouped {
        HStack {
          Text("Region")
            .font(.caption)
          Image(systemName: "rectangle.grid.1x2")
        }
      } else {
        HStack {
          Text(viewModel.currentSort.shortLabel)
            .font(.caption)
          Image(systemName: viewModel.currentSort.isAscending ? "arrow.up.circle" : "arrow.down.circle")
        }
      }
    } primaryAction: {
      viewModel.currentSort.toggleAscending()
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
    CountriesListView()
  }
}
