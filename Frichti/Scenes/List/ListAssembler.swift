import Foundation

final class ListAssembler {
    private var view: ListViewInterface
    private var interactor: ListInteractorInterface
    private var presenter: ListPresenterInterface

    init(_ view: ListViewInterface, _ interactor: ListInteractorInterface, _ presenter: ListPresenterInterface) {
        self.view = view
        self.interactor = interactor
        self.presenter = presenter
    }

    func assemble() {
        /// View outputs
        view.didLoad = { [weak interactor, weak presenter] in
            interactor?.initialize()
            presenter?.initialise()
        }

        /// Note: Navigation redirection would also appear here. For instance, considering a 'Coordinator' pattern and given the fact that the 'coordinator' would also be injected in the function, we would have something like:
        ///
        /// view.itemSelected = coordinatoor.showNextScreen

        /// Interactor outputs
        interactor.didFetchList = presenter.formatList
        interactor.loadingStateChanged = { [weak view] isLoading in
            DispatchQueue.main.async {
                view?.updateActivityIndicator(shouldAnimate: isLoading)
                view?.hideTableView(shouldHide: isLoading)

            }
        }

        /// Presenter outputs
        presenter.dataSourceChanged = { [weak view] dataSource in
            DispatchQueue.main.async {
                view?.updateDataSource(dataSource: dataSource)
            }
        }
    }

    /// A method to release all instances when the scene terminates
    func disassemble() {}
}
