# すべてのポリシーは org パッケージで定義する
package org

import future.keywords

policy_name["cimg_current"]

# soft_fail: 違反してもパイプラインは止めず、ログに記録するだけ
enable_rule["require_cimg_current"]
soft_fail["require_cimg_current"]

# cimg/* イメージは :current タグのみ許可（例: cimg/node:current, cimg/base:current）
require_cimg_current[image] = reason {
    some image in docker_images
    startswith(image, "cimg/")
    not endswith(image, ":current")
    reason := sprintf("%s: CircleCI cimg イメージは :current タグを指定してください", [image])
}

# config.yml から全 Docker イメージを抽出するヘルパー
docker_images := {image |
    walk(input, [path, value])
    path[_] == "docker"
    image := value[_].image
}