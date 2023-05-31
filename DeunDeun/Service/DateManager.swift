//
//  DateManager.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/27.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    private init() { }
    
    //토요일날짜를 넣으면 다음 금요일 날짜와 함께 반환 (startdate와 enddate 반환)
    func endDate(startDate: String) -> [String:String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let parameter = startDate.split(separator: ".").map {
            Int(String($0))
        }
        
        let dateComponents = DateComponents(year: parameter[0], month: parameter[1], day: parameter[2])
        let startDate = Calendar.current.date(from: dateComponents)!
        let startDateString = dateFormatter.string(from: startDate)
        
        let add6Days = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        let endDateString = dateFormatter.string(from: add6Days)
        
        //["STARTDATE": "20230527", "ENDDATE": "20230602"]
        return ["STARTDATE":startDateString, "ENDDATE":endDateString]
    }
    
    //오늘이 토요일이면 -> 토요일날짜, 오늘이 평일이면 -> 지난 토요일 날짜
    func startDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy.MM.dd E"
        
        let today = Date()
        
        //날짜를 "yyyy.MM.dd E" 형식으로 변경
        let dateString = dateFormatter.string(from: today).split(separator: " ").map {
            String($0)
        }
//        print(dateString) //["2023.05.31", "수"]
        
        if dateString[1] == "토" {
            return dateString[0]
        } else {
            for i in stride(from: -1, through: -6, by: -1) {
                let subDays = Calendar.current.date(byAdding: .day, value: i, to: today)!
                let tempDate = dateFormatter.string(from: subDays).split(separator: " ").map {
                    String($0)
                }
                
                if tempDate[1] == "토" {
                    return tempDate[0]
                }
            }
        }
        
        return "no result"
    }
    
    //월,화,수,목,금 날짜(뒷자리)만 반환 -> 캐러셀 용도
    func weekDate(startDate: String) -> [String] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" //뒤에 날짜만 필요함
        
        //2023.05.27(startDate) 를 2023 05 27로 분리
        let parameter = startDate.split(separator: ".").map {
            Int(String($0))
        }
        //시작일(날짜)를 Date 타입으로 변환
        let dateComponents = DateComponents(year: parameter[0], month: parameter[1], day: parameter[2])
        let startDate = Calendar.current.date(from: dateComponents)!
        
        var dateList = [String]()
        for i in stride(from: 2, through: 6, by: 1) { //월(+2)~금(+6)
            let addDay = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
            dateList.append(dateFormatter.string(from: addDay))
        }
        
        return dateList
    }
}
