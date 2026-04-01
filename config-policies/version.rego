# すべてのポリシーは org パッケージで定義する
package org

policy_name["example"]

# check_version ルールを有効化し、違反時にビルドを停止（hard_fail）する
enable_hard["check_version"]

# version チェックの定義
check_version = reason {
    not input.version
    reason := "version must be defined"
} {
    not is_number(input.version)
    reason := "version must be a number"
} {
    not input.version >= 2.1
    reason := sprintf("version must be at least 2.1 but got %v", [input.version])
}