# LibreCrawl

SEO分析とウェブサイト監査のための、ウェブベースのマルチテナントクローラーです。

🌐 **ウェブサイト**: [librecrawl.com](https://librecrawl.com)

**ライブデモを試す:** [https://librecrawl.com/app/](https://librecrawl.com/app/)

**API ドキュメント:** [https://librecrawl.com/api/docs/](https://librecrawl.com/api/docs/)

**プラグインワークショップ** [https://librecrawl.com/workshop/](https://librecrawl.com/workshop/)

LibreCrawl は***常に***無料かつオープンソースです。Screaming Frog、deepcrawl、sitebulb などの有料ライセンス（年間 $259 など）の代わりとしてお使いの場合は、[コーヒーをおごってください](https://www.paypal.com/donate/?business=7H9HFA3385JS8&no_recurring=0&item_name=Continue+the+development+of+LibreCrawl&currency_code=AUD)。

## できること

LibreCrawl はウェブサイトをクロールし、ページ・リンク・SEO要素・パフォーマンスに関する詳細な情報を提供します。Python Flask で構築されたウェブアプリケーションで、複数ユーザーの同時利用に対応したモダンなウェブインターフェースを備えています。

## 主な機能

- 🚀 **マルチテナント** - 複数ユーザーが隔離されたセッションで同時にクロール可能
- 🎨 **カスタム CSS** - 独自の CSS テーマで UI をカスタマイズ
- 💾 **ブラウザ localStorage での永続化** - 設定はブラウザごとに保存
- 🔄 **JavaScript レンダリング** - React、Vue、Angular などの動的コンテンツに対応
- 📊 **SEO 分析** - タイトル、メタディスクリプション、見出しなどを抽出
- 🔗 **リンク分析** - 内部・外部リンクを詳細な関係マップで追跡
- 📈 **PageSpeed Insights 連携** - Core Web Vitals を分析
- 💾 **複数エクスポート形式** - CSV、JSON、XML
- 🔍 **問題検出** - SEO 問題の自動検出
- ⚡ **リアルタイムクロール進捗**とライブ統計
- 🌐 **多言語対応 (i18n)** - 日本語・英語の切り替え（Flask-Babel）

## はじめに

### クイックスタート（自動インストール）

**最も簡単な起動方法** — 起動スクリプトを実行するだけで、必要な処理はすべて自動で行われます。

**Windows:**
```batch
start-librecrawl.bat
```

**Linux / Mac:**
```bash
chmod +x start-librecrawl.sh
./start-librecrawl.sh
```

**自動で行われること:**
1. Docker の有無を確認 — あればコンテナで LibreCrawl を起動（推奨）
2. Docker がなければ Python を確認 — なければダウンロード・インストール（Windows のみ。*一部 bat の問題のため一時無効*）
3. 依存関係を自動インストール（`pip install -r requirements.txt`）
4. JavaScript レンダリング用に Playwright のブラウザをインストール
5. ローカルモード（認証なし）で LibreCrawl を起動
6. ブラウザで `http://localhost:5000` を開く

### 手動インストール

手動でインストールしたい場合や、より細かく制御したい場合:

#### 方法 1: Docker（推奨）

**必要環境:**
- Docker と Docker Compose

**手順:**
```bash
# リポジトリをクローン
git clone https://github.com/PhialsBasement/LibreCrawl.git
cd LibreCrawl

# 環境設定ファイルをコピー
cp .env.example .env

# LibreCrawl を起動
docker-compose up -d

# ブラウザで http://localhost:5000 を開く
```

デフォルトでは、個人利用しやすいようローカルモードで動作します。`.env` で制御できます:

```bash
# .env ファイル
LOCAL_MODE=true
HOST_BINDING=127.0.0.1
REGISTRATION_DISABLED=false
```

ユーザー認証付きで本番運用する場合は、`.env` を編集してください:

```bash
# .env ファイル
LOCAL_MODE=false
HOST_BINDING=0.0.0.0
REGISTRATION_DISABLED=false
```

#### 方法 2: Python

- Python 3.8 以上
- モダンなウェブブラウザ（Chrome、Firefox、Safari、Edge）

### インストール手順

1. このリポジトリをクローンまたはダウンロードする

2. 依存関係をインストール:
```bash
pip install -r requirements.txt
```

3. JavaScript レンダリング対応（任意）:
```bash
playwright install chromium
```

4. アプリケーションを起動:
```bash
# 標準モード（認証とティア制あり）
python main.py

# ローカルモード（全ユーザーが管理者ティア、レート制限なし）
python main.py --local
# または
python main.py -l
```

5. ブラウザで次の URL にアクセス:
   - ローカル: `http://localhost:5000`
   - ネットワーク: `http://<あなたのIP>:5000`

## LibreCrawl プラグイン

カスタムプラグインファイルを `/web/static/plugins/` に置くだけで、各 `.js` ファイルが LibreCrawl 内の新しいタブとして自動的に追加されます。

### 🔌 クイックスタート

1. このフォルダに新しい `.js` ファイルを作成（例: `my-plugin.js`）
2. LibreCrawl プラグイン API でプラグインを登録する
3. アプリを再読み込み — 新しいタブが自動で表示されます

### 📝 プラグイン構造の例

```javascript
LibreCrawlPlugin.register({
  // 必須: 一意の ID（タブ識別に使用）
  id: 'my-plugin',

  // 必須: 表示名
  name: 'My Plugin',

  // 必須: タブ設定
  tab: {
    label: 'My Tab',
    icon: '🔥', // 任意の絵文字
  },

  // タブが有効になったときに呼ばれる
  onTabActivate(container, data) {
    // data には { urls, links, issues, stats } が含まれる
    container.innerHTML = `
      <div class="plugin-content" style="padding: 20px; overflow-y: auto; max-height: calc(100vh - 280px);">
        <h2>マイカスタム分析</h2>
        <p>${data.urls.length} 件の URL を取得しました！</p>
      </div>
    `;
  },

  // 任意: ライブクロール中にデータが更新されたときに呼ばれる
  onDataUpdate(data) {
    if (this.isActive) {
      // UI を更新
    }
  }
});
```

### 🎯 利用可能なデータ

プラグインには組み込みタブと同じデータが渡されます:

- **`urls`** - メタデータ付きのクロール済み URL の配列
- **`links`** - 検出されたすべてのリンク（内部/外部）
- **`issues`** - 検出された SEO 問題
- **`stats`** - クロール統計（検出数、クロール数、深さ、速度）

### 📚 完全 API リファレンス

#### プラグイン設定

```javascript
{
  id: string,              // 一意の識別子
  name: string,            // 表示名
  version: string,         // 任意: バージョン
  author: string,          // 任意: 作者
  description: string,     // 任意: 説明

  tab: {
    label: string,         // タブボタンのテキスト
    icon: string,          // 任意: 絵文字/アイコン
    position: number       // 任意: 位置（デフォルト: 末尾に追加）
  }
}
```

#### ライフサイクルフック

- `onLoad()` - プラグイン読み込み時に呼ばれる
- `onTabActivate(container, data)` - タブがアクティブになったときに呼ばれる
- `onTabDeactivate()` - ユーザーが別タブに切り替えたときに呼ばれる
- `onDataUpdate(data)` - ライブクロール中にデータ更新時に呼ばれる
- `onCrawlComplete(data)` - クロール完了時に呼ばれる

#### ユーティリティ

`this.utils` で組み込みユーティリティにアクセスできます:

```javascript
this.utils.showNotification(message, type) // 'success', 'error', 'info'
this.utils.formatUrl(url)
this.utils.escapeHtml(text)
```

#### 🎨 スタイリング

LibreCrawl のデザインに合わせるための CSS クラス:

- `.plugin-content` - メインコンテナ
- `.plugin-header` - ヘッダー領域
- `.data-table` - テーブル（自動スタイル適用）
- `.stat-card` - 統計カード
- `.score-good` / `.score-needs-improvement` / `.score-poor` - スコア表示用

**重要:** タブ内で正しくスクロールするため、メインのプラグインコンテナに次のスタイルを必ず付けてください:

```javascript
container.innerHTML = `
  <div class="plugin-content" style="padding: 20px; overflow-y: auto; max-height: calc(100vh - 280px);">
    <!-- ここにコンテンツ -->
  </div>
`;
```

`max-height: calc(100vh - 280px)` により、タブペイン内でコンテンツが正しくスクロールします。

#### サンプルプラグイン

次のサンプルプラグインを参考にしてください:

- `_example-plugin.js` - 基本テンプレート（ローダーでは無視される）
- `e-e-a-t.js` - E-E-A-T 分析の例

### 実行モード

**標準モード**（デフォルト）:
- ログイン/登録付きの完全な認証システム
- ティア別アクセス制御（Guest、User、Extra、Admin）
- ゲストユーザーは 24 時間あたり 3 回までクロール（IP ベース）
- 公開デモや共有ホスティング向け

**ローカルモード**（`--local` または `-l`）:
- 全ユーザーが自動的に管理者ティアでアクセス
- レート制限やティア制限なし
- 個人利用や単一ユーザーのセルフホスティングに最適
- ローカル開発・テストに推奨

## 言語切り替え

ヘッダーの「日本語」「English」リンクで表示言語を切り替えられます。選択はセッションに保存され、次回アクセス時も維持されます。

翻訳を更新する場合:
```bash
./update-translations.sh
```

## 設定

「Settings」から以下を設定できます:

- **クローラー設定**: 深さ（最大 500 万 URL）、遅延、外部リンク
- **リクエスト設定**: ユーザーエージェント、タイムアウト、プロキシ、robots.txt
- **JavaScript レンダリング**: ブラウザエンジン、待機時間、ビューポートサイズ
- **フィルター**: 含める/除外するファイルタイプと URL パターン
- **エクスポートオプション**: 形式とエクスポートするフィールド
- **カスタム CSS**: カスタムスタイルで UI の見た目を変更
- **問題の除外**: SEO 問題検出から除外するパターン

PageSpeed 分析では、Settings > Requests で Google API キーを設定するとレート制限が緩和されます（1 日 25,000 回 vs 制限付き）。

## エクスポート形式

- **CSV**: スプレッドシート向け
- **JSON**: 全詳細を含む構造化データ
- **XML**: 他ツール用のマークアップ形式

## マルチテナント

LibreCrawl は隔離されたセッションで複数ユーザーの同時利用をサポートしています:

- 各ブラウザセッションが独自のクローラーインスタンスとデータを持つ
- 設定はブラウザの localStorage に保存（再起動後も保持）
- カスタム CSS テーマはブラウザごと
- 1 時間無操作でセッションは期限切れ
- クロールデータはユーザー間で隔離される

## 既知の制限

- PageSpeed API にはレート制限がある（API キーがあるとより快適に利用可能）
- 大規模サイトはクロール完了に時間がかかる場合がある
- JavaScript レンダリングは HTTP のみのクロールより遅い
- 設定は localStorage に保存される（ブラウザデータを消すと消える）

## 主なファイル

- `main.py` - メインアプリケーションと Flask サーバー
- `src/crawler.py` - コアクローラーエンジン
- `src/settings_manager.py` - 設定管理
- `web/` - フロントエンドのファイル

## ライセンス

MIT License。詳細は LICENSE ファイルを参照してください。
