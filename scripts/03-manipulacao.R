# Pacotes -----------------------------------------------------------------

library(tidyverse)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

View(imdb)
glimpse(imdb)
head(imdb)
tail(imdb)

# select ------------------------------------------------------------------

# exemplo 1

select(imdb, titulo, ano, orcamento)

# exemplo 2 

select(imdb, starts_with("ator"))

ends_with("")
contains("")
matches("[Aa]tor")
everything()
# colunas abc_0001, abc_0002, abc_0003, ..., abd_1034
num_range("abc_", 900:950)

# exemplo 3

select(imdb, -starts_with("ator"), -titulo)

# Exercício 1
# Crie uma tabela com apenas as colunas titulo, diretor, e orcamento. Salve em um
# objeto chamado imdb_simples.
imdb_simples <- select(imdb, titulo, diretor, orcamento)

# Exercício 2
# Remova as colunas ator_1, ator_2 e ator_3 de três formas diferentes. Salve em um
# objeto chamado imdb_sem_ator.
imdb_sem_ator <- select(imdb, -ator_1, -ator_2, -ator_3)
imdb_sem_ator <- select(imdb, -starts_with("ator"))
imdb_sem_ator <- select(imdb, -contains("ator"))
imdb_sem_ator <- select(imdb, num_range("ator_", c(1,3)))
imdb_sem_ator <- select(imdb, titulo:likes_facebook)
imdb_sem_ator <- select(imdb, contains("ator"), -ator_2)
select(imdb, -(1:12))
glimpse(imdb)
View(imdb_sem_ator)
view(imdb_sem_ator)

# arrange -----------------------------------------------------------------

# exemplo 1

arrange(imdb, orcamento)

# exemplo 2

arrange(imdb, desc(orcamento))

# exemplo 3

arrange(imdb, desc(ano), desc(titulo))

# exercício 1
# Ordene os filmes em ordem crescente de ano e decrescente de lucro e salve 
# em um objeto chamado filmes_ordenados
# receita - orcamento
arrange(imdb, desc(titulo))


# exemplo 4
# NA

df <- tibble(x = c(NA, 2, 1), y = c(1, 2, 3))
arrange(df, x)
arrange(df, desc(x))

# exemplo 5

imdb %>% filter(ano == 2010) %>% arrange(desc(orcamento))
arrange(filter(imdb, ano == 2010), desc(orcamento))

# Exercício 2 
# Selecione apenas as colunas título e orçamento 
# e então ordene de forma decrescente pelo orçamento.
base_selecionada <- select(imdb, titulo, orcamento)
base_selecionada <- arrange(base_selecionada, desc(orcamento))

arrange(select(imdb, titulo, orcamento), desc(orcamento)) 

# Pipe (%>%) --------------------------------------------------------------

# g(f(x)) = x %>% f() %>% g()

g(f(x))
g(f(x))

# Receita de bolo sem pipe. Tente entender o que é preciso fazer.

esfrie(
  asse(
    coloque(
        acrescente(
          recipiente(
            rep(
              "farinha", 
              2
            ), 
            "água", "fermento", "leite", "óleo"
          ), 
          "farinha", até = "macio"
        ), 
      lugar = "forma", tipo = "grande", untada = TRUE
    ), 
    duração = "50min"
  ), 
  "geladeira", "20min"
)

# Veja como o código acima pode ser reescrito utilizando-se o pipe. 
# Agora realmente se parece com uma receita de bolo.
rep("farinha", 2) %>%
  recipiente("água", "fermento", "leite", "óleo") %>%
  acrescente("farinha", até = "macio") %>%
  bata(duração = "4min") %>%
  coloque(lugar = "forma", tipo = "grande", untada = TRUE) %>%
  asse(duração = "50min") %>%
  esfrie("geladeira", "20min")

# ATALHO: CTRL + SHIFT + M


# Exercício
# Refaça o exercício 2 do arrange utilizando o %>% 
arrange(select(imdb, titulo, orcamento), desc(orcamento)) 
imdb_novo <- imdb %>%
  select(titulo, orcamento) %>%
  arrange(desc(orcamento))

# filter ------------------------------------------------------------------

# exemplo 1
imdb %>% filter(nota_imdb > 9)

# exemplo 2
imdb %>% filter(diretor == "Quentin Tarantino")


# exercício 1
# Criar uma variável chamada `filmes_baratos` com filmes com orçamento menor do 
# que 1 milhão de dólares.
filmes_baratos <- imdb %>% 
  filter(orcamento < 1000000)
  

# exemplo 3
imdb %>% filter(ano > 2010 & nota_imdb > 8.5)
imdb %>% 
  filter(
  orcamento < 100000
  ,receita > 1000000
)
imdb %>% filter(receita > orcamento + 500000000 | nota_imdb > 9)


# exemplo 4
imdb %>% filter(receita > orcamento)
imdb %>% filter(receita > orcamento + 500000000)

# exemplo 5
imdb %>% filter(ano > 2010)
imdb %>% filter(!ano > 2010)

# exercício 2
# Criar um objeto chamado bons_baratos com filmes que tiveram nota no imdb 
# maior do que 8.5 e um orcamento menor do que 1 milhão de dólares.
bons_baratos <- imdb %>%
  filter(
    nota_imdb > 8.5,
    orcamento < 1e6
  )




# exercício 3
# Criar um objeto chamado curtos_legais com filmes de 1h30 ou menos de duração 
# e nota no imdb maior do que 8.5.
curtos_legais <- imdb %>%
  filter(
    duracao <= 90,
    nota_imdb > 8.5
  )

# exercício 4
# Criar um objeto antigo_colorido com filmes anteriores a 1950 que são 
# coloridos. 
# Crie também um objeto antigo_bw com filmes antigos que não são coloridos.
# imdb %>% count(cor, ano)
antigo_colorido <- imdb %>%
  filter(
    ano < 1950,
    cor == "Color"
  )


# exercício 5
# Criar um objeto ww com filmes do Wes Anderson ou do Woody Allen.
# DIRETOR
ww <- imdb %>%
  filter(
    diretor == "Wes Anderson" | diretor == "Woody Allen"
  )

# Exercício 6
# Crie uma tabela apenas com filmes do Woody Allen e apenas as colunas titulo e ano,
# ordenada por ano.
# "pipeline"
a <- imdb %>%
  filter(diretor == "Woody Allen") %>%
  select(titulo, ano) %>%
  arrange(ano) 


# exemplo 6
# %in%

pitts <- imdb %>% filter(ator_1 %in% c('Angelina Jolie Pitt', "Brad Pitt"))

# exercicio 6
# Refaça o exercício 5 usando o %in%.
ww <- imdb %>%
  filter(
    diretor %in% c("Wes Anderson", "Woody Allen")
  )



diretores_do_mes <- read_csv("dados/imdb.csv") %>%
  slice(1:10) %>%
  distinct(diretor) %>%
  pull(diretor)





ww <- imdb %>%
  filter(
    diretor %in% diretores_do_mes
  )

# exemplo 7
df <- tibble(
  x = c(1, NA, 3),
  idade = c(40, 23, 99)
)

filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# exercício 7
# Identifique os filmes que não possuem informação tanto de receita quanto de orcamento
# e salve em um objeto com nome sem_info.
sem_info <- imdb %>%
  filter(
    is.na(receita),
    is.na(orcamento)
  )

# exemplo 8
# str_detect

imdb %>% filter(str_detect(generos, "[Aa]ction")) %>% View

imdb %>% filter(generos == "Action") %>% View


# exercício 8
# Salve em um objeto os filmes de Ação e Comédia com nota no imdb maior do que 8.
acao_comedia_bons <- imdb %>%
  filter(
    str_detect(generos, "Comedy"),
    nota_imdb > 8
    str_detect(generos, "Action"),
  )

# mutate ------------------------------------------------------------------

# exemplo 1

imdb %>% mutate(duracao = duracao/60)

# exemplo 2

imdb %>% 
  mutate(duracao_horas = duracao/60) %>% 
  select(titulo:duracao, duracao_horas, everything())

# exercício 1
# Crie uma variável chamada lucro. Salve em um objeto chamado imdb_lucro.
# lucro: receita - orcamento
imdb_lucro <- imdb %>%
  mutate(
    lucro = receita - orcamento
  )

View(imdb_lucro)
# exercicio 2
# Modifique a variável lucro para ficar na escala de milhões de dólares.
imdb_lucro <- imdb_lucro %>%
  mutate(
    lucro = round(lucro/1e6, digits = 0)
  )

# exercício 3
# Filtre apenas os filmes com prejuízo maior do que 3 milhões de dólares. 
# Deixe essa tabela ordenada com o maior prejuízo primeiro. Salve o resultado em 
# um objeto chamado filmes_prejuizo.
filmes_prejuizo <- imdb_lucro %>%
  filter(lucro < -3) %>%
  arrange(lucro)


# exemplo 3
# gêneros

# install.packages("gender")
library(gender)

gender(c("William"), years = 2012)
gender(c("Robin"), years = 2012)

gender(c("Madison", "Hillary"), years = 1930, method = "ssa")
gender(c("Madison", "Hillary"), years = 2010, method = "ssa")

gender("Matheus", years = 1920)

obter_genero <- function(nome, ano) {
  
  if (is.na(nome) | is.na(ano)) {
    return(NA_character_)
  }
  
  ano_min <- ano - 60
  ano_max <- ano - 30
  
  if (ano_min < 1880) {
    ano_min <- 1880
  }
  
  genero <- gender(nome, years = c(ano_min, ano_max), method = "ssa")$gender
  
  if(length(genero) == 0) {
    genero <- NA_character_
  }
  
  genero
}

obter_genero("Madison", 1930)
obter_genero("Matheus", 1930)

# demora +- 10 min.
imdb_generos <- imdb %>%
  select(diretor, ano) %>%
  distinct() %>%
  mutate(
    diretor_primeiro_nome = str_extract(diretor, ".* ") %>% str_trim(),
    genero = map2_chr(diretor_primeiro_nome, ano, obter_genero)
  )

view(imdb_generos)

# saveRDS(imdb_generos, "data/imdb_generos.rds")
imdb_generos <- read_rds("dados/imdb_generos.rds")

# https://github.com/meirelesff/genderBR

# summarise ---------------------------------------------------------------

# exemplo 1

imdb %>% summarise(media_orcamento = mean(orcamento, na.rm = TRUE))

# exemplo 2

imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  mediana_orcamento = median(orcamento, na.rm = TRUE),
  qtd = n(),
  qtd_diretores = n_distinct(diretor)
)

median(c(1, 2, 3, NA), na.rm = TRUE)


# exemplo 3

imdb_generos %>%
  summarise(n_diretoras = sum(genero == "female", na.rm = TRUE))

# sum(vetor lógico) ==> contagem
# mean(vetor lógico) ==> proporcao
imdb_generos %>% count(genero)

# exercício 1
# Use o `summarise` para calcular a proporção de filmes com diretoras.
imdb_generos %>%
  summarise(p_diretoras = mean(genero == "female", na.rm = TRUE))

# exercício 2
# Calcule a duração média e mediana dos filmes da base.
imdb %>%
  summarise(
    duracao_media = mean(duracao, na.rm = TRUE),
    duracao_mediana = median(duracao, na.rm = TRUE)
  )

# exercício 3
# Calcule o lucro médio dos filmes com duracao < 60 minutos. E o lucro médio dos filmes com
# mais de 2 horas.
imdb_lucro %>%
  filter(duracao < 60) %>%
  summarise(
    lucro_medio = mean(lucro, na.rm = TRUE)
  )

imdb_lucro %>%
  filter(duracao > 120) %>%
  summarise(
    lucro_medio = mean(lucro, na.rm = TRUE)
  )

imdb_lucro %>%
  summarise(
    lucro_medio_menor_60 =  mean(lucro[duracao < 60], na.rm = TRUE),
    lucro_medio_maior_120 = mean(lucro[duracao > 120], na.rm = TRUE)
  )


# group_by + summarise ----------------------------------------------------

# exemplo 1

imdb %>% group_by(ano)

# exemplo 2

imdb %>% 
  mutate(
    codigo = str_sub(ano, 3, 4)
  ) %>%
  group_by(codigo) %>%
  summarise(
    qtd_filmes = n(),
    dp_duracao = sd(duracao, na.rm = TRUE),
    max_orcamento = max(orcamento, na.rm = TRUE)
  ) %>%
  group_by(max_orcamento) %>%
  arrange(dp_duracao)

# exemplo 3

imdb %>% 
  group_by(diretor) %>% 
  summarise(
    qtd_filmes = n()
  ) %>%
  arrange(desc(qtd_filmes))

# exercício 1
# Crie uma tabela com apenas o nome dos diretores com mais de 10 filmes.
# group_by + summarise
# filter
# select
imdb %>%
  group_by(diretor) %>%
  summarise(
    qtd_filmes = n()
  ) %>%
  filter(qtd_filmes > 10) %>%
  select(diretor)

# exercício 2
# Crie uma tabela com a receita média e mediana dos filmes por ano.
imdb %>%
  group_by(ano, diretor) %>%
  summarise(
    receita_media = mean(receita, na.rm = TRUE),
    receita_mediana_ano = median(receita, na.rm = TRUE)
  ) %>%
  filter(
    !is.na(receita_mediana_ano)
  )

# exercício 3
# Crie uma tabela com a nota média do imdb dos filmes por tipo de classificacao.
imdb %>%
  group_by(classificacao) %>%
  summarise(
    nota_media = mean(nota_imdb, na.rm = NA)
  )


# exemplo 4
imdb %>%
  filter(str_detect(generos, "Action"), !is.na(diretor)) %>%
  group_by(diretor) %>%
  summarise(qtd_filmes = n()) %>%
  arrange(desc(qtd_filmes))

imdb %>%
  group_by(diretor) %>%
  summarise(
    qtd_filmes = n()
  )

imdb %>%
  count(diretor, ano, name = "qtd_filmes")

# exemplo 5

imdb %>% 
  filter(ator_1 %in% c("Brad Pitt", "Angelina Jolie Pitt")) %>%
  group_by(ator_1) %>%
  summarise(orcamento = mean(orcamento), receita = mean(receita), qtd = n())

# left join ---------------------------------------------------------------

# exemplo 1

imdb_generos2 <- imdb %>%
  left_join(imdb_generos, by = c("diretor", "ano"))


imdb_generos2 <- imdb %>% left_join(imdb_generos, by = c("diretor", "ano"))


# exemplo 2

depara_cores <- tibble(
  cor = c("Color", "Black and White"),
  cor2 = c("colorido", "pretoEbranco")
)

imdb_cor <- left_join(imdb, depara_cores, by = c("cor"))


# exercicio 1
# Calcule a média dos orçamentos e receitas para filmes feitos por
# genero do diretor.
# imdb
# left_join com a imdb_generos usando as chaves diretor e ano
# group_by + summarise para calcular as medias de orcamento e receita por genero de diretor
imdb %>%
  left_join(imdb_generos, by = c("diretor" = "diretor", "ano" = "ano")) %>%
  filter(!is.na(genero)) %>%
  group_by(genero) %>%
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE)
  )

# gather ------------------------------------------------------------------
# exemplo 1
imdb_gather <- imdb %>%
  distinct(titulo, .keep_all = TRUE) %>%
  gather("importancia_ator", "nome_ator", starts_with("ator"))

# spread ------------------------------------------------------------------
# exemplo 1

imdb <- spread(imdb_gather, importancia_ator, nome_ator)
imdb %>%
  distinct(titulo, .keep_all = TRUE) %>% nrow



