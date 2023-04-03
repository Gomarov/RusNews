import PinLayout

final class SettingsHeaderView: UIView {

    private let titleLabel = UILabel()

    init(with title: String?) {
        super.init(frame: .zero)
        configure()
        titleLabel.text = title
        addSubview(titleLabel)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)

        return frame.size
    }

    private func layout() {
        titleLabel.pin
            .vCenter()
            .horizontally(Constants.padding)
            .sizeToFit(.width)
    }

    // MARK: - Private methods
    private func configure() {
        backgroundColor = Constants.backgroundColor
    }

}
