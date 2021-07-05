//
//  CountryCell.swift
//  Countries
//
//  Created by Kien on 30/06/2021.
//

import SwiftUI

struct CountryCell: View {
  @ObservedObject var viewModel: CountryCellViewModel
  let showIndex: Bool
  
  var body: some View {
    NavigationLink(destination: MapView(latitude: viewModel.lat, longitude: viewModel.lng).edgesIgnoringSafeArea(.all)) {
      HStack {
        VStack(alignment: .leading) {
          Text(viewModel.subregion)
            .font(.caption)
            .foregroundColor(.secondary)
          HStack {
            Text(viewModel.name).font(.title2.bold())
            if viewModel.isFavorite {
              Image(systemName: "star.fill")
            }
          }
          if let capital = viewModel.capital  {
            Text(capital).font(.headline)
          }
          Text(viewModel.population).font(.caption)
          if let area = viewModel.area {
            Text(area).font(.caption)
          }
        }
        Spacer()
        if showIndex {
          ZStack {
            Circle()
              .foregroundColor(Color(UIColor.quaternarySystemFill))
              .frame(width: 60)
            Text("\(viewModel.index + 1)")
              .font(.title.bold())
              .foregroundColor(.secondary)
          }
        }
      }
      .id(viewModel.primaryKey)
    }
    .swipeActions(edge: .leading) {
      if viewModel.isFavorite {
        Button(role: .destructive) {
          viewModel.toggleFavorite()
        } label: {
          Label("Unfavorite", systemImage: "star.slash.fill")
        }
      } else {
        Button() {
          viewModel.toggleFavorite()
        } label: {
          Label( "Favorite", systemImage: "star.fill")
        }
        .tint(.blue)
      }
    }
  }
}
