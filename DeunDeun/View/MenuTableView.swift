//
//  MenuView.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/30.
//

import UIKit

class MenuTableView: UIView {
    
    private var staffMeal = [String]()
    private var studentMeal = [String]()

    private lazy var mealTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPink
        
        configureUI()
        setupLayout()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

//tableView 관련 함수
extension MenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}

//layout 관련 함수
extension MenuTableView {
    private func configureUI() {
        mealTable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mealTable)
    }
    
    private func setupLayout() {
        let mealTableConstraints = [
            mealTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            mealTable.topAnchor.constraint(equalTo: topAnchor),
            mealTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(mealTableConstraints)
    }
    
    private func setupTableView() {
        mealTable.dataSource = self
    }
}
