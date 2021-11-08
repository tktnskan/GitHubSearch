//
//  ErrorMessage.swift
//  GitHubSearch
//
//  Created by Jinyung Yoon on 2021/10/18.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "일치하는 회원이 없습니다. 아이디를 확인해주세요."
    case unableToComplete = "인터넷 통신상태를 확인해주세요."
    case invalidResponse = "잠시후 다시 시도해주세요."
    case invalidData = "유저정보가 명확하지 않습니다. 다시 시도해주세요."
    case unableToFavorites = "유저 좋아요 기능에 오류가 있습니다. 다시 시도해주세요."
    case alreadyInFavorites = "이미 좋아요 리스트에 있는 유저입니다."
}
