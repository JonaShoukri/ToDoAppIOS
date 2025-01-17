//
//  ToDo.swift
//  FirebaseTodoApp
//
//  Created by Jonas Shoukri on 2025-01-17.
//
import Foundation
import FirebaseFirestore

struct ToDo: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var isCompleted: Bool
}
