//
//  BoardViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/25.
//

import UIKit
import Charts
import Alamofire

class BoardViewController: UIViewController {
    
    var lineChart = LineChartView()
    var weight:[WeightData] = []
    var days: [String] = []
    var kg: [Double] = []
    var searchData = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentDate() //현재날짜
        if let nickName = NICK_NAME{
            navigationItem.title = "\(nickName)의 성장곡선"
        }
        
        getWeight(pet: PET_ID, actDate: searchData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentDate() //현재날짜
        
        getWeight(pet: PET_ID, actDate: searchData)
    }
    
    func chartData() {
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height / 1.4)
        lineChart.center = view.center
        view.addSubview(lineChart)
   //     var minLineDataEntries = [ChartDataEntry]()
        var maxLineDataEntries = [ChartDataEntry]()

        for i in 0..<days.count {
   //         let minLineDataEntry = ChartDataEntry(x: Double(i), y: Double(minPattern[i])!)
            let maxLineDataEntry = ChartDataEntry(x: Double(i), y: Double(kg[i]))

 //           minLineDataEntries.append(minLineDataEntry)
            maxLineDataEntries.append(maxLineDataEntry)
        }

//        let minset = LineChartDataSet(entries: minLineDataEntries, label: "최소값(min)")
        let maxset = LineChartDataSet(entries: maxLineDataEntries, label: "최대값(max)")
        
//        minset.colors = [.red]
        maxset.colors = [.blue]
        
        let data = LineChartData(dataSets: [maxset])
        lineChart.data = data
        
        //x축 레이블
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        lineChart.xAxis.setLabelCount(days.count, force: true)
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 11)
        
        // 오른쪽 레이블 제거
        lineChart.rightAxis.enabled = false
        
        // 선택 안되게
 //       minset.highlightEnabled = false
        maxset.highlightEnabled = false
            
        // 줌 안되게
        lineChart.doubleTapToZoomEnabled = false
        
        //원 색, 크기
 //       minset.circleRadius = 3.0
        maxset.circleRadius = 3.0
//        minset.circleHoleRadius = 3.0
        maxset.circleHoleRadius = 3.0
  //      minset.circleColors = [.gray]
        maxset.circleColors = [.gray]
        maxset.drawValuesEnabled = false  //그래프 값 표시안하게
        maxset.lineWidth = 3.0 //그래프 선두께
        
        //lineChart.xAxis.enabled = false //x축 눈금선 없애기

    }

    func getWeight(pet:Int, actDate:String){
        //let str = "http://127.0.0.1:8000/api/pet/weightChart?"
        let str = SITE_URL + "/api/pet/weightChart?"
        let params:Parameters = ["pet_id":pet,
                                 "act_date":actDate]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let alamo = AF.request(str, method: .get, parameters: params, headers: headers)

        print(alamo)
        //alamo.responseDecodable(of:Pets.self) { response in  //데이터 한건 받을때
        alamo.responseDecodable(of: [WeightData].self) { response in
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                if let result = response.value {
                    print(result)
                    self.weight = result
                    //pet_id = 1, act_date = '2023-10-15' 데이터로 테스트
                    if self.weight.count >= 1{
                        self.days = [String](repeating: "", count: self.weight.count)
                        self.kg = [Double](repeating: 0.0, count: self.weight.count)
                        
                        for i in 0..<self.weight.count {
                            var splitData = self.weight[i].actDate.split(separator: "-", maxSplits: 1)
                            let monthDay = splitData[1]
                            self.days[i] = String(monthDay) //월-일
                            self.kg[i] = self.weight[i].weight
                        }
                        self.chartData()
                        
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func getCurrentDate(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd" //데이터 포멧 설정
        searchData = formatter.string(from: Date()) //문자열로 바꾸기

    }
}


