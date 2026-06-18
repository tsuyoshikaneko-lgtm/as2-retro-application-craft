# AS2 Retro Application Craft

AI と一緒に **ActionScript 2.0 / Flash 8 / SWF 風アプリ**を作るための Codex / Claude Code 対応 skill pack です。

単体のゲームサンプルではありません。レトロな AS2 アプリを設計する skill、SWF 化して Ruffle で検証する skill、実際に動く参照サンプルをひとつのリポジトリにまとめています。

## Pack Contents

```text
creative/as2-retro-application-craft/
  レトロAS2アプリを設計・実装・レビューするための skill

operations/as2-swf-debug-pipeline/
  MTASCビルド、Ruffle公開、フォントSWF、デバッグのための companion skill

samples/boon-aa-threader/
  skill pack の参照実装。AS2/MTASC/Ruffleで実際に動くAA弾幕ゲーム
```

補助ツール:

```text
operations/mtasc-builder/
  古いMTASC/swfmillをホスト環境へ直接入れずに使うための隔離ビルド環境
```

エージェント連携:

```text
AGENTS.md
  Codex / Claude Code 共通の作業ルール

CLAUDE.md
  Claude Code 用の project memory。AGENTS.md を import します

.claude/skills/
  Claude Code project skills。canonical skill への symlink

.agents/skills/
  Codex repo-local compatibility skills。canonical skill への symlink

creative/*/agents/openai.yaml
operations/*/agents/openai.yaml
  Codex skill ごとの UI metadata / invocation policy（Claude は無視）
```

## Demo

https://as2-retro-boon-threader.pages.dev/

サンプルは `⊂二二二（＾ω＾）二⊃` が弾幕コメントを避ける、スマホ向けのワンボタン AS2/SWF ゲームです。

## Install As Local Skills

このリポジトリを clone したあと、必要に応じて skill ディレクトリを各エージェントの user skill ディレクトリにコピーまたは symlink してください。

Codex（user-global。リポジトリ内で作業するだけなら `.agents/skills/` の repo-local symlink も同梱しています）:

```sh
mkdir -p ~/.codex/skills
ln -s "$PWD/creative/as2-retro-application-craft" ~/.codex/skills/as2-retro-application-craft
ln -s "$PWD/operations/as2-swf-debug-pipeline" ~/.codex/skills/as2-swf-debug-pipeline
```

Codex の user skill パスは `$CODEX_HOME/skills`、`CODEX_HOME` 未設定時は `~/.codex/skills` です。このリポジトリには repo-local 互換用に `.agents/skills/` も置いていますが、user-global install の説明では `~/.codex/skills` を使います。

Claude Code:

```sh
mkdir -p ~/.claude/skills
ln -s "$PWD/creative/as2-retro-application-craft" ~/.claude/skills/as2-retro-application-craft
ln -s "$PWD/operations/as2-swf-debug-pipeline" ~/.claude/skills/as2-swf-debug-pipeline
```

このリポジトリ内で作業する場合は user-global install は不要です。Claude Code は `.claude/skills/`、Codex 互換の repo-local 探索には `.agents/skills/` の symlink を用意しています（どちらも canonical な `creative/` `operations/` を指します）。

すでに同名 skill がある場合は、既存のディレクトリを確認してから置き換えてください。

## Use The Right Skill

制作・設計には `as2-retro-application-craft` を使います。

```text
AS2らしい小さなアプリを考える
Flash IDE / Timeline / Library / linkage ID を整理する
スマホ操作へ翻訳する
AS2コードやRuffle wrapperをレビューする
```

ビルド・公開・デバッグには `as2-swf-debug-pipeline` を使います。

```text
MTASCでSWF化する
Ruffleで再生できない原因を切り分ける
日本語AA用のfont-source SWFを扱う
生成SWF、wrapper、cache、Ruffleのどこで壊れているか確認する
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

大弾幕 fixture:

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1&fixture=burst
```

`make swf` は Docker または Podman を使います。古い MTASC/swfmill をホスト環境へ直接入れません。

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
CONTRIBUTING.md                   Issue/PR向けの最低限の案内
LICENSE                           自作部分のライセンス
THIRD-PARTY-NOTICES.md            フォント、Ruffle、MTASC、AA/ミーム表現の扱い
Makefile                          sample build / dist / local server

creative/as2-retro-application-craft/
operations/as2-swf-debug-pipeline/
operations/mtasc-builder/
samples/boon-aa-threader/
```

## License

- 自作のコード、ドキュメント、skill定義、テンプレート、プロンプト: CC0 1.0 Universal
- 生成される `aa-font.swf`: Noto Sans CJK JP glyphs under SIL Open Font License
- Ruffle / MTASC / swfmill: 各 upstream project/package のライセンス
- AA・ミーム・コメント文化: このリポジトリは権利を主張せず、文化的オマージュとして最小限に扱います。

詳細は `THIRD-PARTY-NOTICES.md` を参照してください。
