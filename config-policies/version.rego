# すべてのポリシーは org パッケージで定義する
package org

import future.keywords

policy_name["cimg_current"]

# soft_fail: 違反してもパイプラインは止めず、ログに記録するだけ
enable_rule["require_cimg_current"]
soft_fail["require_cimg_current"]

# cimg/* イメージは :current、またはタグに lts を含むものを許可（例: cimg/node:current, cimg/node:lts, cimg/node:20.10-lts）
cimg_tag_allowed(image) {
    endswith(image, ":current")
}

cimg_tag_allowed(image) {
    parts := split(image, ":")
    count(parts) > 1
    tag := parts[count(parts) - 1]
    contains(tag, "lts")
}

require_cimg_current[image] = reason {
    some image in docker_images
    startswith(image, "cimg/")
    not cimg_tag_allowed(image)
    reason := sprintf("%s: CircleCI cimg イメージは :current または lts を含むタグを指定してください", [image])
}

# config.yml から全 Docker イメージを抽出するヘルパー
docker_images := {image |
    walk(input, [path, value])
    path[_] == "docker"
    image := value[_].image
}