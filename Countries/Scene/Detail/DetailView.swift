//
//  DetailView.swift
//  Countries
//
//  Created by Kien on 01/07/2021.
//

import SwiftUI
import MapKit
import RealmSwift

struct DetailView: View {
  @StateObject private var viewModel: DetailViewModel
  
  init(country: Country) {
    _viewModel = StateObject(wrappedValue: DetailViewModel(country: country))
  }
  var body: some View {
    ZStack {
      VStack {
        Map(coordinateRegion: $viewModel.coordinate)
        infoView
      }
      // flag
      VStack {
        HStack {
          Spacer()
          AsyncImage(url: URL(string: viewModel.flagURL)) { img in
            img.resizable()
          } placeholder: {
            ProgressView()
          }
          .frame(width: 60, height: 40)
          .shadow(radius: 10)
          .padding(.top, 40)
          .padding(.trailing, 20)
        }
        Spacer()
      }
    }
    .task {
      await viewModel.loadDetail()
    }
  }
  
  var infoView: some View {
    VStack {
      ScrollView {
        VStack {
          if viewModel.nativeName != viewModel.name {
            Text(viewModel.nativeName)
            Text(viewModel.name)
              .font(.title2.bold())
          } else {
            Text(viewModel.nativeName)
          }
        }
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        
        VStack(alignment: .leading) {
          if !viewModel.capital.isEmpty {
            HStack {
              Text("**Capital:** \(viewModel.capital)")
              Spacer()
            }
          }
          if !viewModel.subregion.isEmpty {
            HStack {
              Text("**Region:** \(viewModel.subregion)")
              Spacer()
            }
          }
          if viewModel.population > 0 {
            HStack {
              Text("**Population:** \(viewModel.population.formatted)")
              Spacer()
            }
          }
          if viewModel.area > 0 {
            HStack {
              Text("**Area:** \(viewModel.area.formatted) km2")
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
      }
      Spacer()
    }
  }
}
