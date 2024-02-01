//
//  DashboardStatusCell.swift
//  Pomodoro
//
//  Created by 김하람 on 1/30/24.
//  Copyright © 2024 io.hgu. All rights reserved.
//

import DGCharts
import SnapKit
import Then
import UIKit

final class DashboardStatusCell: UICollectionViewCell {
    private let participateLabel = UILabel()
    private let countLabel = UILabel()
    private let achieveLabel = UILabel()
    private let failLabel = UILabel()
    private var selectedDate: Date = Date()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("이 생성자를 사용하려면 스토리보드를 구현해주세요.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupLabel(_ label: UILabel, topOffset: CGFloat, centerXOffset: CGFloat) {
        label.textColor = .white
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview().offset(centerXOffset)
        }
    }
    
    private func setupDivider(isHorizontal: Bool, length: CGFloat, offset: CGFloat) {
        let divider = UIView()
        divider.backgroundColor = .white
        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            if isHorizontal {
                make.width.equalTo(length)
                make.height.equalTo(1)
            } else {
                make.width.equalTo(1)
                make.height.equalTo(length)
            }
            make.top.equalToSuperview().offset(offset)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupUI() {
        setupLabel(participateLabel, topOffset: 70, centerXOffset: -100)
        setupLabel(countLabel, topOffset: 70, centerXOffset: 50)
        setupLabel(achieveLabel, topOffset: 160, centerXOffset: -100)
        setupLabel(failLabel, topOffset: 160, centerXOffset: 50)
        setupDivider(isHorizontal: true, length: 325, offset: 130)
        setupDivider(isHorizontal: false, length: 155, offset: 50)
        layer.cornerRadius = 20
        backgroundColor = .black
    }
    
    private func getStartAndEndDateOfWeek(for date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return (date, date)
        }
        let startDate = weekInterval.start
        let endDate = weekInterval.end
        return (startDate, endDate)
    }
    
    func updateUI(for date: Date, isWeek: Bool = false) {
        var totalParticipateCount: Int = 0
        var filteredDataCount: Int = 0
        var totalSuccessCount: Int = 0
        var totalFailureCount: Int = 0
        let calendar = Calendar.current
        
        if isWeek {
            let weekDates = getStartAndEndDateOfWeek(for: date)
            let startDate = weekDates.start
            let endDate = weekDates.end
            let weekData = PomodoroData.dummyData.filter { $0.participateDate >= startDate && $0.participateDate < endDate }
            let calculateParticipateCount = Set(PomodoroData.dummyData.filter { $0.participateDate >= startDate && $0.participateDate < endDate }.map { calendar.startOfDay(for: $0.participateDate) })
            
            totalParticipateCount = calculateParticipateCount.count
            filteredDataCount = weekData.count
            totalSuccessCount = weekData.filter { $0.success }.count
            totalFailureCount = weekData.filter { !$0.success }.count
        } else {
            totalParticipateCount = PomodoroData.dummyData.filter { $0.participateDate <= date }.count
            let sameDayData = PomodoroData.dummyData.filter { Calendar.current.isDate($0.participateDate, inSameDayAs: date) }
            filteredDataCount = sameDayData.count
            totalSuccessCount = sameDayData.filter { $0.success }.count
            totalFailureCount = sameDayData.filter { !$0.success }.count
        }
        
        participateLabel.text = "참여일 \(totalParticipateCount)"
        countLabel.text = "횟수 \(filteredDataCount)"
        achieveLabel.text = "달성 \(totalSuccessCount)"
        failLabel.text = "실패 \(totalFailureCount)"
    }
}

// MARK: - DayViewControllerDelegate

extension DashboardStatusCell: TabViewControllerDelegate {
    
    func dateArrowButtonDidTap(data date: Date) {
        selectedDate = date
    }
}
