# パッケージ
library(shiny)
library(shinydashboard)
library(dplyr)
library(stringr)
library(tidyr)
library(DT)
library(purrr)
source("Clean_WoS.R")


# User Interface
ui <- dashboardPage(
    
    # ヘッダー
    dashboardHeader(),
    
    # サイドバー
    dashboardSidebar(
        br(),
        p("このウェイブサイトでは、Web of Scienceからダウンロードできる論文データ（詳細表示, タブ区切り）のクリーニング")
        
    ),
    
    # ボディ
    dashboardBody(
        
        # ファイルインポート
        fileInput(inputId = "WoS.file", label = "１. WoSファイル（txt）を選んでください",
                  accept = c("txt"),
                  multiple = FALSE,
                  width = "100%",
                  buttonLabel = "フォルダを開く",
                  placeholder = "ファイルが選択されていません"
        ),
        
        strong(p("２. 下のボタンを押して処理を開始してください")),
        actionButton("submit", strong("Start Processing"), 
                     style="color: #fff; background-color: #337ab7; bborder-color: #2e6da4"),
        
        # ダウンロードボタン
        br(),
        br(),
        br(),
        strong(p("３. 処理が終了した後に、以下のボタンからデータをダウンロードできます")),
        downloadButton("downloadData", "Download Table"),
        
        # インポートファイルの表示
        br(),
        br(),
        dataTableOutput("DT")
        
    )
)


# Server
server <- function(input, output, session) { 
    
    # アップロードサイズ
    options(shiny.maxRequestSize=30*1024^2)
    
    # ファイルのインポート
    observeEvent(input$submit, {
        
        file <- reactive({
            readLines(input$WoS.file$datapath)
            })
        
        df <- data.frame()
        n <- length(file())
        withProgress(message = 'Now Processing', value = 0, {
            
            for (i in 2:n) {
                data <- str_split(file()[i], pattern = "\t") %>% 
                    unlist %>% 
                    t() %>% 
                    as.data.frame %>% 
                    mutate_all(as.character)
                df <- rbind(df, data)
                incProgress(1/n, detail = paste("Doing part", i))
                }
            })
        
        # DFの整理
        names(df) <- read.table(textConnection(file()[[1]]), sep = "\t", stringsAsFactors = F) %>% unlist
        df <- df %>% 
            select(PT, AU, AF, TI, SO, DT, CT, C1, RP, SN, EI, PY, DI, WC, SC, UT) %>% 
            nest(-UT)
        DF <- map2(df$data, df$UT, Clean.WoS) %>% bind_rows
        
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
