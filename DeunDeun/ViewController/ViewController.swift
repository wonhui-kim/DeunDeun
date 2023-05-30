//
//  ViewController.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let url = "https://www.dongduk.ac.kr/ajax/etc/cafeteria/cafeteria_data.json?"
        let startEndDate = endDate(startDate: startDate())
        
        Task {
            do {
                let weekMenu = try await NetworkManager.shared.requestData(url: url, parameters: startEndDate)
                print(weekMenu)
            } catch let error as NSError {
                print(error)
            }
        }
    }


}

