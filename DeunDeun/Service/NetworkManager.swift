//
//  NetworkManager.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/26.
//

import Foundation

enum FetchError: Error {
    case invalidURL
    case invalidID
    case invalidData
    case invalidStatusCode
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
//    func requestData(url: String, parameters: [String:String]) async throws -> [String] {
//
//        guard let url = URL(string: url) else {
//            throw FetchError.invalidURL
//        }
//
//        let formDataString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let requestBody = formDataString.data(using: .utf8)
//        request.httpBody = requestBody
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            throw FetchError.invalidStatusCode
//        }
//
//        guard let response = try? JSONDecoder().decode(CafeteriaResponse.self, from: data) else {
//            throw FetchError.invalidData
//        }
//
//        var results = [String]()
//
//        response.cafeteriaList.forEach { menu in
//            if (31...35).contains(menu.type) {
//                guard let eachMenu = menu.content else {
//                    results.append("오늘은 운영하지 않아요 🥲")
//                    return
//                }
//                results.append(eachMenu)
//            }
//        }
//
//        return results
//    }
    
    //오늘의 식단 데이터
    func requestTodayData(url: String, parameters: [String:String]) async throws -> [String] {
        
        guard let url = URL(string: url) else {
            throw FetchError.invalidURL
        }
        
        let formDataString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = formDataString.data(using: .utf8)
        request.httpBody = requestBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.invalidStatusCode
        }
        
        guard let response = try? JSONDecoder().decode(CafeteriaResponse.self, from: data) else {
            throw FetchError.invalidData
        }
        
        var results = [String]()
        
        response.cafeteriaList.forEach { menu in
            if (31...35).contains(menu.type) {
                guard let eachMenu = menu.content else {
                    results.append("오늘은 운영하지 않아요 🥲")
                    return
                }
                results.append(eachMenu)
            }
        }
        
        let todayIndex = DateManager.shared.todayIndex()
        
        let todayResult = results[todayIndex].split(separator: "\r\n").map {
            String($0)
        }
        
        return todayResult
    }
    
    //[String] -> [String] (교직원 메뉴)
    func requestStaffMeal(wholeMenu: [String]) -> [String] {
        //["소고기콩나물밥", "소고기콩나물밥*부추양념장", "유부장국", "미트볼찹스테이크", "감자채햄볶음", "무말랭이무침", "그린샐러드*드레싱", "포기김치", "학생A", "기본라면", "토핑라면(떡,계란,치즈,만두 중 택1)", "학생B ", "돈육김치찌개(천원의아침)", "학생C", "치킨마요덮밥"]
        
        var menu = [String]()
        
        for eachMenu in wholeMenu {
            if eachMenu.contains("학생") {
                break
            }
            menu.append(eachMenu)
        }
        
        return menu
    }
    
    //[String] -> [String] (학생 메뉴)
    func requestStudentMeal(wholeMenu: [String], startIndex: Int) -> [String] {
        //["소고기콩나물밥", "소고기콩나물밥*부추양념장", "유부장국", "미트볼찹스테이크", "감자채햄볶음", "무말랭이무침", "그린샐러드*드레싱", "포기김치", "학생A", "기본라면", "토핑라면(떡,계란,치즈,만두 중 택1)", "학생B ", "돈육김치찌개(천원의아침)", "학생C", "치킨마요덮밥"]
        
        //교직원 메뉴 다음 인덱스부터 시작 -> 교직원 메뉴 arr count 값부터 시작.
        var menu = [String]()
        
        for i in stride(from: startIndex, to: wholeMenu.count, by: 1) {
            menu.append(wholeMenu[i])
        }
        
        return menu
    }
}
