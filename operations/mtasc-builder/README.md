# MTASC Builder

ルートの `make swf` で使う、隔離された MTASC ビルド環境です。

古い Flash 系ツールをホスト Mac に直接入れないために、Linux amd64 の container image を作り、その中に Debian snapshot から historical `mtasc` / `swfmill` package を SHA256 固定で入れます。

## 使い方

リポジトリ直下で実行します。

```sh
make swf
```

内部では container image を build し、リポジトリを `/work` に mount して次を実行します。

```sh
make -C samples/boon-aa-threader -f mtasc/Makefile
```

生成されるローカルアーティファクト:

```text
samples/boon-aa-threader/boon-threader.swf
samples/boon-aa-threader/aa-font.swf
```

これらの `.swf` は Git に含めません。必要なときに生成し、ローカル確認またはデモサイト配布に使います。

## 必要なもの

どちらか一つ:

```text
Docker Desktop
Podman
```

image は `linux/amd64` 固定です。pinned Debian snapshot package が `mtasc_1.14-3_amd64.deb` だからです。Apple Silicon では Docker Desktop の emulation で動かす想定です。

## Pinned MTASC Package

```text
URL: https://snapshot.debian.org/archive/debian/20130611T160143Z/pool/main/m/mtasc/mtasc_1.14-3_amd64.deb
SHA256: 86210e92dd51790c910b36d52f5075e35624833963a91f82deb9d83d3be4d782
```

含まれるもの:

```text
/usr/bin/mtasc
/usr/share/mtasc/std
/usr/share/mtasc/std8
```

## Pinned swfmill Package

```text
URL: https://snapshot.debian.org/archive/debian/20190807T225524Z/pool/main/s/swfmill/swfmill_0.3.6-1%2Bb1_amd64.deb
SHA256: f42afba04e89158ed1a81e4234374bf4444abc8c40013cac20b8a25a571ca46e
```

`swfmill` は、Ruffle 用の font source SWF を Noto Sans CJK JP から生成するために使います。これにより、ブラウザ側の環境フォントに依存せず、日本語 AA を SWF プレイヤー内で表示しやすくします。

## Pinned Base Image

```text
debian:bookworm-slim@sha256:96e378d7e6531ac9a15ad505478fcc2e69f371b10f5cdf87857c4b8188404716
```

base layer は digest 固定です。ただし `apt-get install` は current bookworm packages を取得するため、base image、SHA256 固定の mtasc/swfmill/font までは再現性がありますが、apt update まで含めた bit-for-bit reproducible build ではありません。

## Pinned Font Source

```text
URL: https://raw.githubusercontent.com/notofonts/noto-cjk/165c01b46ea533872e002e0785ff17e44f6d97d8/Sans/OTF/Japanese/NotoSansCJKjp-Regular.otf
SHA256: 68a3fc98800b2a27b371f2fb79991daf3633bd89309d4ffaa6946fd587f375b5
License: SIL Open Font License
Full text: samples/boon-aa-threader/OFL.txt
Copyright: Copyright 2014-2021 Adobe (http://www.adobe.com/). Noto is a trademark of Google Inc.
```

`main` branch ではなく immutable commit に固定しています。upstream の default branch が動いても SHA256 check が壊れないようにするためです。

## なぜこの形にするか

MTASC は古いツールです。現在の Homebrew には通常の `mtasc` formula がなく、現行 Debian/Ubuntu package index でも扱いが安定しません。

Debian snapshot から SHA256 固定で取得し、container の中に閉じ込めることで、ホスト環境を汚さず、あとからビルド経路を検証できるようにしています。
