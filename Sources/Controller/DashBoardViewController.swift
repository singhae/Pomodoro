//
//  DashBoardViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.

import UIKit
import DGCharts
import Then

final class DashBoardViewController: UIViewController {
    
    var dayData: [String] = [" "]
    var priceData: [Double] = [10]
    
    private let pieBackgroundView  = UIView().then { view in
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray
    }
    private let donutPieChartView = PieChartView().then{ chart in
        chart.noDataText = "출력 데이터가 없습니다."
        chart.centerText = "총합"
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .lightGray
        chart.holeColor = .lightGray
        chart.backgroundColor = .lightGray
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPieView()
        setUpAttributePieChartView()
        ChangePieCenterText()
        setPieData(pieChartView: donutPieChartView , pieChartDataEntries:
                            entryData(values: priceData))
        
    }
    private func setUpAttributePieChartView(){
        donutPieChartView.drawSlicesUnderHoleEnabled = false
        donutPieChartView.holeRadiusPercent = 0.8
        donutPieChartView.drawEntryLabelsEnabled = false
        donutPieChartView.legend.enabled = false
        donutPieChartView.highlightPerTapEnabled = false
    }
    private func ChangePieCenterText(){
        
        let attributeString = NSAttributedString(string: "총합", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
            ])
        
        donutPieChartView.centerAttributedText = attributeString
    }
    private func setupPieView(){
        view.addSubview(pieBackgroundView)
        pieBackgroundView.addSubview(donutPieChartView)
        
        pieBackgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(view.bounds.width * 0.7)
        }
        donutPieChartView.snp.makeConstraints{make in
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
