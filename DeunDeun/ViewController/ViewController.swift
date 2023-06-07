//
//  ViewController.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let dateUIView = DateUIView()
    private let menuTableView = MenuTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupLayout()
        
        view.backgroundColor = .systemBackground
        dateUIView.delegate = self
        
        let url = "https://www.dongduk.ac.kr/ajax/etc/cafeteria/cafeteria_data.json?"
        let startEndDate = DateManager.shared.endDate(startDate: DateManager.shared.startDate())
        
        Task {
            do {
                let result = try await NetworkManager.shared.requestData(url: url, parameters: startEndDate)
                
                //일주일 치 저장
                MenuStorage.shared.saveWeekMenus(menus: result)
                
                let todayIndex = DateManager.shared.todayIndex()
                let staffMenu = MenuStorage.shared.dayStaffMenu(dayIndex: todayIndex)
                let studentMenu = MenuStorage.shared.dayStudentMenu(dayIndex: todayIndex)
                
                menuTableView.reloadTable(staffMenu: staffMenu, studentMenu: studentMenu)
                
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

//view layout 관련 함수
extension ViewController {
    private func configureUI() {
        [dateUIView, menuTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        let dateUIViewConstraints = [
            dateUIView.topAnchor.constraint(equalTo: view.topAnchor),
            dateUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateUIView.heightAnchor.constraint(equalToConstant: view.frame.height * 1/5)
        ]
        
        let menuTableViewConstraints = [
            menuTableView.topAnchor.constraint(equalTo: dateUIView.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        [dateUIViewConstraints, menuTableViewConstraints].forEach {
            NSLayoutConstraint.activate($0)
        }
    }
}

extension ViewController: DateUIViewDelegate {
    func buttonTapped(index: Int) {
        let staffMenu = MenuStorage.shared.dayStaffMenu(dayIndex: index)
        let studentMenu = MenuStorage.shared.dayStudentMenu(dayIndex: index)
        
        menuTableView.reloadTable(staffMenu: staffMenu, studentMenu: studentMenu)
    }
}
