import UIKit

/// MVP 示例：ViewController 只负责组装 View 并转发事件。
final class MVPReminderViewController: UIViewController {
    private let reminderView = ReminderSettingsView()
    private let presenter: ReminderSettingsPresenter

    /// 由 Presenter 持有服务及页面业务状态。
    init(service: ReminderServicing) {
        presenter = ReminderSettingsPresenter(service: service)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 使用共用 View 作为页面根视图。
    override func loadView() {
        view = reminderView
    }

    /// 将界面事件交给 Presenter 处理。
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        reminderView.onToggle = { [weak self] isOn in
            self?.presenter.didChangeSwitch(to: isOn)
        }
        reminderView.onFailNextSave = { [weak self] in
            self?.presenter.failNextSave()
        }
        presenter.load()
    }
}

// MARK: - ReminderSettingsViewing

extension MVPReminderViewController: ReminderSettingsViewing {
    /// 执行 Presenter 发出的展示命令。
    func render(isOn: Bool, isSaving: Bool, message: String) {
        reminderView.render(isOn: isOn, isSaving: isSaving, message: message)
    }
}
