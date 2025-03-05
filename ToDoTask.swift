//
//  ToDoTask.swift
//  TaskApp1
//
//  Created by m4nn on 28/02/2025.
//

import Foundation

public struct ToDoTask: Identifiable, Codable {
    public let id: Int
    public let title: String
    public var completed: Bool

    public init(id: Int, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}
