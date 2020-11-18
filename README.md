# WoS_to_DataFrame
このアプリケーションでは、Web of Scienceからダウンロードできる論文データを著者名単位の個票データに整理するとともに、各著者がFirst AuthorやReprint Authorか否か, 当該論文が国際共著論文か否かについて判定します。

## 使い方
1. ご自身のR言語の実行環境において、以下のパッケージをインストールしてください。
* install.packages("shiny")
* install.packages(shinydashboard)
* install.packages(dplyr)
* install.packages(stringr)
* install.packages(tidyr)
* install.packages(DT)
* install.packages(purrr)

2. WoS_to_DataFrame.Rを実行（※作業ディレクトリは「data」フォルダの1つ上）


## 備考
私はRにデータを読み込むまでが大変でした。私が辿ったステップは以下の通りですが、お使いのOSやその他の環境によっては違うプロセスが必要かもしれません。何れにせよ、Rにデータを読み込ませるためにはある程度の下準備が必要そうです。

1. Web of Scienceで論文検索したのち、詳細表示⇨タブ区切り（Mac）⇨ダウンロード
2. キロオーサー論文は削除（Excel上で様式が大きくずれる論文）
3. Excelを用いてcsv変換
