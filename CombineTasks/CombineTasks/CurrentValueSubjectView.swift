//
//  CurrentValueSubjectView.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import SwiftUI

struct CurrenValueSubjectView: View {
    @StateObject var viewModel = CurrentValueSubjectViewModel()
    
    var body: some View {
        VStack {
            TextField("Введите число от 1 до 100", text: Binding(get: {
                "\(viewModel.selection.value)"
            }, set: { value in
                viewModel.selection.value = Int(value) ?? 0
            }))
            .padding()
            Button {
                
                viewModel.cancel()
            } label: {
                Text("Завершить игру")
            }
            
            Text("\(viewModel.selectionNumber.value)")
                .opacity(viewModel.isShowNumber ? 1 : 0)
            Text("\(viewModel.message.value)")
                .padding()
        }
    }
    
}
#Preview {
    CurrenValueSubjectView()
}
