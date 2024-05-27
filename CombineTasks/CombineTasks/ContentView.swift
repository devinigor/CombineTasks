//
//  ContentView.swift
//  CombineTasks
//
//  Created by Игорь Девин on 22.05.2024.
//

import SwiftUI

 struct ProductLoadingView: View {

     var body: some View {
         VStack {
             switch viewModel.state {
             case .loading:
                 timerView
                 if viewModel.isConnecting {
                     loadingProduct
                 } else {
                     VStack {
                         Spacer()
                         buttonStartView
                     }
                 }
             case .data:
                 timerView
                 listView
                 buttonStartView
             case .error(let error):
                 Text(error.localizedDescription)
             }
         }
     }

     @StateObject var viewModel = ProductViewModel()

     private var timerView: some View {
         Text("time left \(viewModel.timerLeft)")
             .font(.title)
     }

     private var listView: some View {
         let filteredProducts = viewModel.filterByPrice(products: viewModel.dataToProducts)
         let finalProducts = viewModel.filterByImagePresence(products: filteredProducts)

         return List(finalProducts, id: \.self) { item in
             HStack {
                 Image(systemName: item.imageName ?? "")
                 Text(item.name)
                 Text("\(item.price) руб")
             }
         }
     }

     private var buttonStartView: some View {
         Button(action: {
             withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(13, autoreverses: true)) {
                 viewModel.start()
                 viewModel.performAnimation()
             }
         }, label: {
             Text("Start")
                 .font(.body)
                 .padding()
                 .foregroundColor(.white)
                 .background(RoundedRectangle(cornerRadius: 100).fill(.blue))
                 .cornerRadius(8)
                 .scaleEffect(viewModel.isAnimating ? 0.9 : 1)
         })
     }

     private var loadingProduct: some View {
         VStack {
             if viewModel.isLoadingProduct {
                 Text("Loading items...")
                     .font(.body)
                     .foregroundColor(.black)
             }
         }
     }
 }

 #Preview {
     ProductLoadingView()
 }

