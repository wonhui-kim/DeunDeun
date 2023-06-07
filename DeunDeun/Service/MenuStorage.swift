//
//  MenuStorage.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/06/07.
//

import Foundation

final class MenuStorage {
    
    static let shared = MenuStorage()
    
    private init() { }
    
    private var staffMenus: [[String]] = Array(repeating: [], count: 5)
    private var studentMenus: [[String]] = Array(repeating: [], count: 5)
    
    func saveWeekMenus(menus: [String]) {
        
        var wholeMenus = [[String]]()
        
        menus.forEach { menu in
            let todayResult = menu.split(separator: "\r\n").map {
                String($0)
            }
            wholeMenus.append(todayResult)
        }
        
        saveStaffMenus(menus: wholeMenus)
        saveStudentMenus(menus: wholeMenus)
    }
    
    func saveStaffMenus(menus: [[String]]) {
        for i in stride(from: 0, to: menus.count, by: 1) {
            if menus[i].isEmpty {
                staffMenus[i] = ["오늘은 운영하지 않아요 🥲"]
            } else {
                var menu = [String]()
                
                for j in stride(from: 1, to: menus[i].count, by: 1) {
                    if menus[i][j].contains("학생") {
                        break
                    }
                    menu.append(menus[i][j])
                }
                
                staffMenus[i] = menu
            }
        }
    }
    
    func saveStudentMenus(menus: [[String]]) {
        for i in stride(from: 0, to: menus.count, by: 1) {
            if menus[i].isEmpty {
                studentMenus[i] = ["오늘은 운영하지 않아요 🥲"]
            } else {
                var menu = [String]()
                
                for j in stride(from: staffMenus[i].count+1, to: menus[i].count, by: 1) {
                    menu.append(menus[i][j])
                }
                studentMenus[i] = menu
            }
        }
    }
    
    func weekStaffMenus() -> [[String]] {
        return staffMenus
    }
    
    func weekStudentMenus() -> [[String]] {
        return studentMenus
    }
    
    func dayStaffMenu(dayIndex: Int) -> [String] {
        return staffMenus[dayIndex]
    }
    
    func dayStudentMenu(dayIndex: Int) -> [String] {
        return studentMenus[dayIndex]
    }
}
