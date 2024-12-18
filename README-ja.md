
# IPIP6トンネルマネージャー

本プロジェクトはIPv6ベースのIPIP6トンネルのセットアップと管理を自動化し、動的なIPv6プレフィックスの変更に対応します。Linuxシステム上で`netplan`および`networkd-dispatcher`と統合されています。

## 特徴
- **IPv6プレフィックス検出**: IPv6プレフィックスの変更を自動的に検出し、トンネル設定を更新します。
- **動的Netplan設定**: `netplan`のYAML設定ファイルを動的に生成・適用します。
- **TCPMSSクランプ**: iptablesを使用して適切なMTU処理を行います。
- **プレフィックス変更処理**: IPv6プレフィックス変更時に任意のコマンドを実行できます。
- **ログレベル**: INFO、ERROR、DEBUGレベルのログをサポートしています。

## ファイル構成
```
ipip6-tunnel/
├── Makefile
├── bin/
│   ├── setup-ipip6.sh          # IPIP6トンネルのセットアップ
│   └── cleanup-ipip6.sh        # IPIP6トンネルのクリーンアップ
├── lib/
│   └── ipip6-utils.sh          # 共通のユーティリティ関数
├── dispatcher/
│   └── 50-ipip6-handler        # プレフィックス変更を検出してセットアップを実行
└── etc/
    ├── ipip6.conf              # 設定ファイル
    └── netplan-template.yaml   # Netplan設定テンプレート
```

## インストール方法
以下のコマンドでインストールします:

```bash
make install PREFIX=/usr/local
```

アンインストールする場合:

```bash
make uninstall PREFIX=/usr/local
```

## 設定方法
環境に合わせて `/etc/ipip6.conf` を編集します:

```bash
IPV6TOKEN="0000:0000:0000:0001"   # 固定IPv6トークン
REMOTE_IP="2001:db8::1"           # リモートIPv6アドレス
LOCAL_V4IP="192.0.2.1"            # トンネル用のローカルIPv4アドレス
INTERFACE="eth0"                  # 物理ネットワークインターフェース
TUNNEL_NAME="ipip6-tunnel"        # トンネル名
LOCAL_V6_FILE="/var/run/local_v6_ip"  # 最後に検出されたIPv6プレフィックスの保存先
ON_PREFIX_CHANGE_CMD=""           # プレフィックス変更時に実行するコマンド（任意）
```

## 使い方
1. **初期セットアップ**:  
   インストール後、`setup-ipip6.sh`スクリプトはシステム起動時およびプレフィックス変更時に自動的に実行されます。すぐに適用するには、以下を実行します:

   ```bash
   /usr/local/bin/setup-ipip6.sh
   ```

2. **手動クリーンアップ**:  
   トンネルを手動で削除するには、以下を実行します:

   ```bash
   /usr/local/bin/cleanup-ipip6.sh
   ```

3. **ログの確認**:  
   ログは `journalctl` コマンドで確認できます:

   ```bash
   journalctl -t ipip6-handler
   ```

## ライセンス
本プロジェクトはMITライセンスの下で提供されます。  
詳細は[LICENSE](./LICENSE)をご覧ください。
