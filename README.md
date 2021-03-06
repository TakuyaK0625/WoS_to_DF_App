# WoS_to_DataFrame
このアプリケーションでは、Web of Scienceからダウンロードできる論文データを著者名単位の個票データに整理するとともに、各著者がFirst AuthorやReprint Authorか否か、当該論文が国際共著論文か否かについて判定します。

## 使い方

0. 前準備  
Web of Scienceでキーワード等により論文リストの絞り込みを行い、「エクスポート」⇨「他のファイルフォーマット」を選んでファイルをダウンロードします。なお、その際に、レコードコンテンツは「詳細表示」に、ファイルフォーマットは「タブ区切り（Mac/Win, UTF-8）」に設定してください。

1. ご自身のR言語の実行環境において、以下のパッケージをインストールしてください。
* install.packages("shiny")
* install.packages("shinydashboard")
* install.packages("dplyr")
* install.packages("stringr")
* install.packages("tidyr")
* install.packages("DT")
* install.packages("purrr")

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
* Check.Org：所属機関情報にチェックが必要かどうか（備考１）
* Check.RA：Reprint Author情報にチェックが必要かどうか（備考２）
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

**備考１：所属機関について**

所属機関情報は著者のフルネームによって照合しており、フルネームが同じ著者がいた場合には、Orgにそれぞれの所属機関名がマージした情報が入ります。そのため、Check.OrgがTRUEの研究者のOrgについては、目視による確認作業をお願いいたします。


**備考２：Reprint Authorについて**

Reprint Authorは著者の略称と所属機関名で照合しています。そのため、Reprint Authorと同じ略称と所属機関の著者がいた場合には、この方もRAはTRUEとなります。RAがTRUEの著者のうち、略称と所属機関
が同じ著者が複数いた場合にはCheck.RAがTRUEになるようにしていますので、このような場合には目視による確認作業をお願いいたします。
