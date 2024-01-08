//
//  MonthViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.

import UIKit
import DGCharts
import Then
import SnapKit

final class MonthViewController: UIViewController {
    
    var dayData: [String] = [" "]
    var priceData: [Double] = [10]
    
    private let pieBackgroundView  = UIView().then { view in
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray3
    }
    
    private let donutPieChartView = PieChartView().then{ chart in
        chart.noDataText = "출력 데이터가 없습니다."
        chart.centerText = "총합"
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .black
        chart.holeColor = .systemGray3
        chart.backgroundColor = .systemGray3
        chart.drawSlicesUnderHoleEnabled = false
        chart.holeRadiusPercent = 0.8
        chart.drawEntryLabelsEnabled = false
        chart.legend.enabled = false
        chart.highlightPerTapEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPieView()
        ChangePieCenterText()
        setPieData(pieChartView: donutPieChartView , pieChartDataEntries:
                    entryData(values: priceData))
        
    }
    
    private func ChangePieCenterText() {
        
        let attributeString = NSAttributedString(string: "총합", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
                                                                           ])
        
        donutPieChartView.centerAttributedText = attributeString
    }
    private func setupPieView() {
        view.addSubview(pieBackgroundView)
        pieBackgroundView.addSubview(donutPieChartView)
        
        pieBackgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(view.bounds.width * 0.7)
        }
        donutPieChartView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(view.bounds.width * 0.65)
        }
    }
    
    func entryData(values: [Double]) -> [ChartDataEntry] {
        
        var pieDataEntries: [ChartDataEntry] = []
        for i in 0 ..< values.count {
            let pieDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            pieDataEntries.append(pieDataEntry)
        }
        return pieDataEntries
    }
    
    func setPieData(pieChartView: PieChartView, pieChartDataEntries: [ChartDataEntry]) {
        let pieChartdataSet = PieChartDataSet(entries: pieChartDataEntries, label: "")
        pieChartdataSet.colors = [UIColor.black]
        pieChartdataSet.drawValuesEnabled = false
        
        let pieChartData = PieChartData(dataSet: pieChartdataSet)
        pieChartView.data = pieChartData
    }
    
}
