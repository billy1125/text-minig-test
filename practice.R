library(jiebaR)
library(tidytext)
library(dplyr)

docs <- c(
  "蝴蝶和蜜蜂們帶著花朵的蜜糖回來了，羊隊和牛群告別了田野回家了，火紅的太陽也滾著火輪子回家了，當街燈亮起來向村莊道過晚安，夏天的夜就輕輕地來了。",
  "朋友買了一件衣料，綠色的底子帶白色方格，當她拿給我們看時，一位對圍棋十分感與趣的同學說：「啊，好像棋盤似的。」「我看倒有點像稿紙。」我說。「真像一塊塊綠豆糕。」一位外號叫「大食客」的同學緊接著說。",
  "每天，天剛亮時，我母親便把我喊醒，叫我披衣坐起。我從不知道她醒來坐了多久了。她看我清醒了，便對我說昨天我做錯了什麼事，說錯了什麼話，要我認錯，要我用功讀書。",
  "威廉．肯特里奇的作品向來以濃烈深厚的敘述詩情、豐富的媒材語彙著稱，從歷史檔案到地圖、電影到小說、戲劇到舞蹈、詩集到音樂，並以詩性轉譯的手法昇華沉重議題的傷痛，賦予作品亙古的人性價值與藝術能量。"
)

seg <- worker(user = "user_dict.txt")
segment(docs, seg)

# Initialize jiebaR
docs_segged <- vector("character", length = length(docs))
for (i in seq_along(docs)) {
  
  # Segment each element in docs
  segged <- segment(docs[i], seg)
  print(segged)
  # Collapse the character vector into a string, separated by space
  docs_segged[i] <- paste0(segged, collapse = "\u3000")
}

docs_segged

docs_df <- tibble::tibble(
  doc_id = seq_along(docs_segged),
  content = docs_segged
)

knitr::kable(docs_df, align = "c")


tidy_text_format <- docs_df %>%
  unnest_tokens(output = "word", input = "content",
                token = "regex", pattern = "\u3000")  # 以空白字元作為 token 分隔依據

tidy_text_format

tidy_text_format %>%
  group_by(word) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

library(ggplot2)
tidy_text_format %>%
  count(word) %>%
  mutate(word = reorder(word, n)) %>%   # 依照 n 排序文字
  top_n(10, n) %>%                      # 取 n 排名前 10 者
  ggplot() +
  geom_bar(aes(word, n), stat = "identity") +
  coord_flip()