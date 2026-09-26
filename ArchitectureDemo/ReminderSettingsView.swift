import UIKit

/// 只负责显示状态和转发操作，不决定开关的业务值。
final class ReminderSettingsView: UIView {
    var onToggle: ((Bool) -> Void)?
    var onFailNextSave: (() -> Void)?

    private let toggle = UISwitch()
    private let statusLabel = UILabel()
    private let failButton = UIButton(type: .system)

    /// 创建三个示例页共用的控件布局。
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 将外部决定的状态显示到控件上。
    func render(isOn: Bool, isSaving: Bool, message: String) {
        toggle.setOn(isOn, animated: true)
        toggle.isEnabled = !isSaving
        statusLabel.text = message
    }
}

// MARK: - UI Updates

private extension ReminderSettingsView {
    /// 创建说明、开关、失败按钮和状态文本。
    func configureUI() {
        backgroundColor = .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = "开启提醒"
        titleLabel.font = .preferredFont(forTextStyle: .title2)

        let switchRow = UIStackView(arrangedSubviews: [titleLabel, toggle])
        switchRow.axis = .horizontal
        switchRow.alignment = .center
        switchRow.distribution = .equalSpacing

        let hintLabel = UILabel()
        hintLabel.text = "先点“下一次提交失败”，再切换开关，观察状态如何恢复。"
        hintLabel.font = .preferredFont(forTextStyle: .subheadline)
        hintLabel.textColor = .secondaryLabel
        hintLabel.numberOfLines = 0

        failButton.setTitle("下一次提交失败", for: .normal)
        failButton.contentHorizontalAlignment = .leading

        statusLabel.font = .preferredFont(forTextStyle: .body)
        statusLabel.numberOfLines = 0
        statusLabel.accessibilityIdentifier = "reminderStatus"
        toggle.accessibilityIdentifier = "reminderSwitch"
        failButton.accessibilityIdentifier = "failNextSaveButton"

        let stack = UIStackView(arrangedSubviews: [switchRow, hintLabel, failButton, statusLabel])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])

        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        failButton.addTarget(self, action: #selector(failButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Logic

private extension ReminderSettingsView {
    /// 转发用户期望的新值，不在 View 中调用服务。
    @objc func toggleChanged(_ sender: UISwitch) {
        onToggle?(sender.isOn)
    }

    /// 转发模拟失败按钮的点击。
    @objc func failButtonTapped() {
        onFailNextSave?()
    }
}
