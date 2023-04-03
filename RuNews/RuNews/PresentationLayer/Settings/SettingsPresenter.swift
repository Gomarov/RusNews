import Foundation

final class SettingsPresenter {

    weak var view: SettingsViewInput?
    private let interactor: SettingsInteractorInput

    init(interactor: SettingsInteractorInput) {
        self.interactor = interactor
    }

    private func makeSectionModels() -> [SettingsSectionModel] {
        return [makeSourcesModel(), makeIntervalModel()]
    }

    private func makeSourcesModel() -> SettingsSectionModel {
        let usedSources = interactor.getSources()
        return SettingsSectionModel(type: .source,
                                    header: "sources".localized,
                                    models: Source.allCases.map { SourceViewModel(with: $0, isSelected: usedSources.contains($0)) })
    }

    private func makeIntervalModel() -> SettingsSectionModel {
        return SettingsSectionModel(type: .period,
                                    header: "update_period".localized,
                                    models: [PeriodViewModel(with: interactor.getPeriod())])
    }
}

// MARK: - SettingsViewOutput
extension SettingsPresenter: SettingsViewOutput {

    func didChangeSlider(_ value: Float) {
        interactor.updatePeriod(with: Int(value))
        view?.setupTableView(with: makeSectionModels())
    }

    func didSelect(_ source: Source) {
        interactor.update(source)
    }

    func viewDidLoad() {
        view?.setupTableView(with: makeSectionModels())
    }
}

// MARK: - SettingsInteractorOutput
extension SettingsPresenter: SettingsInteractorOutput {}
