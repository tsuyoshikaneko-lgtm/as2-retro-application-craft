# Boon AA Threader Sample

`as2-retro-application-craft` の実装サンプルです。

`⊂二二二（＾ω＾）二⊃` が右から流れてくる弾幕コメントを避ける、スマホ向けの AS2 / Flash 8 ワンボタンゲームです。

```text
⊂二二二（＾ω＾）二⊃
```

操作はシンプルです。

```text
タップ/長押し: 上昇
離す: 落下
弾幕を避ける: スコア加算
波を越える: 少し速度アップ
```

最初は `wktk` や `1ゲト` のような軽いコメントから始まり、反応、盛り上がり、大弾幕へ進みます。大弾幕では当たり判定のない薄いコメントも混ぜ、見た目の派手さとゲームとしての理不尽さを分けています。

## ファイル

```text
spec.md                ゲーム仕様
flash_ide_setup.md     Flash IDE / Animate で再現するための手順
frame_scripts.as       Flash IDE 向け Timeline frame scripts
wrapper.html           self-hosted Ruffle 用 wrapper
wrapper_cdn.html       ローカル確認用 Ruffle CDN wrapper
wrapper_config.js      Ruffle 設定、cache buster、FlashVars 転送
site/                  静的デモサイト用の追加ファイル
mtasc_pipeline.md      MTASC/Ruffle パイプラインの検討メモ
mtasc/                 MTASC 向けソースと Makefile
publish_checklist.md   公開前チェックリスト
OFL.txt                aa-font.swf 配布時に同梱するフォントライセンス
```

## ソースの境界

このサンプルには 2 つの制作レーンがあります。

```text
MTASC レーン:
  mtasc/src/BoonThreader.as
  make swf で boon-threader.swf を生成する
  このリポジトリの標準確認対象

Flash IDE レーン:
  frame_scripts.as
  flash_ide_setup.md に従って Timeline へ貼り込む
  効果音など Library を使う場合の手渡し用
```

通常のプレイ確認は MTASC レーンで生成した SWF を Ruffle で開きます。JavaScript 版の別実装は持ちません。挙動がズレるためです。

## ビルド

リポジトリ直下で実行します。

```sh
make swf
```

生成されるローカルアーティファクト:

```text
samples/boon-aa-threader/boon-threader.swf
samples/boon-aa-threader/aa-font.swf
```

これらの SWF は Git には含めない方針です。必要なときに `make swf` で生成してください。

`aa-font.swf` は Ruffle で日本語 AA を表示するための font source SWF です。`BoonThreader.as` と `frame_scripts.as` に出てくる文字から glyph set を自動生成します。AA や弾幕文言を増やしたら、必ず `make swf` を再実行してください。

## ローカル確認

リポジトリ直下でサーバーを起動します。

```sh
make serve
```

通常確認:

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1
```

大弾幕 fixture:

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1&fixture=burst
```

`?debug=1` を付けると Ruffle のログレベルを上げます。表示崩れ、文字欠け、古い SWF の読み込み、入力バグを確認するときに使います。

## 配布

### 静的サイトデモ

このリポジトリは SWF を Git に含めないため、公開デモには生成済みの静的ファイルを使います。ホスティング先は任意です。ローカルまたは Docker が使える CI で `make dist` し、`dist/` に集めたファイルを静的ホスティングへ配置します。

配布ファイルの最小セット:

```text
dist/boon-aa-threader/index.html
dist/boon-aa-threader/wrapper_config.js
dist/boon-aa-threader/boon-threader.swf
dist/boon-aa-threader/aa-font.swf
dist/boon-aa-threader/OFL.txt
```

`make dist` / `make dist-demo` は `wrapper_cdn.html` を `index.html` として使い、Ruffle を CDN から読み込みます。長期保存やアーカイブ性を重視する場合は、Ruffle web package を同梱して `make dist-selfhosted` を使ってください。

### self-hosted Ruffle

Ruffle を同梱する場合:

```text
samples/boon-aa-threader/ruffle/
```

に Ruffle web package を置き、以下を同じディレクトリ階層で配布します。

```text
wrapper.html
wrapper_config.js
boon-threader.swf
aa-font.swf
OFL.txt
ruffle/
```

Ruffle 側のライセンスファイルも一緒に配布してください。

## Ruffle wrapper の要点

```text
Ruffle config は ruffle.js より前に宣言する
cache buster、fontSources、FlashVars 転送は wrapper_config.js に集約する
wrapper_cdn.html は短期デモ/ローカル確認用
wrapper.html は self-hosted 配布用
Stage は showAll で 390 x 640 を保つ
長押しメニューは contextMenu: rightClickOnly で避ける
日本語 AA glyph は aa-font.swf を fontSources/defaultFonts に指定する
```

サーバー側では次も確認します。

```text
.wasm が application/wasm で配信される
SWF / font SWF / Ruffle が same-origin か CORS 許可されている
Content Security Policy が WebAssembly 実行を止めていない
```

## ライセンス

- サンプルの自作コードとドキュメント: CC0 1.0
- 生成される `aa-font.swf`: Noto Sans CJK JP glyphs under SIL Open Font License
- `aa-font.swf` を配布する場合: `OFL.txt` を必ず同梱
- AA やコメント文言: 2000 年代日本語ネット文化への文化的オマージュ/パロディ。このリポジトリは AA・ミーム・コメント文化そのものをライセンスするものではありません。

詳細はリポジトリ直下の `THIRD-PARTY-NOTICES.md` を見てください。

## 参考にしたOSS/実務

```text
Ruffle: runtime, wrapper config, fontSources, WebAssembly publish checks
MTASC: AS2 code-only compiler lane with class + static main()
swfmill: font-source SWF generation and SWF structure inspection
fluby: reproducible ActionScript project scaffolding precedent
```
