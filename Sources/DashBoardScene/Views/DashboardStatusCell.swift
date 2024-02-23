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
    private var selectedDate: Date = .init()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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

    private func getStartAndEndDate(for date: Date, of component: Calendar.Component)
        -> (start: Date, end: Date)
    {
        let calendar = Calendar.current
        guard let dateInterval = calendar.dateInterval(of: component, for: date) else {
            return (date, date)
        }
        let startDate = dateInterval.start
        let endDate = dateInterval.end
        return (startDate, endDate)
    }

    func updateUI(for date: Date, dateType: DashboardDateType) {
        let component: Calendar.Component = {
            switch dateType {
            case .day:
                return .day
            case .week:
                return .weekOfYear
            case .month:
                return .month
            case .year:
                return .year
            }
        }()

        let (startDate, endDate) = getStartAndEndDate(for: date, of: component)
        let filteredData = PomodoroData.dummyData.filter { $0.participateDate >= startDate &&
            $0.participateDate < endDate
        }
        let participateDates = Set(filteredData.map { Calendar.current.startOfDay(for: $0.participateDate) })
        let totalParticipateCount = participateDates.count
        let filteredDataCount = filteredData.count
        let totalSuccessCount = filteredData.filter(\.success).count
        let totalFailureCount = filteredData.filter { !$0.success }.count

        participateLabel.text = "참여일 \(totalParticipateCount)"
        countLabel.text = "횟수 \(filteredDataCount)"
        achieveLabel.text = "달성 \(totalSuccessCount)"
        failLabel.text = "실패 \(totalFailureCount)"
    }

    func getDateRange(for date: Date, dateType: DashboardDateType) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        switch dateType {
        case .day:
            return (date, calendar.date(byAdding: .day, value: 1, to: date)!)
        case .week:
            let startOfWeek = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
            return (startOfWeek, endOfWeek)
        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return (startOfMonth, endOfMonth)
        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: date))!
            let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
            return (startOfYear, endOfYear)
        }
    }
}

// MARK: - DayViewControllerDelegate

extension DashboardStatusCell: DashboardTabDelegate {
    func dateArrowButtonDidTap(data date: Date) {
        selectedDate = date
    }
}
