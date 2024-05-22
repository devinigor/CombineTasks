//
//  ProductViewModel.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import Combine
import Foundation

struct Product {
    let id = UUID()
    let name: String
    let price: Int
}

final class ProductViewModel: ObservableObject {
    @Published var price = 0
    @Published var products: [Product] = [
        .init(name: "Хлеб", price: 35),
        .init(name: "Масло", price: 190),
        .init(name: "Гречка", price: 98),
        .init(name: "Пряники", price: 150),
        .init(name: "Огурцы", price: 155),
        .init(name: "Молоко", price: 110)
    ]
    
    @Published var cart: [Product] = []
    @Published var lastItem: Product?
    
    var anyCancellable: AnyCancellable?
    
    init() {
        anyCancellable = $lastItem
            .filter { $0?.price ?? 0 < 1000 }
            .sink { [unowned self] product in
                guard let product else { return }
                cart.append(product)
                sumTotal()
            }
    }
    
    func sumTotal() {
        _ = cart.publisher
            .scan(100) { $0 + $1.price }
            .sink { [unowned self] price in
                self.price = price
            }
    }
    
    func addToСart(_ product: Product) {
        lastItem = product
    }

    func removePrice(_ price: Int) {
        self.price -= price
    }
    
    func removeProduct(_ product: Product) {
        if let index = cart.lastIndex(where: { $0.id == product.id }) {
            cart.remove(at: index)
            removePrice(product.price)
        }
    }
}
