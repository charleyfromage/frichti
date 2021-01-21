typealias ListPresenterInterface = ListPresenterInputs & ListPresenterOutputs

protocol ListPresenterInputs: class {
    func initialise()
    func formatList(list: [Product])
}

protocol ListPresenterOutputs: class {
    var dataSourceChanged: (([Product]) -> Void)? { get set }
}

final class ListPresenter: ListPresenterInterface {
    var dataSourceChanged: (([Product]) -> Void)?

    internal func initialise() {
        /// In case of static data
    }

    internal func formatList(list: [Product]) {
        /// Perform some data formating here

        dataSourceChanged?(list)
    }
}
