//
//  ChatMessage.swift
//  BookList
//
//  Created by KAMIYAMA YOSHIHITO on 2021/03/16.
//

struct ChatMessage: FirebaseModelProtocol {
    var message: String
    
    static let collecitonName = "chatMessages"
}
