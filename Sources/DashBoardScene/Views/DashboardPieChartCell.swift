//
//  DashboardPieChartCell.swift
//  Pomodoro
//
//  Created by 김하람 on 1/30/24.
//  Copyright © 2024 io.hgu. All rights reserved.
//

import DGCharts
import UIKit

final class DashboardPieChartCell: UICollectionViewCell {
    private var selectedDate: Date = .init()
    private var dayData: [String] = []
    private var priceData: [Double] = [10]
    private let pieBackgroundView = UIView().then { view in
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray3
    }
    private let donutPieChartView = PieChartView().then { chart in
        chart.noDataText = "출력 데이터가 없습니다."
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .black
        chart.holeColor = .systemGray3
        chart.backgroundColor = .systemGray3
        chart.legend.font = .systemFont(ofSize: 15)
        chart.legend.verticalAlignment = .bottom
        chart.legend.neededHeight = 10
        chart.legend.neededWidth = 100
        chart.drawSlicesUnderHoleEnabled = false
        chart.holeRadiusPercent = 0.55
        chart.drawEntryLabelsEnabled = false
        chart.highlightPerTapEnabled = false
        chart.chartDescription.textColor = .red
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(pieBackgroundView)
        pieBackgroundView.addSubview(donutPieChartView)
        backgroundColor = .systemGray3
        layer.cornerRadius = 20
        setupPieChart()
        setPieChartData(for: Date(), dateType: .day)
    }
    private func calculateFocusTimePerTag(for selectedDate: Date) -> [String: Int] {
        let calendar = Calendar.current
        var focusTimePerTag = [String: Int]()
        let filteredSessions = PomodoroData.dummyData.filter { session in
            calendar.isDate(session.participateDate, inSameDayAs: selectedDate)
        }
        for session in filteredSessions {
            focusTimePerTag[session.tagId, default: 0] += session.focusTime
        }
        return focusTimePerTag
    }
    private func setupPieChart() {
        pieBackgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.8)
        }
        donutPieChartView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(1.1)
        }
    }
    private func entryData(values: [Double]) -> [ChartDataEntry] {
        var pieDataEntries: [ChartDataEntry] = []
        for index in 0 ..< values.count {
            let pieDataEntry = ChartDataEntry(x: Double(index), y: values[index])
            pieDataEntries.append(pieDataEntry)
        }
        return pieDataEntries
    }
    private func calculateFocusTimePerTag(from startDate: Date, to endDate: Date) -> [String: Int] {
        var focusTimePerTag = [String: Int]()
        let filteredSessions = PomodoroData.dummyData.filter { session in
            session.participateDate >= startDate && session.participateDate < endDate
        }
        for session in filteredSessions {
            focusTimePerTag[session.tagId, default: 0] += session.focusTime
        }
        return focusTimePerTag
    }
    func setPieChartData(for date: Date, dateType: DashboardDateType) {
        let (startDate, endDate) = getDateRange(for: date, dateType: dateType)
        let focusTimePerTag = calculateFocusTimePerTag(from: startDate, to: endDate)
        let pieChartDataEntries = focusTimePerTag.map {
            PieChartDataEntry(value: Double($0.value), label: $0.key)
        }
        let pieChartDataSet = PieChartDataSet(entries: pieChartDataEntries, label: "").then {
            $0.colors = [.systemTeal, .systemPink, .systemIndigo]
            $0.drawValuesEnabled = false
        }
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        donutPieChartView.data = pieChartData
        let totalFocusTime = focusTimePerTag.reduce(0) { $0 + $1.value }
        updatePieChartText(totalFocusTime: totalFocusTime)
    }
    private func updatePieChartText(totalFocusTime: Int) {
        let days = totalFocusTime / (24 * 60)
        let hours = (totalFocusTime % (24 * 60)) / 60
        let minutes = totalFocusTime % 60
        var totalTimeText = "합계\n"
        if days > 0 {
            totalTimeText += "\(days)일 "
        }
        if hours > 0 || days > 0 {
            totalTimeText += "\(hours)시간 "
        }
        totalTimeText += "\(minutes)분"
        donutPieChartView.centerText = totalTimeText
    }
    private func getDateRange(for date: Date, dateType: DashboardDateType) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        switch dateType {
        case .day:
            let startOfDay = calendar.startOfDay(for: date)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                return (startOfDay, startOfDay)
            }
            return (startOfDay, endOfDay)
        case .week:
            guard let startOfWeek = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)),
                let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)
            else {
                return (date, date)
            }
            return (startOfWeek, endOfWeek)
        case .month:
            guard let monthStartDate = calendar.date(
                from: calendar.dateComponents([.year, .month], from: date)),
                let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: monthStartDate),
                let monthEndDate = calendar.date(byAdding: .day, value: -1, to: nextMonthDate)
            else {
                return (date, date)
            }
            return (monthStartDate, monthEndDate)
        case .year:
            guard let yearStartDate = calendar.date(from: calendar.dateComponents([.year], from: date)),
                  let nextYearDate = calendar.date(byAdding: .year, value: 1, to: yearStartDate),
                  let yearEndDate = calendar.date(byAdding: .day, value: -1, to: nextYearDate)
            else {
                return (date, date)
            }
            return (yearStartDate, yearEndDate)
        }
    }
}

extension DashboardPieChartCell: DashboardTabDelegate {
    func dateArrowButtonDidTap(data date: Date) {
        selectedDate = date
    }
}
