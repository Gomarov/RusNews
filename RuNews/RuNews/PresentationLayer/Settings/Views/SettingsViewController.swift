import RxSwift
import UIKit

protocol SettingsViewInput: AnyObject {
    func setupTableView(with models: [SettingsSectionModel])
}
protocol SettingsViewOutput {
    func viewDidLoad()
    func didSelect(_ source: Source)
    func didChangeSlider(_ value: Float)
}

class SettingsViewController: UIViewController {
    
    private let output: SettingsViewOutput
    private let closeButton = UIButton(type: .system).with {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = Constants.buttonColor
    }
    private var models = [SettingsSectionModel]()
    private lazy var tableView = UITableView().with {
        $0.delegate = self
        $0.dataSource = self
        $0.tableFooterView = UIView()
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .singleLine
        $0.rowHeight = UITableView.automaticDimension
    }

    init(output: SettingsViewOutput) {
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

    private func layout() {
        tableView.pin.all()
    }

    // MARK: Private methods
    private func configure() {
        title = "settings".localized
        view.backgroundColor = Constants.backgroundColor
        closeButton.addTarget(self, action: #selector(closeSettingsView), for: .touchUpInside)
    }

    private func addSubviews() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc func closeSettingsView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SettingsViewInput
extension SettingsViewController: SettingsViewInput {
    
    func setupTableView(with models: [SettingsSectionModel]) {
        self.models = models
        tableView.reloadData()
    }
}

// MARK: - UITableView
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = models[section].header
        return SettingsHeaderView(with: model)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section]
        switch model.type {
        case .source:
            let cell = tableView.cell(at: indexPath, for: UITableViewCell.self)
            if let cellModel = model.models[indexPath.row] as? SourceViewModel {
                cell.textLabel?.text = cellModel.title
                cell.accessoryType = cellModel.isSelected ? .checkmark : .none
                cell.tintColor = Constants.buttonColor
            }
            return cell
        case .period:
            let cell = tableView.cell(at: indexPath, for: PeriodTableCell.self)
            cell.didChangeSliderValue
                .skip(1)
                .subscribe(onNext: { [unowned self] in
                self.output.didChangeSlider($0)
            }).disposed(by: cell.reuseBag)
            if let cellModel = model.models[indexPath.row] as? PeriodViewModel {
                cell.setup(with: cellModel)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.section]
        switch model.type {
        case .source:
            if let viewModel = (model.models[indexPath.row] as? SourceViewModel) {
                viewModel.isSelected = !viewModel.isSelected
                output.didSelect(viewModel.source)
            }
            tableView.reloadData()
        case .period:
            break
        }
    }
}
