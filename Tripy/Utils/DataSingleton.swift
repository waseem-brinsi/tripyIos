//
//  DataSingleton.swift
//  Tripy
//
//

import Foundation


// this class is used instead of segue to pass data throuuuuuu
class DataSignleton {
    static let shared = DataSignleton()
    // here is the data that you want to pass
    var email: String?
    var token: String?
}
