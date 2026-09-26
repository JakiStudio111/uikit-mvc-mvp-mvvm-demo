import UIKit

/// 组装三个采用不同架构的示例页面。
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    /// 将 MVC、MVP、MVVM 页面放在独立标签中，方便对照。
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            navigationController(
                for: MVCReminderViewController(service: DemoReminderService()),
                title: "MVC",
                symbol: "1.circle"
            ),
            navigationController(
                for: MVPReminderViewController(service: DemoReminderService()),
                title: "MVP",
                symbol: "2.circle"
            ),
            navigationController(
                for: MVVMReminderViewController(service: DemoReminderService()),
                title: "MVVM",
                symbol: "3.circle"
            )
        ]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}

// MARK: - Private

private extension SceneDelegate {
    /// 包装示例页面，统一导航标题和标签样式。
    func navigationController(
        for viewController: UIViewController,
        title: String,
        symbol: String
    ) -> UINavigationController {
        viewController.title = title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: symbol),
            selectedImage: nil
        )
        return navigationController
    }
}
