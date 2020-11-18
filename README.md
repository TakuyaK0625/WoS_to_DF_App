# WoS_to_DataFrame
このアプリケーションでは、Web of Scienceからダウンロードできる論文データを著者名単位の個票データに整理するとともに、各著者がFirst AuthorやReprint Authorか否か, 当該論文が国際共著論文か否かについて判定します。

## 使い方

0. 前準備
Web of Scienceより整理したい論文データをダウンロードしておいてください。データは「その他のフォーマット」⇨「詳細表示」⇨「タブ区切り」のファイルです。

1. ご自身のR言語の実行環境において、以下のパッケージをインストールしてください。
* install.packages("shiny")
* install.packages(shinydashboard)
* install.packages(dplyr)
* install.packages(stringr)
* install.packages(tidyr)
* install.packages(DT)
* install.packages(purrr)

2. app.Rを開き全てのコードを実行するか、Rstudioの場合はコンソール右上のRun Appボタンを押してアプリを起動してください。

3. Web of Scienceの論文データをアップロードして実行してください。整理が終わったら論文データのダウンロードも可能です。

## 出力データ
