import UIKit

/// MVC 示例：由 ViewController 协调服务、页面状态和控件更新。
final class MVCReminderViewController: UIViewController {
    private let service: ReminderServicing
    private let reminderView = ReminderSettingsView()
    private var confirmedIsOn = false

    /// 注入与其他示例行为相同的模拟服务。
    init(service: ReminderServicing) {
        self.service = service
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

    /// 连接交互事件并读取初始状态。
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderView.onToggle = { [weak self] isOn in
            self?.save(isOn)
        }
        reminderView.onFailNextSave = { [weak self] in
            self?.service.failNextSave()
            self?.reminderView.render(
                isOn: self?.confirmedIsOn ?? false,
                isSaving: false,
                message: "下一次提交将失败"
            )
        }
        loadSetting()
    }
}

// MARK: - Network Requests

private extension MVCReminderViewController {
    /// 读取服务端最后确认的开关值。
    func loadSetting() {
        Task {
            confirmedIsOn = await service.load()
            reminderView.render(isOn: confirmedIsOn, isSaving: false, message: "当前值已加载")
        }
    }

    /// 保存用户期望的值，失败时恢复上一次确认的值。
    func save(_ isOn: Bool) {
        reminderView.render(isOn: isOn, isSaving: true, message: "提交中…")
        Task {
            do {
                try await service.save(isOn)
                confirmedIsOn = isOn
                reminderView.render(isOn: isOn, isSaving: false, message: "提交成功")
            } catch {
                reminderView.render(
                    isOn: confirmedIsOn,
                    isSaving: false,
                    message: error.localizedDescription
                )
            }
        }
    }
}
