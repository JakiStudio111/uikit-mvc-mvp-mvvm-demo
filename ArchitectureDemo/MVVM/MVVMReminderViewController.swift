import UIKit

/// MVVM 示例：ViewController 将操作输入 ViewModel，并渲染其输出状态。
final class MVVMReminderViewController: UIViewController {
    private let reminderView = ReminderSettingsView()
    private let viewModel: ReminderSettingsViewModel

    /// 由 ViewModel 持有服务及页面业务状态。
    init(service: ReminderServicing) {
        viewModel = ReminderSettingsViewModel(service: service)
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

    /// 将操作传入 ViewModel，并订阅页面状态。
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onStateChange = { [weak self] state in
            self?.reminderView.render(
                isOn: state.isOn,
                isSaving: state.isSaving,
                message: state.message
            )
        }
        reminderView.onToggle = { [weak self] isOn in
            self?.viewModel.changeSwitch(to: isOn)
        }
        reminderView.onFailNextSave = { [weak self] in
            self?.viewModel.failNextSave()
        }
        viewModel.load()
    }
}
