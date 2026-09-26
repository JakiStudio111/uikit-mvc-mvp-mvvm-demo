# MVC / MVP / MVVM UIKit 对照 Demo

作者：Jaki

这是《MVC、MVP 与 MVVM，到底把代码放在了哪里？》的配套示例。同一个“开启提醒”页面分别用 MVC、MVP、MVVM 实现，便于对照用户操作、提交状态和失败回滚各由谁处理。

项目只包含一个独立的 Xcode 工程，没有第三方依赖、真实接口或账号配置。三个标签页外观一致，且各自持有独立的内存服务。

## 运行

1. 用 Xcode 打开仓库根目录下的 `ArchitectureDemo.xcodeproj`。
2. 选择 iOS 17 或更新版本的 iPhone 模拟器，运行 `ArchitectureDemo` Scheme。
3. 底部三个标签分别是 MVC、MVP、MVVM；切换标签，重复同一组操作。

模拟器运行不需要网络、账号或代码签名。模拟服务只在当前进程内保存状态，重新启动 App 后会重置；如果要运行在真机上，需要自行配置开发团队和签名。

## 验证场景

在每个标签分别操作：

1. 直接开启开关：显示“提交中…”，约半秒后显示“提交成功”，开关保持开启。
2. 点“下一次提交失败”，然后关闭开关：提交期间控件显示关闭且不可操作；约半秒后显示失败提示，开关恢复开启。
3. 再次关闭开关：这次保存成功，开关保持关闭。

观察代码中“最后确认的值”保存在哪里：MVC 在 ViewController，MVP 在 Presenter，MVVM 在 ViewModel。`ReminderSettingsView` 只负责布局、事件转发与渲染。模拟服务中 `failNextSave()` 是演示开关，不属于真实业务接口。

这个例子特意让 MVC 的页面流程留在 ViewController，以便与另外两种写法对照；它不是推荐把所有业务逻辑都塞进 ViewController。

## 文件对应

- `DemoReminderService.swift`：三个示例使用相同行为的内存服务。
- `ReminderSettingsView.swift`：三个页面共用的 UIKit 控件。
- `MVC/MVCReminderViewController.swift`：ViewController 自己协调流程。
- `MVP/ReminderSettingsPresenter.swift` 与 `MVP/MVPReminderViewController.swift`：Presenter 向被动 View 发展示命令。
- `MVVM/ReminderSettingsViewModel.swift` 与 `MVVM/MVVMReminderViewController.swift`：ViewModel 输出状态，ViewController 订阅并渲染。

## 已验证环境

Xcode 26.6；iPhone 17 Pro（iOS 26.0）模拟器。项目目标最低 iOS 17.0。

## 范围与限制

- 只演示单次提交及失败回滚，不包含网络请求、持久化或生产环境错误处理。
- 未演示页面退出时取消任务、连续请求竞争等情况；三种架构都需要根据真实业务补足这些处理。
- MVC、MVP、MVVM 都有不同变体，这里只对照文中采用的具体写法。

## 许可证

本项目以 [MIT License](LICENSE) 开放，版权归 Jaki 所有。
