//
//  Cursor.swift
//  FinalProject
//
//  Created by Антон Сафронов on 16.07.2021.
//

import Foundation

class Cursor {
    private var page: Int = 0
    
    func nextPage() -> String {
        page += 1
        return String(page)
    }
    
    func zeroPage() {
        page = 0
    }
}

