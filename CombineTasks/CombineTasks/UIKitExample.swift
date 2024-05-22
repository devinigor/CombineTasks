//
//  UIKitExample.swift
//  CombineTasks
//
//  Created by Игорь Девин on 21.05.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var dataStatus: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel = PiplineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let subscr1 = Subscribers.Assign(object: dataStatus, keyPath: \.text)
        viewModel.$data.subscribe(subscr1)
        
        let subscr2 = Subscribers.Assign(object: statusLabel, keyPath: \.text)
        viewModel.$status.subscribe(subscr2)

    }

    @IBAction func cancel(_ sender: Any) {
        viewModel.cancel()
    }
    
    @IBAction func refresh(_ sender: Any) {
        viewModel.refresh()
    }
}
