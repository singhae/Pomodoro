//
//  DashBoardViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//
//  Third Party Library Github address: https://github.com/danielepantaleone/DPCharts Release 1.2.2

import UIKit
import DPCharts

final class DashBoardViewController: UIViewController {
    
    private let pieBackgroundView  = UIView().then { view in
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray
    }
    
    private let pieChartView = DPPieChartView().then{ chart in
        chart.donutEnabled = true
        chart.donutTitle = "합 계"
        chart.donutSubtitleColor = .white
        chart.donutWidth = 16.0
        chart.donutTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        chart.donutSubtitleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        chart.donutVerticalSpacing = 4.0
    }
   
    private let label = UILabel().then { label in
        label.text = " "
        label.textColor = .black
    }
    private let segmentedControl = UISegmentedControl().then { Segmented in
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabel()
        addDelegatePieChart()
    }
    private func addDelegatePieChart(){
        pieChartView.datasource = self
    }
    private func inputTotalTime(totla time : Int){
        let textTime = String(time)
        pieChartView.donutSubtitle = textTime
            
    }
    private func setupLabel(){
        view.addSubview(pieBackgroundView)
        pieBackgroundView.addSubview(pieChartView)
        
        pieChartView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(300)
        }
        pieBackgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(324)
            make.height.equalTo(320)
        }
    }
}

extension DashBoardViewController : DPPieChartViewDataSource{
    func pieChartView(_ pieChartView: DPCharts.DPPieChartView, colorForSliceAtIndex index: Int) -> UIColor {
        return UIColor.black
    }
    
    func pieChartView(_ pieChartView: DPCharts.DPPieChartView, valueForSliceAtIndex index: Int) -> CGFloat {
        return 100.0
    }
    func numberOfSlices(_ pieChartView: DPCharts.DPPieChartView) -> Int {
        return 1
    }
    func pieChartView(_ pieChartView: DPPieChartView, labelForSliceAtIndex index: Int, forValue value: CGFloat, withTotal total: CGFloat) -> String? {
        return " "
    }
}
