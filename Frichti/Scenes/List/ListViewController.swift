import UIKit

typealias ListViewInterface = ListViewInputs & ListViewOutputs

protocol ListViewInputs: ViewInputs {
    func updateActivityIndicator(shouldAnimate: Bool)
    func hideTableView(shouldHide: Bool)
    func updateDataSource(dataSource: [Product])

    /// Note: We could also work with a 'state' and handle the whole UI update internally according to the 'state' (more in a reactive way):
    ///
    /// Ex:
    /// typealias DataSouce = [Items]
    ///
    /// enum State {
    ///     case loading
    ///     case loaded(DataSouce)
    /// }
    ///
    /// func updateState(state: State)
}

protocol ListViewOutputs: ViewOutputs {
    var itemSelected: (() -> Void)? { get set }

    /// Note: Navigation related outputs would also appear here, though a separate protocol like 'ListViewNavigationOutputs' could also be considered so the non-navigation related methods don't appear in the routing layer.
    ///
    /// Ex:
    /// var screenDidFinish: (() -> Void)? { get set }
}

final class ListViewController: ViewController, ListViewInterface {
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: Outputs
    internal var itemSelected: (() -> Void)?

    // MARK: Properties
    var dataSource: [Product] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ListCell.self, forCellReuseIdentifier: "ListCell")
    }

    // MARK: Inputs
    /// ActivityIndicator
    internal func updateActivityIndicator(shouldAnimate: Bool) {
        if shouldAnimate {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }
    }

    /// TabkeView
    internal func hideTableView(shouldHide: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = shouldHide ? 0 : 1
        }
    }

    /// DataSource
    internal func updateDataSource(dataSource: [Product]) {
        /// Note: The 'dataSource' should be abstracted. This 'viewController' shouldn't know about 'Product' as it introduces non-necesary coupling. It's only job is to present abstract cells, and only the cell presenter should know about it.
        self.dataSource = dataSource
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") else {
            return UITableViewCell()    /// Didn't handle this case, this would actually crash
        }

        cell.textLabel?.text = dataSource[indexPath.row].title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected?()
    }
}
