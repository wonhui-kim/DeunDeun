//
//  DateUIView.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/31.
//

import UIKit

protocol DateUIViewDelegate: AnyObject {
    func buttonTapped(index: Int)
}

final class DateUIView: UIView {
    
    //weak, AnyObject 사용 이유
    weak var delegate: DateUIViewDelegate?
    
    private let days = ["월", "화", "수", "목", "금"]
    private let startDate = DateManager.shared.startDate()
    private lazy var dates = DateManager.shared.weekDate(startDate: startDate)
    private let todayIndex = DateManager.shared.todayIndex()
    
    //월화수목금 UILabel 생성
    private lazy var dayLabels: [UILabel] = days.map {
        let label = UILabel()
        label.text = $0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    //날짜 버튼 5개 생성
    private lazy var dateButtons: [UIButton] = dates.map {
        let button = UIButton()
        button.setTitle($0, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    //dayStackView, dateStackView
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemBackground
        return stackView
    }
    
    private lazy var dayStackView: UIStackView = createStackView()
    private lazy var dateStackView: UIStackView = createStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
        
        //버튼 태그 설정
        for i in 0..<dateButtons.count {
            dateButtons[i].tag = i
        }
        dateButtons[todayIndex].isSelected = true
        dateButtons[todayIndex].backgroundColor = UIColor(named: "PointColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

//view layout 관련 함수
extension DateUIView {
    
    func configureUI() {
        [dayStackView, dateStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        dayLabels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            dayStackView.addArrangedSubview($0)
        }
        
        dateButtons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            dateStackView.addArrangedSubview($0)
        }
    }

    func setupLayout() {
        let dayStackViewConstraints = [
            dayStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayStackView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let dateStackViewConstraints = [
            dateStackView.topAnchor.constraint(equalTo: dayStackView.bottomAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateStackView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        [dayStackViewConstraints, dateStackViewConstraints].forEach {
            NSLayoutConstraint.activate($0)
        }
    }
    
}

//기타 함수
extension DateUIView {
    //버튼 클릭 시 태그에 따른 식단 호출
    @objc
    func dateButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        delegate?.buttonTapped(index: tag)
        
        //선택된 버튼의 background를 pointcolor로 변경
        //선택된 버튼이 이미 존재하는지 확인
        if let selectedButton = dateButtons.firstIndex(where: { $0.isSelected }) {
            dateButtons[selectedButton].isSelected = false
            dateButtons[selectedButton].backgroundColor = .clear
        }
        
        sender.isSelected = true
        sender.backgroundColor = UIColor(named: "PointColor")
    }
}
