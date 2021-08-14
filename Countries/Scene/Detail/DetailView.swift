//
//  DetailView.swift
//  Countries
//
//  Created by Kien on 01/07/2021.
//

import SwiftUI
import MapKit

struct DetailView: View {
  @StateObject private var viewModel: DetailViewModel
  
  init(country: Country) {
    _viewModel = StateObject(wrappedValue: DetailViewModel(country: country))
  }
  
  var body: some View {
    VStack {
      Map(coordinateRegion: $viewModel.coordinate).frame(height: 300)
      infoView
    }.navigationBarItems(trailing: Button {
      viewModel.toggleFavorite()
    } label: {
      Image(systemName: viewModel.country.isFavorite_ ? "star.fill" : "star")
    })
  }
  
  var infoView: some View {
    VStack {
      ScrollView {
        VStack {
          if !viewModel.country.nativeName_.isEmpty && viewModel.country.nativeName_ != viewModel.country.name_ {
            Text(viewModel.country.nativeName_)
            Text(viewModel.country.name_)
              .font(.title2.bold())
          } else {
            Text(viewModel.country.name_)
          }
        }
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.bottom, 20)
        
        VStack(alignment: .leading) {
          if !viewModel.country.capital_.isEmpty {
            HStack {
              Text("**Capital:** \(viewModel.country.capital_)")
              Spacer()
            }
          }
          if !viewModel.country.subregion_.isEmpty {
            HStack {
              Text("**Region:** \(viewModel.country.subregion_)")
              Spacer()
            }
          }
          if viewModel.country.population_ > 0 {
            HStack {
              Text("**Population:** \(viewModel.country.population_.formatted)")
              Spacer()
            }
          }
          if viewModel.country.area_ > 0 {
            HStack {
              Text("**Area:** \(viewModel.country.area_.formatted) km2")
              Spacer()
            }
          }
          if viewModel.hasNeighboringCountries {
            HStack {
              Text("**Neighboring countries:** \(viewModel.neighboringCountries)")
              Spacer()
            }
          }
          if viewModel.hasTimeZones {
            HStack {
              Text("**Timezone:** \(viewModel.timeZones)")
              Spacer()
            }
          }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        
        AsyncImage(url: URL(string: viewModel.flagURL)) { img in
          img.resizable()
        } placeholder: {
          ProgressView()
        }
        .aspectRatio(contentMode: .fit)
        .frame(height: 100)
      }
      Spacer()
    }
  }
}
