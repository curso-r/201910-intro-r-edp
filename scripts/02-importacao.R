library(tidyverse)

# Caminhos até o arquivo --------------------------------------------------

# 1. Podem ser absolutos
"/home/william/Documents/Curso-R/intro-programacao-em-r-mestre/dados/imdb.csv"

# 2. Podem ser relativos ao diretório de trabalho
getwd()

# exercício: na linha debaixo, 1) abram aspas, 2) posicionem o cursor entre as aspas e 3) apertem TAB.
"dados/imdb.sav"

# LEITURA DE DADOS --------------------------------------------------------
# Principais formatos -----------------------------------------------------

# Arquivos de texto
imdb <- read_csv(file = "dados/imdb.csv")
imdb2 <- read.csv2("dados/imdb2.csv", )

View(imdb2)

# Excel
library(readxl)
install.packages("readxl")
# Exercício: use a função read_excel() para ler o arquivo "dados/imdb.xlsx"
imdb_excel <- read_excel("dados/imdb.xlsx", sheet = "minha aba de interesse", n_max = 1, )
View(imdb_excel)

# SQL ---------------------------------------------------------------------
library(RSQLite)
conexao <- src_sqlite("dados/imdb.sqlite", create = TRUE)

imdb_sqlite <- tbl(conexao, "imdb")
imdb_select <- tbl(conexao, sql("SELECT titulo, ano, diretor FROM imdb"))
show_query(imdb_select)

imdb_select %>% select(titulo)

# trazer para a memória
imdb_sqlite_na_maquina_local <- collect(imdb_sqlite)
imdb_select_na_maquina_local <- collect(imdb_select)

copy_to(conexao, imdb_select)
imdb_select2 <- tbl(conexao, "imdb_select")


# db.rstudio.com




# GRAVANDO DADOS ------------------------------------------------------------
# funcoes que iniciam com 'write'
# csv
write_csv(imdb, path = "dados/imdb_novo.csv")

# Excel
library(writexl)
# Exercício: salve a tabela imdb_excel como uma planilha excel no arquivo "dados/imdb.xlsx" usando a função write_xlsx().
# DICA: é bem parecido com o jeito que se guarda CSV. 
write_xlsx(imdb, path = "dados/imdb_novo.xlsx")



# Outros formatos ---------------------------------------------------------

library(jsonlite)
imdb_json <- read_json("dados/imdb.json")

library(haven)

imdb_sas <- read_sas("dados/imdb.sas7bdat")
imdb_spss <- read_spss("dados/imdb.sav")

# data.table
library(data.table)
imdb_dt <- fread("dados/imdb.csv")



# (EXTRA!) Exemplo avançado ----------------------------------------------------------
library(purrr)
files <- list.files("dados/por-ano/", full.names = TRUE)
base2 <- map_dfr(files, read_excel, sheet = "minha aba de interesse")
View(base2)
