import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    /// Note: This assembler should be held in the routing layer on the same level as the related factory.
    var listAssembler: ListAssembler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        /// Note: That's where the routing layer would be started instead of hard setting the 'rootViewController'. For instance, using the 'Coordinators' pattern:
        /// let appCoordinator = AppCoordinator(...)
        /// appCoordinator.start()

        /// Note: The following should actually be embeded in a 'factory' and called in the routing layer.
        ///
        /// Ex:
        /// let scene = someFactory.makeListScene()
        /// window?.rootViewController = UINavigationController(rootViewController: scene.viewController)
        /// ...

        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        if let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController {
            let listInteractor = ListInteractor()
            let listPresenter = ListPresenter()

            listAssembler = ListAssembler(listViewController, listInteractor, listPresenter)
            listAssembler?.assemble()

            window?.rootViewController = UINavigationController(rootViewController: listViewController)
            window?.makeKeyAndVisible()
        }

        return true
    }
}
