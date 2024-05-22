//
//  CancellingMultiplePipelinesViewModel.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import Foundation
import Combine

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancellables: Set<AnyCancellable> = []
    init() {
       $firstName
            .map{$0.isEmpty ? "❌" : "✅"}
            .sink{ [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $lastName
             .map{$0.isEmpty ? "❌" : "✅"}
             .sink{ [unowned self] value in
                 self.lastNameValidation = value
             }
             .store(in: &validationCancellables)
    }
    
    func cancelAllValidations() {
        firstName = ""
        lastName = ""
        validationCancellables.removeAll()
    }
}
