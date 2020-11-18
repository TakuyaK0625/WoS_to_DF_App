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
* Author.full：著者名（フルネーム）
* Author.short：著者名（略称）
* Org：所属機関名
* Country：国名
* Int.collab：国際共著論文かどうか
* FA：First Authorかどうか
* RA：Reprint Authorかどうか
* Check.Org：後述（備考１）
* Check.RA：後述（備考２）
* Pub.type：出版物タイプ
* Pub.name：出版物名
* Doc.type：文書タイプ
* Doc.title：文書タイトル
* Conf.name：学会名
* ISSN：ISSN
* eISSN：ISSN（電子版）
* Year：出版年
* DOI：DOI
* WoS.category：Web of Scienceの分野
* Area：研究分野
* WoS.id：Web of ScienceにおけるID（Accession Number）

## 備考

備考１：所属機関について

備考２：Reprint Authorについて


