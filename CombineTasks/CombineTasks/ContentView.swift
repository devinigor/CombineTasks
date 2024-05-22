//
//  ContentView.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CancellingMultiplePipelinesViewModel()
    var body: some View {
        Group {
            HStack{
                TextField("Name", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.firstNameValidation)
            }
            HStack{
                TextField("SecondName", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.lastNameValidation)
            }
        }
        .padding()
        
        Button("Cancel") {
            viewModel.cancelAllValidations()
        }
    }
}

#Preview {
    ContentView()
}
