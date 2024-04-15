//
//  NoteListRouter.swift
//  ViperDemo
//
//  Created by charvin on 2024/4/14.
//

import Foundation
import UIKit

protocol NoteListRouter: ViperRouter {
    func viewForLogin(withMessage message: String, delegate: LoginViewDelegate) -> UIViewController
    func viewForCreatingNote(withDelegate delegate: EditorDelegate) -> UIViewController
    func viewForEditingNote(withUUID uuid: String, title: String, content: String, delegate: EditorDelegate) -> UIViewController
}
