import PinLayout
import RxSwift
import UIKit

final class PeriodTableCell: UITableViewCell {
    
    private let valueLabel = UILabel()
    private let slider = UISlider().with {
        $0.minimumValue = 0
        $0.maximumValue = 24
        $0.isContinuous = false
    }
    var reuseBag = DisposeBag()
    var didChangeSliderValue: Observable<Float> {
        slider.rx.value.asObservable()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reuseBag = DisposeBag()
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return contentView.frame.size
    }

    private func layout() {
        valueLabel.pin
            .sizeToFit()
            .topLeft(Constants.padding)

        slider.pin
            .below(of: valueLabel)
            .horizontally(Constants.padding)
            .sizeToFit(.width)

        contentView.pin.height(slider.frame.maxY + Constants.padding)
    }

    // MARK: - Public methods
    func setup(with model: PeriodViewModel) {
        valueLabel.text = model.text
        slider.value = Float(model.currentValue)
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(slider)
        contentView.addSubview(valueLabel)
    }

}
