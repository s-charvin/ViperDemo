//
//  AppDelegate.swift
//  ViperDemo
//
//  Created by charvin on 2024/4/12.
//

import UIKit
import Factory

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = UIApplication.shared.delegate as? AppDelegate

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()

        let noteListViewController = Container.shared.viewForNoteList()
        let noteListDataService = Container.shared.noteListDataService()
        NoteListModuleBuilder.injectNoteListDataService(for: noteListViewController, noteListDataService: noteListDataService)

        self.window?.rootViewController = UINavigationController(
            rootViewController: noteListViewController
        )

        return true
    }

}

