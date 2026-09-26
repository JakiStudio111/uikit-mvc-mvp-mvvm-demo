import Foundation

/// 描述页面渲染所需的全部状态。
struct ReminderSettingsState {
    let isOn: Bool
    let isSaving: Bool
    let message: String
}

/// MVVM 示例：ViewModel 处理服务调用并向界面输出页面状态。
@MainActor
final class ReminderSettingsViewModel {
    var onStateChange: ((ReminderSettingsState) -> Void)? {
        didSet { onStateChange?(state) }
    }

    private let service: ReminderServicing
    private var confirmedIsOn = false
    private var state = ReminderSettingsState(isOn: false, isSaving: false, message: "等待加载") {
        didSet { onStateChange?(state) }
    }

    /// 注入设置服务，不依赖 UIKit 控件。
    init(service: ReminderServicing) {
        self.service = service
    }

    /// 读取初始值并输出页面状态。
    func load() {
        Task {
            confirmedIsOn = await service.load()
            state = ReminderSettingsState(
                isOn: confirmedIsOn,
                isSaving: false,
                message: "当前值已加载"
            )
        }
    }

    /// 保存用户期望的新值，失败时输出已确认的旧值。
    func changeSwitch(to isOn: Bool) {
        state = ReminderSettingsState(isOn: isOn, isSaving: true, message: "提交中…")
        Task {
            do {
                try await service.save(isOn)
                confirmedIsOn = isOn
                state = ReminderSettingsState(
                    isOn: isOn,
                    isSaving: false,
                    message: "提交成功"
                )
            } catch {
                state = ReminderSettingsState(
                    isOn: confirmedIsOn,
                    isSaving: false,
                    message: error.localizedDescription
                )
            }
        }
    }

    /// 标记下一次保存失败，并输出提示状态。
    func failNextSave() {
        service.failNextSave()
        state = ReminderSettingsState(
            isOn: confirmedIsOn,
            isSaving: false,
            message: "下一次提交将失败"
        )
    }
}
