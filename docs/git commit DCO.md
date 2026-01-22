1. 归功/审核类（最常见，用于记录谁参与了审核、测试等）

Reviewed-by: Name <email>
表示某人审核过代码并认可。
Acked-by: Name <email>
表示某人认可（Acked，通常是高层维护者）。
Tested-by: Name <email>
表示某人测试过这个补丁。
Reported-by: Name <email>
表示谁报告了 bug。
Suggested-by: Name <email>
表示谁提出了建议或想法。
Co-authored-by: Name <email>
表示多人合著（GitHub 会自动识别为共同作者）。

2. 修复/关联类

Fixes: CVE-XXXX-XXXX 或 Fixes: #issue-number
表示这个 commit 修复了某个 CVE 或 issue（你之前的 Golang 示例就用了多个 Fixes:）。
Closes: #issue-number
表示关闭某个 issue。
References: 或 Link:
链接到相关 issue、PR 或外部页面（你示例中的 Link:）。

3. 其他常见标签

Cc: Name <email>
抄送给某些人（让它们收到通知）。
Change-Id: Ixxxxxxxxx
Gerrit 代码审查系统专用的 ID。
Bug: #xxxx 或 Tracked-On:
某些项目（如 Chromium）用来自定义追踪。
Release-note:
Golang 等项目用来说明发布说明。

如何自动/方便添加这些？

大多数可以用 git commit -s 只自动加 Signed-off-by。
其他标签通常手动添加，或用模板预填（参考之前我给你说的 commit template）。
有些项目有严格规范：查看仓库的 CONTRIBUTING.md 或 Documentation/submitting-patches.rst（Kernel 风格）就能看到具体要求。