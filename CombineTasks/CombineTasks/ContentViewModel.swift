//
//  ContentViewModel.swift
//  CombineTasks
//
//  Created by Игорь Девин on 22.05.2024.
//

import Foundation
 import Combine

 enum ViewState<StoreMerchandise> {
     case loading
     case data(_ data: StoreMerchandise)
     case error(_ error: Error)
 }

 final class ProductViewModel: ObservableObject {

     @Published var dataToProducts: [StoreMerchandise] = []
     @Published var state: ViewState<String> = .loading
     @Published var timerLeft: String = "00:00"
     @Published var isConnecting: Bool = false
     @Published var isLoadingProduct: Bool = false
     @Published var isAnimating = false

     let verificationState = PassthroughSubject<String, Never>()
     var cancellable: AnyCancellable?
     var cancellables = Set<AnyCancellable>()
     var timerCancellable: AnyCancellable?
     private var timerCount = 0

     init() {
         dataToProducts = [
             StoreMerchandise(imageName: "star.circle.fill", name: "Молоко", price: "110"),
             StoreMerchandise(imageName: nil, name: "Хлеб", price: "57"),
             StoreMerchandise(imageName: "star.circle.fill", name: "Сыр", price: "267"),
             StoreMerchandise(imageName: "star.circle.fill", name: "Яблоки", price: "130"),
             StoreMerchandise(imageName: nil, name: "Говядина", price: "699"),
             StoreMerchandise(imageName: "star.circle.fill", name: "Рис", price: "115"),
         ]
         bind()
     }

     func bind() {
         cancellable = verificationState
             .sink(receiveValue: { [unowned self] value in
                 if !value.isEmpty {
                     state = .data(value)
                 } else {
                     state = .error(NSError(domain: "Error time", code: 101))
                 }
             })
     }

     func start() {
         let timeFormatter = DateFormatter()
         timeFormatter.dateFormat = "00:ss"
         timerCancellable = Timer
             .publish(every: 1, on: .main, in: .common)
             .autoconnect()
             .sink(receiveValue: { [unowned self] _ in
                 let minutes = String(format: "%02d", self.timerCount / 60)
                 let seconds = String(format: "%02d", self.timerCount % 60)
                 self.timerLeft = "\(minutes):\(seconds)"
                 self.timerCount += 1
             })
             isAnimating = true
     }

     func performAnimation() {
         let cancellable = Just(())
             .delay(for: .seconds(3), scheduler: DispatchQueue.main)
             .map { _ in true }
             .handleEvents(receiveOutput: { [weak self] _ in
                     self?.isConnecting = true
             })
             .delay(for: .seconds(2.5), scheduler: DispatchQueue.main)
             .map { _ in true }
             .handleEvents(receiveOutput: { [weak self] _ in
                     self?.isLoadingProduct = true
             })
             .delay(for: .seconds(4), scheduler: DispatchQueue.main)
             .sink { [weak self] _ in
                 self?.state = .data(String())
                 self?.isAnimating = false
                 self?.timerCancellable?.cancel()
             }
         cancellable.store(in: &cancellables)
     }

     func filterByPrice(products: [StoreMerchandise]) -> [StoreMerchandise] {
         return products.filter { $0.price > "100" }
     }

     func filterByImagePresence(products: [StoreMerchandise]) -> [StoreMerchandise] {
         return products.filter { $0.imageName != nil && !$0.imageName!.isEmpty }
     }
 }

 struct StoreMerchandise: Identifiable, Hashable {
     var id = UUID()
     var imageName: String?
     var name: String
     var price: String
 }
