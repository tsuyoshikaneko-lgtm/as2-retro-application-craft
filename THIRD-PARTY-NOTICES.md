# 第三者素材・ライセンス通知

## プロジェクトライセンスの範囲

このリポジトリで新規に作成したコード、ドキュメント、スキル定義、テンプレート、プロンプトは **CC0 1.0 Universal** として公開します。詳細は `LICENSE` を参照してください。

ただし、CC0 が適用されるのはこのリポジトリで新規に作成した部分だけです。第三者素材、外部ツール、フォント、ネット文化由来の AA/ミーム表現そのものには適用されません。

## 生成・配布時に含まれる可能性がある素材

### Noto Sans CJK JP

`samples/boon-aa-threader/aa-font.swf` は、Ruffle で日本語 AA を表示するために `swfmill` で生成する font source SWF です。

このリポジトリでは SWF を原則として Git に含めません。ただし、`make swf` や CI によって `aa-font.swf` を生成し、デモサイトや配布物に含める場合、その SWF には Noto Sans CJK JP の glyph outline が含まれます。そのため、フォントライセンスを配布物に同梱する必要があります。

```text
Font:      Noto Sans CJK JP (NotoSansCJKjp-Regular.otf)
Copyright: Copyright 2014-2021 Adobe (http://www.adobe.com/).
           Noto is a trademark of Google Inc.
License:   SIL Open Font License, Version 1.1
Full text: samples/boon-aa-threader/OFL.txt
Source:    notofonts/noto-cjk
           Sans/OTF/Japanese/NotoSansCJKjp-Regular.otf
SHA256:    68a3fc98800b2a27b371f2fb79991daf3633bd89309d4ffaa6946fd587f375b5
```

`aa-font.swf` を配布する場合は、必ず `OFL.txt` を一緒に配布してください。フォントまたはフォントから派生したファイルを単体販売しないこと、OFL の条件を維持することにも注意してください。

## 使用する外部ツール

以下のツールはビルド時または実行時に使用します。バイナリはこのリポジトリに vendoring しません。それぞれの upstream ライセンスに従います。

```text
Ruffle
  Flash runtime.
  ローカル確認では CDN から読み込み、長期配布では self-hosted web package を使う想定。
  Licensed by the Ruffle project under MIT OR Apache-2.0.
  https://ruffle.rs

MTASC
  ActionScript 2.0 compiler.
  Debian snapshot archive から SHA256 固定で isolated Docker builder に取得。
  このリポジトリでは再配布しない。

swfmill
  SWF/font-source generator and inspector.
  Debian snapshot archive から SHA256 固定で isolated Docker builder に取得。
  このリポジトリでは再配布しない。
```

Ruffle web package を `samples/boon-aa-threader/ruffle/` などに同梱して配布する場合は、Ruffle 自身のライセンスファイルも一緒に入れてください。

## AA・ミーム表現について

`samples/boon-aa-threader/` には、2000 年代の日本語掲示板・動画コメント文化へのオマージュとして、AA風の表現や短いコメント文言が含まれます。

```text
- このリポジトリは AA・ミーム・コメント文化そのものをライセンスするものではありません。
- サンプル内では文化的オマージュ/パロディとして最小限に使用しています。
- 特定のサービス、プラットフォーム、権利者と提携・協賛・承認関係にあるものではありません。
- 問題のある要素があれば、具体的な指摘に基づいて削除または差し替えます。
```
