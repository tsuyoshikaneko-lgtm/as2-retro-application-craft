# コントリビューションガイド

このリポジトリは、Flash / ActionScript 2.0 時代の制作感を AI で再現するための実験テンプレートです。

Flash IDE の完全再現、すべての Ruffle 互換性、すべての環境での再生を保証するものではありません。改善提案は歓迎しますが、変更は「レトロな手触り」「AS2/SWFとしての実体」「再現可能なビルド/デバッグ」を壊さない範囲で扱います。

参加時の基本的な振る舞いは `CODE_OF_CONDUCT.md` を参照してください。

## Issue に含めてほしい情報

不具合報告では、できる範囲で以下を書いてください。

```text
OS / ブラウザ
Ruffle wrapper の URL
実行したコマンド
見えている画面の状態
browser console のエラー
期待した挙動
実際の挙動
再現手順
```

Ruffle 表示の問題では、特に次を分けて書いてください。

```text
SWF が生成されない
SWF はあるが wrapper で読めない
文字や AA が欠ける
入力が効かない
キャッシュで古い表示が残る
```

## PR の方針

- 生成された `.swf` はコミットしないでください。
- Ruffle web package も通常はコミットしません。配布サイト側のアーティファクトとして扱います。
- AS2 の挙動を変える場合は、`samples/boon-aa-threader/mtasc/src/BoonThreader.as` と `samples/boon-aa-threader/frame_scripts.as` の意図的な差分を説明してください。
- 弾幕文言、AA、日本語文字を増やした場合は、`make swf` で `aa-font.swf` まで再生成できることを確認してください。
- 公開手順やデバッグ知見を変える場合は、`operations/` 側の文書も更新してください。
- レトロ表現の思想や作り方を変える場合は、`creative/` 側の文書も更新してください。

## 最低限の確認

```sh
make swf
git diff --check
```

その後、ローカルサーバーで Ruffle wrapper を開きます。

```sh
make serve
```

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1&fixture=burst
```

最低限、次を確認してください。

```text
SWF が表示される
⊂二二二（＾ω＾）二⊃ が見える
入力で上下移動する
弾幕が右から流れる
大弾幕 fixture が崩れない
GAME OVER -> RETRY が動く
```

## ライセンスと表現

このリポジトリで新規に作成したコード・文書は CC0 1.0 です。ただし、このリポジトリは AA・ミーム・コメント文化そのものをライセンスするものではありません。

`aa-font.swf` を配布する場合は、Noto Sans CJK JP の SIL Open Font License に従い、`samples/boon-aa-threader/OFL.txt` を必ず同梱してください。
