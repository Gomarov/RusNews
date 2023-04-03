import Foundation
import Kingfisher
import PinLayout

class NewsTableCell: UITableViewCell {

    private let containerView = UIView().with {
        $0.backgroundColor = Constants.backgroundColor
    }
    private let sourceLabel = UILabel().with {
        $0.textColor = Constants.textColor
        $0.font = Constants.textFont
    }
    private let dateLabel = UILabel().with {
        $0.textColor = Constants.textColor
        $0.font = Constants.textFont
    }
    private let titleLabel = UILabel().with {
        $0.numberOfLines = 3
        $0.font = Constants.titleFont
    }
    private let newsImageView = UIImageView().with {
        $0.contentMode = .scaleAspectFit
    }
    private let descriptionLabel = UILabel().with {
        $0.numberOfLines = 0
    }
    private let readMoreButton = UIButton(type: .system).with {
        $0.setTitle("read_more".localized, for: .normal)
    }
    private let infoLabel = UILabel().with {
        $0.numberOfLines = 1
        $0.font = Constants.textFont
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        containerView.pin
            .top(Constants.padding)
            .horizontally(Constants.padding)

        titleLabel.pin
            .topLeft(Constants.padding)
            .right(Constants.padding)
            .sizeToFit(.width)

        newsImageView.pin
            .below(of: titleLabel)
            .marginTop(Constants.padding)
            .horizontally()
            .aspectRatio(1.5)

        descriptionLabel.pin
            .horizontally(Constants.padding)
            .below(of: newsImageView)
            .sizeToFit(.width)
            .marginTop(Constants.padding)
        
        readMoreButton.pin
            .horizontally(Constants.padding)
            .below(of: descriptionLabel)
            .sizeToFit(.width)
            .marginTop(Constants.padding)

        sourceLabel.pin
            .sizeToFit()
            .below(of: visible([readMoreButton, newsImageView]), aligned: .right)
            .marginTop(Constants.padding)
            .marginRight(Constants.padding)

        dateLabel.pin
            .sizeToFit()
            .below(of: visible([readMoreButton, newsImageView]), aligned: .left)
            .marginTop(Constants.padding)
            .marginLeft(Constants.padding)
        
        infoLabel.pin
            .sizeToFit()
            .below(of: dateLabel, aligned: .left)
            .marginTop(Constants.padding)
            .marginRight(Constants.padding)

        containerView.pin
            .height(infoLabel.frame.maxY + Constants.padding)

        contentView.pin.height(containerView.frame.maxY + Constants.padding)
    }

    // MARK: - Public methods
    func setup(with model: NewsViewModel) {
        titleLabel.text = model.title
        sourceLabel.text = model.source
        newsImageView.kf.cancelDownloadTask()
        newsImageView.kf.setImage(with: URL(string: model.imageURL))
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.isCollapsed
        readMoreButton.isHidden = model.isCollapsed
        dateLabel.isHidden = model.date == nil
        dateLabel.text = model.date
        infoLabel.text = model.wasSeen ? "old_news".localized :  "new_news".localized
        infoLabel.textColor = model.wasSeen ? Constants.oldInfoColor :  Constants.newInfoColor
        readMoreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.readMoreButtonTapped(with: model.newsURL)}),
                                 for: .touchUpInside)
        contentView.setNeedsLayout()
    }

    // MARK: - Private methods
    private func addSubviews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(sourceLabel)
        containerView.addSubview(newsImageView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(readMoreButton)
        containerView.addSubview(dateLabel)
        containerView.addSubview(infoLabel)
        contentView.addSubview(containerView)
    }
    
    private func configure() {
        selectionStyle = .none
    }
    
    private func readMoreButtonTapped(with url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
}
