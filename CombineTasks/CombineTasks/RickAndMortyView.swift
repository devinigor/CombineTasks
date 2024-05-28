//
//  RickAndMortyView.swift
//  CombineTasks
//
//  Created by Игорь Девин on 28.05.2024.
//

import SwiftUI

 struct RickAndMortyView: View {

     var body: some View {
         VStack {
             switch viewModel.state {
             case .loading:
                 loadingLogoView
             case .loaded:
                 headerNameView
                 searchTextFieldView
                 ZStack {
                     panelFilterView
                     filterView
                 }
                 listView
                     .padding(.horizontal, 20)
             case .error(let error):
                 EmptyView()
                     .alert(isPresented: $viewModel.isShowAlert) {
                         Alert(title: Text("Ошибка"),
                               message: Text(error.localizedDescription),
                               dismissButton: .default(Text("OK")) {
                         })
                     }
             }
         }
         .onAppear {
             viewModel.fetch()
             viewModel.fetchImage()
         }
     }

     @StateObject var viewModel = RickAndMortyViewModel()
     @State private var text = ""

     private var loadingLogoView: some View {
         Image(.logo)
             .rotationEffect(.degrees(self.viewModel.isConnecting ? 360 : 0))
             .onAppear {
                 withAnimation(Animation.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                     viewModel.performAnimation()
                 }
             }
     }

     private var headerNameView: some View {
         Image(.rickMorty)
     }

     private var searchTextFieldView: some View {
         TextField("Name or episode (ex.S01E01)...", text: $text)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .frame(width: 312, height: 56)
     }

     private var panelFilterView: some View {
         RoundedRectangle(cornerRadius: 10.0)
             .frame(width: 312, height: 56)
             .foregroundColor(.backgroundPanelFilter)
             .shadow(color: .gray.opacity(0.5), radius: 4, y: 2)
     }

     private var filterView: some View {
         HStack {
             Image(.filterIcon)
                 .padding(.leading, -50)
             Text("ADVANCED FILTERS")
                 .foregroundColor(.blue)
                 .font(.body)
         }
     }

     private var listView: some View {
         List(viewModel.dataToEpisode, id: \.id) { series in
             RoundedRectangle(cornerRadius: 10)
                 .fill(.white)
                 .shadow(color: .gray.opacity(0.5), radius: 4, y: 2)
                 .frame(width: 311, height: 415)
                 .overlay(
                     VStack {
                         if let character = viewModel.dataToCharacters.first {
                             AsyncImage(url: URL(string: character.image)) { image in
                                 image
                                     .resizable()
                                     .aspectRatio(contentMode: .fill)
                             } placeholder: {
                                 ProgressView()
                             }
                             HStack {
                                 Text("\(character.name)")
                                     .font(.title3)
                                     .bold()
                                 Spacer()
                             }
                             .padding(.leading, 15)
                         }
                         RoundedRectangle(cornerRadius: 10)
                             .fill(.backgroundPanelFilter.opacity(0.4))
                             .frame(width: 311, height: 71)
                             .overlay(
                                 HStack {
                                     Image(.monitorPlayLogo)
                                     Text(series.name)
                                     Text("|")
                                     Text(series.episode)
                                     Spacer()
                                     Image(.heart)
                                 }
                                     .padding()
                             )
                     }
                 )
         }
         .listStyle(PlainListStyle())
         .scrollIndicators(.never)
     }
 }

 #Preview {
     RickAndMortyView()
 }
