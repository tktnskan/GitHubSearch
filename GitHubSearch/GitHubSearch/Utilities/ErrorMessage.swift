//
//  ErrorMessage.swift
//  GitHubSearch
//
//  Created by GJC03280 on 2021/10/18.
//

import Foundation

enum ErrorMessage: String {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was Invalid. Please try again"
}
