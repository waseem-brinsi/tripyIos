//
//  User.swift
//  Tripy
//
//  
//

import Foundation


struct User:Codable
{
    let _id:String
    let username:String
    let email:String
    let password:String
    let phone:String
    let image:String
    let recettes:[String]?
    let comments:[String]?
    
}
