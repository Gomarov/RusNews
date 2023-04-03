import Foundation
import PinLayout

class ErrorView: UIView {

    private let errorLabel = UILabel().with {
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configure()
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
        pin.width(size.width)
        layout()
        return CGSize(width: frame.width, height: frame.height)
    }

    private func layout() {
        errorLabel.pin
            .horizontally()
            .top()
            .sizeToFit(.width)
    }

    // MARK: - Public methods
    func setup(with text: String) {
        errorLabel.text = text
        setNeedsLayout()
    }

    // MARK: - Private methods
    private func addSubviews() {
        addSubview(errorLabel)
    }

    private func configure() {
        backgroundColor = Constants.errorColor
    }
}
