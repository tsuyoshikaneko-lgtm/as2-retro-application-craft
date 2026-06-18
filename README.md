# AS2 Retro Application Craft

AI と一緒に **ActionScript 2.0 / Flash 8 / SWF 風アプリ**を作るための、Codex / Claude Code 対応 skill pack（スキルパック）です。

単体のゲームサンプルではありません。レトロな AS2 アプリを設計する skill、SWF 化して Ruffle で検証する companion skill、実際に動く参照サンプルを、ひとつのリポジトリにまとめています。

## Pack Contents

```text
creative/as2-retro-application-craft/
  レトロな AS2 アプリを設計・実装・レビューするための skill

operations/as2-swf-debug-pipeline/
  MTASC ビルド、Ruffle 公開、フォント SWF、デバッグのための companion skill

samples/boon-aa-threader/
  skill pack の参照実装として用意した、AS2 / MTASC / Ruffle で実際に動く AA 弾幕ゲーム
```

補助ツール:

```text
operations/mtasc-builder/
  古い MTASC / swfmill をホスト環境に直接入れずに使うための隔離ビルド環境
```

エージェント連携:

```text
AGENTS.md
  Codex / Claude Code 共通の作業ルール

CLAUDE.md
  Claude Code 用の project memory。AGENTS.md を読み込みます

.claude/skills/
  Claude Code project skills。canonical な skill ディレクトリへの symlink

.agents/skills/
  Codex repo-local compatibility shim。canonical な skill ディレクトリへの symlink

creative/*/agents/openai.yaml
operations/*/agents/openai.yaml
  Codex skill ごとの UI metadata / invocation policy（Claude は無視）
```

## Demo

https://as2-retro-boon-threader.pages.dev/

サンプルは `⊂二二二（＾ω＾）二⊃` が弾幕コメントを避ける、スマホ向けのワンボタン AS2/SWF ゲームです。

## Install As Local Skills

このリポジトリを clone したあと、必要に応じて canonical skill ディレクトリを各エージェントの user skill ディレクトリにコピーまたは symlink してください。

Codex（推奨: user-global install）:

```sh
mkdir -p ~/.codex/skills
ln -s "$PWD/creative/as2-retro-application-craft" ~/.codex/skills/as2-retro-application-craft
ln -s "$PWD/operations/as2-swf-debug-pipeline" ~/.codex/skills/as2-swf-debug-pipeline
```

Codex の user skill パスは `$CODEX_HOME/skills`、`CODEX_HOME` 未設定時は `~/.codex/skills` です。このリポジトリには repo-local 互換用に `.agents/skills/` も置いていますが、Codex の実行環境やバージョンによって自動探索されない場合があります。確実に使うには、user-global install を推奨します。

Claude Code:

```sh
mkdir -p ~/.claude/skills
ln -s "$PWD/creative/as2-retro-application-craft" ~/.claude/skills/as2-retro-application-craft
ln -s "$PWD/operations/as2-swf-debug-pipeline" ~/.claude/skills/as2-swf-debug-pipeline
```

このリポジトリ内で作業する場合、Claude Code は `.claude/skills/` の project skills を参照できます。Codex 向けには `.agents/skills/` の repo-local compatibility shim も用意しています（どちらも canonical な `creative/` `operations/` を指します）。

symlink が使えない環境や checkout 設定では、上記の `ln -s` の代わりに `creative/as2-retro-application-craft/` と `operations/as2-swf-debug-pipeline/` を user skill ディレクトリへコピーしてください。

すでに同名 skill がある場合は、既存のディレクトリを確認してから置き換えてください。

## Use The Right Skill

制作・設計には `as2-retro-application-craft` を使います。

```text
AS2 らしい小さなアプリを考える
Flash IDE / Timeline / Library / linkage ID を整理する
Flash 時代の操作感をスマホ向けに翻訳する
AS2 コードや Ruffle wrapper をレビューする
```

ビルド・公開・デバッグには `as2-swf-debug-pipeline` を使います。

```text
MTASC で SWF 化する
Ruffle で再生できない原因を切り分ける
日本語 AA を表示するための font-source SWF を扱う
生成された SWF、wrapper、cache、Ruffle のどこで壊れているかを切り分ける
```

## Run The Sample

リポジトリ直下で実行します。

```sh
make swf
make serve
```

ローカル確認:

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1
```

大弾幕 fixture（検証用）:

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1&fixture=burst
```

`make swf` は Docker または Podman を使います。古い MTASC / swfmill をホスト環境に直接入れません。

Podman を明示したい場合:

```sh
RUNTIME=podman make swf
```

## Distribution Shape

生成された SWF は Git に含めません。

```text
samples/boon-aa-threader/boon-threader.swf
samples/boon-aa-threader/aa-font.swf
dist/
```

デモ公開用の静的ファイルは `make dist` で生成します。

```sh
make dist
```

生成先:

```text
dist/boon-aa-threader/
```

`aa-font.swf` は Noto Sans CJK JP の glyph outline を含むため、配布するときは `samples/boon-aa-threader/OFL.txt` を一緒に置いてください。

## Repository Map

```text
AGENTS.md                         AIエージェント向け作業指示
CLAUDE.md                         Claude Code向けproject memory
CODE_OF_CONDUCT.md                参加時の最低限の行動規範
CONTRIBUTING.md                   Issue/PR向けの最低限の案内
LICENSE                           自作部分のライセンス
THIRD-PARTY-NOTICES.md            フォント、Ruffle、MTASC、AA/ミーム表現の扱い
Makefile                          sample build / dist / local server

creative/as2-retro-application-craft/
operations/as2-swf-debug-pipeline/
operations/mtasc-builder/
samples/boon-aa-threader/
```

## Questions / Support

不具合、再生できない環境、skill の使い方に関する提案があれば、GitHub Issues に書いてください。Ruffle / MTASC / フォント表示の問題では、OS、ブラウザ、wrapper URL、実行したコマンド、見えている画面、ブラウザコンソールのエラーを添えると切り分けやすくなります。

## License

- 自作部分（コード、ドキュメント、skill 定義、テンプレート、プロンプト）: CC0 1.0 Universal
- 生成される `aa-font.swf`: Noto Sans CJK JP の glyph outline を含み、SIL Open Font License の対象です
- Ruffle / MTASC / swfmill: 各 upstream project / package のライセンスに従います
- AA・ミーム・コメント文化: このリポジトリは文化そのものをライセンスせず、サンプル内で文化的オマージュ/パロディとして最小限に扱います。

詳細は `THIRD-PARTY-NOTICES.md` を参照してください。
