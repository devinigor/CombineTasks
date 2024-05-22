//
//  ContentView.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PiplineViewModel()
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data ?? "")
                .font(.title)
                .foregroundColor(.green)
            
            Text(viewModel.status ?? "")
                .foregroundColor(.blue)
            
            Spacer()
            Button {
                viewModel.cancel()
            } label: {
                Text("Отменить заказ")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.red)
            .cornerRadius(8)
            .opacity(viewModel.status == "Ищем авто" ? 1.0 : 0.0)
            
            Button {
                viewModel.refresh()
            } label: {
                Text("Заказать")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

