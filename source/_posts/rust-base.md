---
title: rust-base
date: 2020-09-09 23:42:56
tags:
categpries:
---



### 修改镜像源

```
vi $HOME/.cargo/config
```

```
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
```


```
cargo build --examples
error: failed to parse manifest at `E:\workspace\OpenSource\quiche\Cargo.toml`

Caused by:
  editions are unstable

Caused by:
  feature `edition` is required

this Cargo does not support nightly features, but if you
switch to nightly channel you can add
`cargo-features = ["edition"]` to enable this feature
```