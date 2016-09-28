library(DBI)
library(RPostgreSQL)
library(dplyr)
library(ggplot2)

isdb = src_postgres("isdb", host = "ireland", user = "isdb_r")
data = tbl(isdb, sql("SELECT * FROM summary_by_gene")) %>%
  filter( environment = "in vivo" ) %>%
  collect()

genes = ggplot(data) +
  geom_point(aes(x = unique_sites, y = subjects, size = total_in_gene)) +
  scale_x_log10()

plot(genes)

dbDisconnect(isdb$con)
