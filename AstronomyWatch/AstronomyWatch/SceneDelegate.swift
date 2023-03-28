//
//  SceneDelegate.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 25/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        NetworkMonitor.shared.startMonitoring()
        
        let navigationController = getNavigationController()
        self.appCoordinator = AppCoordinator(navigationController: navigationController)
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        
        self.appCoordinator?.start()
        
        self.window?.makeKeyAndVisible()
        self.handleUITesting()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func getNavigationController() -> UINavigationController {
        var navController = UINavigationController()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navController.navigationBar.standardAppearance = navBarAppearance
        navController.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        return navController
    }

    func handleUITesting() {
        guard ProcessInfo.processInfo.arguments.contains("Testing") else { return }
        let shouldCache = ProcessInfo.processInfo.arguments.contains("Cached")
        if shouldCache {
            let model = PictureOfDayModel(date: "2023-03-27",
                                          title: "Outbound Comet ZTF",
                                          explanation: "About Comet ZTF",
                                          url: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"),
                                          hdUrl: URL(string: "https://apod.nasa.gov/apod/image/2303/C2022E3_230321_1024.jpg"))
            UserDefaults.standard.pictureOfDayModel = model
            try? self.copyBundledImageToDocumentDirectory()
        } else {
            UserDefaults.standard.pictureOfDayModel = nil
        }
    }
    
    func copyBundledImageToDocumentDirectory() throws {
        if let target = Bundle.main.url(forResource: "C2022E3_230321_1024", withExtension: "jpg") {
            if let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = target.lastPathComponent
                let destination = documentDir.appendingPathComponent(fileName)
                
                try FileManager.default.copyItem(at: target, to: destination)
            }
        }
    }
}

