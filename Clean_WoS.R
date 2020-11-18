Clean.WoS <- function (x, y) {
    
    data <- x
    
#------------------------------------------------------------------------------------
# 著者名の整理
#------------------------------------------------------------------------------------
    
# 著者名（フル）
Author.full<- data$AF %>% str_split("; ") %>% unlist

# 著者名（略称）
Author.short <- data$AU %>% str_split("; ") %>% unlist

# 著者名DF
Author.df <- data.frame(Author.full, Author.short) %>%
    mutate(Author.full = as.character(Author.full)) %>%
    mutate(Author.short = as.character(Author.short))


#------------------------------------------------------------------------------------
# 所属機関の整理
#------------------------------------------------------------------------------------

if(is.na(data$C1) | !(str_detect(data$C1, "\\[.*?\\]"))){
    
    DF <- Author.df %>% mutate(Org = paste0("Check: ", data$C1))
    
} else {
    
    # 同じ所属の著者グループの抽出
    Author.group <- data$C1 %>% 
        str_extract_all("\\[.*?\\]") %>%    
        unlist %>%                          # ベクトル化
        str_replace_all("\\[", "") %>%      #  [ の削除
        str_replace_all("\\]", "")          #  ] の削除 
    
    # 所属を分割    
    Org <- data$C1 %>% 
        str_extract_all("\\[.*?(?=\\[|$)") %>%
        unlist %>%
        str_replace_all("\\[.*?\\]", "") %>%
        str_replace_all("; $", "") %>%
        str_trim(side = "both")
    
    # 著者グループと所属の統合、展開
    Org.df <- data.frame(Author.group, Org) %>%
        mutate(Author.full = str_split(Author.group, "; ")) %>%    # 著者グループを著者個人に分割（リスト）
        unnest(cols = Author.full) %>%
        mutate(Country = str_replace(Org, "(^.+, )(.+$)", "\\2")) %>%
        mutate(Country = ifelse(str_detect(Country, "USA"), "USA", Country)) %>%
        group_by(Author.full) %>%
        summarize(Org = paste(Org, collapse = "; "), Country = paste(unique(Country), collapse = ";"))
    
    # 著者名と所属機関との結合
    DF <- Author.df %>% left_join(Org.df)
}


#------------------------------------------------------------------------------------
# 国際共著論文チェック
#------------------------------------------------------------------------------------

Country.num <- DF$Country[!is.na(DF$Country)] %>% unique %>% length

if (Country.num > 1) {
    DF <- DF %>% mutate(Int.collab = TRUE)
} else {
    DF <- DF %>% mutate(Int.collab = FALSE)
}


#------------------------------------------------------------------------------------
# 筆頭著者、責任著者チェック
#------------------------------------------------------------------------------------

# 筆頭著者チェック
DF <- DF %>% mutate(FA = c(TRUE, rep(FALSE, nrow(DF) - 1))) 

# 責任著者チェック
RP.list <- data$RP %>% 
    str_split("; ") %>% 
    unlist %>% 
    str_replace("\\.$", "") %>%
    str_split(" \\(corresponding author\\), ")

if(nrow(DF) == 1){             # 著者が１名の場合は自動的に責任著者
    
    DF <- DF %>% mutate(RA = 1)           
    
    } else {                    # 著者が複数の場合は責任著者ベクトルに含まれるものをチェック
        
        DF <- DF %>% mutate(RA = FALSE)
        for (i in seq_along(RP.list)) {
            DF <- DF %>% mutate(RA = ifelse(Author.short == RP.list[[i]][1] & str_detect(Org, RP.list[[i]][2]), i, FALSE))
        }
    }


#------------------------------------------------------------------------------------
#  --- Warning ---
# ・同名（フルネーム）の著者のOrgはそれぞれの所属機関をマージした値となるため
# ・著者名（略称）と所属機関の組み合わせがRAと同じ著者にもRAにチェックが入るため
#------------------------------------------------------------------------------------

# 著者名（Full）の重複
Author.dup <- DF$Author.full[DF$Author.full %>% duplicated()]
DF <- DF %>% mutate(Check.Org = Author.full %in% Author.dup)

# RAの重複（2人以上とマッチしているかチェック）
RA.dup.num <- DF %>% filter(RA > 0) %>% group_by(RA) %>% summarize(N = n()) %>% filter(N > 1) %>% pull(RA)
DF <- DF %>% mutate(Check.RA = RA %in% RA.dup.num) %>% mutate(RA = ifelse(RA > 0, TRUE, FALSE))
    

#------------------------------------------------------------------------------------
# 整理&出力
#------------------------------------------------------------------------------------

# データの整理
DF <- DF %>%
    mutate(Pub.type = data$PT, Pub.name = data$SO, Doc.type = data$DT, Doc.title = data$TI, Conf.name = data$CT, ISSN = data$SN, e.ISSN = data$EI, 
           Year = data$PY, DOI = data$DI, WoS.category = data$WC, Area = data$SC, WoS.id = y)

# 出力
DF

}