//
//  ProductView.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import SwiftUI

struct ProductView: View {
    var body: some View {
          VStack {
              headerView
                  .padding(.bottom, 20)
              headerListsView
                  .padding(.bottom, 10)
              ForEach(viewModel.products, id: \.id) { index in
                  makeProductView(product: index)
              }
              Spacer()
              sumView
              deleteCartView
          }
          .padding()
      }
      
      @StateObject private var viewModel = ProductViewModel()
      
      private var headerView: some View {
          Text("Список товаров")
              .font(.largeTitle)
              .bold()
      }
      
      private var headerListsView: some View {
          HStack {
              Text("Товар")
              Spacer()
              Text("Цена")
          }
          .font(.title)
          .foregroundColor(.gray)
      }
      
      private var sumView: some View {
          HStack {
              Text("Сумма:")
              Spacer()
              Text("\(viewModel.price)")
          }
          .font(.title)
          .foregroundColor(.black)
      }
      
      private var deleteCartView: some View {
          Button {
              for foodstuff in viewModel.cart {
                  viewModel.removeProduct(foodstuff)
              }
          } label: {
              Text("Удалить все товары из чека")
                  .padding()
                  .background(.red)
                  .foregroundColor(.white)
          }
      }

      func makeProductView(product: Product) -> some View {
          
          HStack {
              Text(product.name)
              Button {
                  viewModel.removeProduct(product)
              } label: {
                  Text("-")
                      .padding(.all , 5)
                      .background(.red)
                      .foregroundColor(.white)
                      .clipShape(Circle())
              }
              Button {
                  viewModel.addToСart(product)
              } label: {
                  Text("+")
                      .padding(.all , 5)
                      .background(.green)
                      .foregroundColor(.white)
                      .clipShape(Circle())
              }

              Spacer()
              Text("\(product.price)")
          }
          .font(.body)
          .foregroundColor(viewModel.price < 0 ? .red : .black)
      }

}

#Preview {
    ProductView()
}
