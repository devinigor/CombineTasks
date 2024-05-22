//
//  UIKitExample.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var viewModel = ContentViewModelUiKit()
    let label = UILabel()
    let textField = UITextField()
    var aneCancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        label.frame = CGRect(x: 250, y: 100, width: 100, height: 50)
        textField.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        textField.placeholder = "Введите ваше имя"
        view.addSubview(label)
        view.addSubview(textField)
        
        textField.delegate = self
        
      aneCancellable = viewModel.$validation
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: label)
    }


}


final class ContentViewModelUiKit: ObservableObject {
    @Published var name = ""
    @Published var validation: String? = ""
    
    init() {
        $name
            .map { $0.isEmpty ? "🚫" : "✅" }
            .assign(to: &$validation)

    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.name = string
        return true
    }
}
