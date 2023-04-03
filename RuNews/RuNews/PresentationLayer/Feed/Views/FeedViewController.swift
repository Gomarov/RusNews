import PinLayout

protocol FeedViewInput: AnyObject {
    func showErrorView(with title: String)
    func hideErrorView()
    func setupTable(with models: [NewsViewModel])
    func startLoadingAnimation()
    func stopLoadingAnimation()
}
protocol FeedViewOutput {
    func viewDidLoad()
    func didSelectNews(with id: String)
    func showSettingsView()
}

class FeedViewController: UIViewController {
    private let output: FeedViewOutput
    private let errorView = ErrorView()
    private let settingsButton = UIBarButtonItem().with {
        $0.image = UIImage(systemName: "gear")
        $0.style = .plain
        $0.action = #selector(settingsButtonTapped)
        $0.tintColor = Constants.buttonColor
    }
    private var viewModels = [NewsViewModel]()
    private var activityIndicator: UIActivityIndicatorView?
    private lazy var tableView = UITableView().with {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
    }

    init(output: FeedViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func loadView() {
        super.loadView()
        addSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        output.viewDidLoad()
    }

    // MARK: Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator?.pin.center(to: view.anchor.center)
    }

    private func layout() {
        tableView.pin.all()
        errorView.pin
            .horizontally()
            .height(60)
            .bottom()
    }

    // MARK: Private methods
    private func configure() {
        title = "feed".localized
        view.backgroundColor = Constants.backgroundColor
        errorView.isHidden = true
        settingsButton.target = self
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(errorView)
        navigationItem.rightBarButtonItem = settingsButton
        setupActivityIndicator()
    }
    
    final func setupActivityIndicator() {
        guard activityIndicator == nil else {
            return
        }
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        self.activityIndicator = activityIndicator
    }

    final func startLoadingAnimation() {
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
    }

    final func stopLoadingAnimation() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
    }
    
    @objc private func settingsButtonTapped() {
        output.showSettingsView()
    }
}

// MARK: - FeedViewInput
extension FeedViewController: FeedViewInput {

    func showErrorView(with title: String) {
        errorView.setup(with: title)
        errorView.isHidden = false
    }
    
    func hideErrorView() {
        errorView.isHidden = true
    }

    func setupTable(with models: [NewsViewModel]) {
        self.viewModels = models
        tableView.reloadData()
    }

}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(at: indexPath, for: NewsTableCell.self)
        cell.setup(with: viewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModels[indexPath.row].isCollapsed = !viewModels[indexPath.row].isCollapsed
        viewModels[indexPath.row].wasSeen = true
        output.didSelectNews(with: viewModels[indexPath.row].id)
        tableView.reloadData()
    }
}
