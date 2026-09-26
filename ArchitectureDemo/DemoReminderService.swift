import Foundation

/// 定义读取和保存提醒设置所需的服务能力。
@MainActor
protocol ReminderServicing: AnyObject {
    /// 返回服务端最后确认的开关状态。
    func load() async -> Bool

    /// 保存期望值；失败时不改变最后确认的状态。
    func save(_ isOn: Bool) async throws

    /// 让下一次保存失败，用于手动验证回滚流程。
    func failNextSave()
}

/// 使用内存模拟服务端，不依赖网络或账号。
@MainActor
final class DemoReminderService: ReminderServicing {
    private var confirmedIsOn = false
    private var shouldFailNextSave = false

    /// 读取当前已确认的值。
    func load() async -> Bool {
        confirmedIsOn
    }

    /// 延迟保存，以便观察提交中和提交失败时的界面变化。
    func save(_ isOn: Bool) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        if shouldFailNextSave {
            shouldFailNextSave = false
            throw DemoReminderError.rejected
        }
        confirmedIsOn = isOn
    }

    /// 标记下一次保存会被模拟服务拒绝。
    func failNextSave() {
        shouldFailNextSave = true
    }
}

/// 表示模拟服务拒绝了一次保存请求。
enum DemoReminderError: LocalizedError {
    case rejected

    var errorDescription: String? {
        "模拟提交失败，已恢复服务器确认的值"
    }
}
