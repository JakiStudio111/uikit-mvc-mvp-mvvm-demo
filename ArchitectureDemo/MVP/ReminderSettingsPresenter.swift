import Foundation

/// 定义 Presenter 可以要求 View 执行的展示动作。
@MainActor
protocol ReminderSettingsViewing: AnyObject {
    /// 展示当前开关值、提交状态和提示。
    func render(isOn: Bool, isSaving: Bool, message: String)
}

/// MVP 示例：Presenter 持有页面流程和已确认的业务状态。
@MainActor
final class ReminderSettingsPresenter {
    weak var view: ReminderSettingsViewing?

    private let service: ReminderServicing
    private var confirmedIsOn = false

    /// 注入设置服务，不依赖 UIKit 控件。
    init(service: ReminderServicing) {
        self.service = service
    }

    /// 读取初始值并命令 View 显示。
    func load() {
        Task {
            confirmedIsOn = await service.load()
            view?.render(isOn: confirmedIsOn, isSaving: false, message: "当前值已加载")
        }
    }

    /// 接收用户期望的新值，提交失败时命令 View 恢复旧值。
    func didChangeSwitch(to isOn: Bool) {
        view?.render(isOn: isOn, isSaving: true, message: "提交中…")
        Task {
            do {
                try await service.save(isOn)
                confirmedIsOn = isOn
                view?.render(isOn: isOn, isSaving: false, message: "提交成功")
            } catch {
                view?.render(
                    isOn: confirmedIsOn,
                    isSaving: false,
                    message: error.localizedDescription
                )
            }
        }
    }

    /// 命令模拟服务拒绝下一次保存。
    func failNextSave() {
        service.failNextSave()
        view?.render(isOn: confirmedIsOn, isSaving: false, message: "下一次提交将失败")
    }
}
