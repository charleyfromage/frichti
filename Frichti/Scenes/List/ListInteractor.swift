import Foundation

typealias ListInteractorInterface = ListInteractorInputs & ListInteractorOutputs

protocol ListInteractorInputs: class {
    func initialize()
    func fetchList()
}

protocol ListInteractorOutputs: class {
    var didFetchList: (([Product]) -> Void)? { get set }
    var loadingStateChanged: ((Bool) -> Void)? { get set }
}

final class ListInteractor: ListInteractorInterface {
    internal var didFetchList: (([Product]) -> Void)?
    internal var loadingStateChanged: ((Bool) -> Void)?

    private var isLoading: Bool = false {
        didSet {
            loadingStateChanged?(isLoading)
        }
    }

    internal func initialize() {
        fetchList()
    }

    /// This method could also be used to perform a refresh for instance (that's why we expose it despite 'initialize' already calling it)
    internal func fetchList() {
        isLoading = true

        /// Note: This should obviously be forwarded to a dedicated network layer. For the exercice purposes, I will be implementing it raw in the interactor.
        if let url = URL(string: "https://frichti-mobile.s3-eu-west-1.amazonaws.com/mobile-technical-test.json") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                self?.isLoading = false

                if let data = data {
                    do {
                        let products = try JSONDecoder().decode([Product].self, from: data)

                        self?.didFetchList?(products)
                    } catch {
                        /// Error handling
                    }
                }
            }.resume()
        }
    }
}
