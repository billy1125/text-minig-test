# 載入 readr 套件（如果尚未安裝，需要先安裝）
# install.packages("readr")
# install.packages("jiebaR")
# install.packages("knitr")
library(readr)
library(tidytext)
library(jiebaR)
library(knitr)

Sys.setlocale(locale = "cht")

# 設定 CSV 檔案的路徑
csv_file_path <- "data.csv"  # 請將路徑替換為你的 CSV 檔案路徑

# 讀取 CSV 檔案
data <- read.table(csv_file_path, header = TRUE, sep = ",", encoding = "UTF-8") # encoding 是指定檔案的文字編碼
# data <- read_csv(csv_file_path)

# 顯示讀取的資料
print(data)
selected_data <- data[, c("comment")]
print(selected_data)
# 或者你也可以對讀取的資料進行一些處理和分析
# 例如計算統計量、繪製圖表等等
summary(data)  # 顯示資料摘要

# unnest_tokens(word, data$comment)

# plot(data$D3# plot(data$D3# plot(data$D3)  # 繪製某一欄位的散點圖

# With user dict
seg <- worker(user = "user_dict.txt")

# seg <- worker()
# txt <- "失業的熊讚陪柯文哲看銀翼殺手" 
segment(selected_data, seg)

docs_segged <- vector("character", length = length(selected_data))
for (i in seq_along(selected_data)) {
  # Segment each element in docs
  segged <- segment(selected_data[i], seg)
  
  # Collapse the character vector into a string, separated by space
  docs_segged[i] <- paste0(segged, collapse = "\u3000")
}

docs_segged

docs_df <- tibble::tibble(
  doc_id = seq_along(docs_segged),
  content = docs_segged
)

knitr::kable(docs_df, align = "c")