# パッケージ
library(shiny)
library(shinydashboard)
library(dplyr)
library(stringr)
library(tidyr)
library(DT)
library(purrr)
source("Clean_WoS.R")
site <- a("こちら", href = "https://github.com/TakuyaK0625/WoS_to_DF_App")

# User Interface
ui <- dashboardPage(skin = "yellow", title = "WoS論文整理アプリ",
    
    # ヘッダー
    dashboardHeader(title = strong("WoS論文整理アプリ")),
    
    # サイドバー
    dashboardSidebar(
        
        br(),
        
        # ファイルインポート
        tags$style(".btn-file {color: black}"),
        fileInput(inputId = "WoS.file", label = "１. WoSファイル（txt）の選択",
                  accept = c("txt"),
                  multiple = FALSE,
                  width = "100%",
                  buttonLabel = "Browse...",
                  placeholder = "No file selected"
        ),
        
        strong(p("　２. 処理の開始")),
        tags$style(type="text/css", "#submit {color: black}"),
        actionButton("submit", "Start Processing"),

        # ダウンロードボタン
        br(),
        br(),
        strong(p("　３. ダウンロード")),
        tags$style(type="text/css", "#downloadData {color: black}"),
        div(style = "padding-left:1em", downloadButton("downloadData", "Download Table")),
        
        # 開発者紹介
        br(), br(), br(), br(),
        strong(p("【開発者】", style = "margin-left:0.5em")), 
        p("信州大学", style = "padding-left:0.5em"), 
        p("学術研究・産学官連携推進機構", style = "padding-left:0.5em"), 
        p("久保琢也 助教（URA）", style = "padding-left:0.5em"),
        p("kubotaku@shinshu-u.ac.jp", style = "padding-left:0.5em")
        ),
    
    # ボディ
    dashboardBody(
        box(
            title = strong("◯About this website"), width = 12, status = "primary",
            p("・このサイトで提供するアプリケーションでは、Web of Scienceからダウンロードできる論文データを
            著者名単位の個票データに整理するとともに、各著者がFirst AuthorやReprint Authorか否か、当該論文が
            国際共著論文か否かについて判定します。", style = "text-indent: -1em;padding-left: 2em;"),
            p("・論文データはWeb of Scienceでキーワード等により論文リストの絞り込みを行い、「エクスポート」⇨
            「他のファイルフォーマット」から、レコードコンテンツは「詳細表示」に、ファイルフォーマットは
            「タブ区切り（Mac/Win, UTF-8）」に設定してダウンロードしてください。", style = "text-indent: -1em;padding-left: 2em;"),
            p(tagList("・より詳細な情報やソースコードについては", site, "をご覧ください"), style = "text-indent: -1em;padding-left: 2em;"),
            ),
        
        br(),
        
        # インポートファイルの表示
        dataTableOutput("DT")
        
    )
)


# Server
server <- function(input, output, session) { 
    
    # アップロードサイズ
    options(shiny.maxRequestSize=30*1024^2)
    
    # ファイルがアップロードされているか

    
    # ファイルのインポート
    observeEvent(input$submit, {
        
        req(!is.null(input$WoS.file))
        
        file <- reactive({
            readLines(input$WoS.file$datapath)
            })
        
        df <- data.frame()
        n <- length(file())
        withProgress(message = 'Step 1/2', {
            
            for (i in 2:n) {
                data <- str_split(file()[i], pattern = "\t") %>% 
                    unlist %>% 
                    t() %>% 
                    as.data.frame %>% 
                    mutate_all(as.character)
                df <- rbind(df, data)
                incProgress(1/(n-1), detail = paste("Doing part", i, "/", n-1))
                }
            })
        
        # DFの整理
        names(df) <- read.table(textConnection(file()[[1]]), sep = "\t", stringsAsFactors = F) %>% unlist
        df <- df %>% 
            select(PT, AU, AF, TI, SO, DT, CT, C1, RP, SN, EI, PY, DI, WC, SC, UT) %>% 
            nest(-UT)
        
        # 
        DF <- data.frame()
        withProgress(message = 'Step 2/2', value = 0, {
            for (i in 1:nrow(df)) {
                d <- Clean.WoS(df$data[[i]], df$UT[1])
                DF <- bind_rows(DF, d)
                incProgress(1/nrow(df), detail = paste("Doing part", i, "/", n-1))
            }
        })
        
        # DT出力
        output$DT <- renderDataTable({
            DF %>% datatable()
            })
        
        # ダウンローダー
        output$downloadData <- downloadHandler(
            filename = paste0("WoS_Cleaned_", Sys.Date(), ".csv"),
            content = function(file) {
                write.csv(DF, file, row.names = FALSE, fileEncoding = "CP932")
            }
        )
        
})

}

# Execution
shinyApp(ui, server)
