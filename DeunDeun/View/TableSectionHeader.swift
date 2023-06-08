//
//  TableSectionHeader.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/12.
//

import UIKit

final class TableSectionHeader: UITableViewHeaderFooterView {
    
    private let restaurants = ["교직원 식당", "학생 식당"]
    private let hours = ["(11:30 - 13:00)", "(11:00 - 14:00)"]
    
    private let restaurantName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let operatingHours: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TableSectionHeader {
    func configureSectionHeader(with type: Int) {
        restaurantName.text = restaurants[type]
        operatingHours.text = hours[type]
    }
    
    private func configureSubviews() {
        [restaurantName, operatingHours].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let restaurantNameConstraints = [
            restaurantName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            restaurantName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        let operatingHoursConstraints = [
            operatingHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            operatingHours.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        [restaurantNameConstraints, operatingHoursConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
    }
}
