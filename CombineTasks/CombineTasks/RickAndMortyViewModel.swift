//
//  RickAndMortyViewModel.swift
//  CombineTasks
//
//  Created by Игорь Девин on 28.05.2024.
//

import Foundation

import Foundation
import Combine

 enum ViewState<Model> {
     case loading
     case loaded(_ data: Model)
     case error(_ error: Error)
 }

 final class RickAndMortyViewModel: ObservableObject {
     @Published var dataToEpisode: [Episode] = []
     @Published var dataToCharacters: [Characters] = []
     @Published var state: ViewState<String> = .loading
     @Published var isConnecting: Bool = false
     @Published var isShowAlert: Bool = false

     let varificationState = PassthroughSubject<String, Never>()
     var cancellable: AnyCancellable?
     var cancellables: Set<AnyCancellable> = []

     init() {
         bind()
     }

     func fetch() {
         guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }

         URLSession.shared.dataTaskPublisher(for: url)
             .map { $0.data }
             .decode(type: RickMortyEpisode.self, decoder: JSONDecoder())
             .receive(on: RunLoop.main)
             .sink { completion in
                 if case .failure(let error) = completion {
                     print(error.localizedDescription)
                 }
             } receiveValue: { [unowned self] posts in
                 dataToEpisode = posts.results
             }
             .store(in: &cancellables)
     }

     func fetchImage() {
         guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
         URLSession.shared.dataTaskPublisher(for: url)
                     .map { $0.data }
                     .decode(type: RickMortyCharacters.self, decoder: JSONDecoder())
                     .receive(on: RunLoop.main)
                     .sink { completion in
                         if case .failure(let error) = completion {
                             print(error.localizedDescription)
                         }
                     } receiveValue: { [unowned self] images in
                         dataToCharacters = images.results
                                   }
                                   .store(in: &cancellables)
                           }

                           func bind() {
                               cancellable = varificationState
                                           .sink(receiveValue: { [unowned self] value in
                                               if !value.isEmpty {
                                                   state = .loaded(value)
                                               } else {
                                                   state = .error(NSError(domain: "Error", code: 101))
                                                   isShowAlert = true
                                               }
                                           })
                                   }

                                   func performAnimation() {
                                       let cancellable = Just(())
                                           .delay(for: .seconds(3), scheduler: DispatchQueue.main)
                                           .map { _ in true }
                                           .handleEvents(receiveOutput: { [weak self] _ in
                                                   self?.isConnecting = true
                                           })

                                           .delay(for: .seconds(2), scheduler: DispatchQueue.main)
                                           .sink { [weak self] _ in
                                               self?.state = .loaded(String())
                                               self?.isConnecting = false
                                           }
                                       cancellable.store(in: &cancellables)
                                   }
                               }
