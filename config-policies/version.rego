# すべてのポリシーは org パッケージで定義する
package org

import future.keywords

policy_name["cimg_base_current"]

# 違反時にパイプラインをブロックする（hard_fail）
enable_hard["require_cimg_base_current"]

# cimg/base を使っている場合、タグが current でなければ違反
require_cimg_base_current[image] = reason {
    some image in docker_images
    startswith(image, "cimg/base:")
    image != "cimg/base:current"
    reason := sprintf("%s: cimg/base を使う場合は :current タグを指定してください", [image])
}

# config.yml から全 Docker イメージを抽出するヘルパー
docker_images := {image |
    walk(input, [path, value])
    path[_] == "docker"
    image := value[_].image
}