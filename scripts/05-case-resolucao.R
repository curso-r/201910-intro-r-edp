---
  title: "IMDB"
output: 
  flexdashboard::flex_dashboard:
  orientation: rows
editor_options: 
  chunk_output_type: console
---
  
  
  ```{r setup, include=FALSE}
library(flexdashboard)
library(tidyverse)
imdb <- read_rds("dados/imdb.rds")
```


Visão geral
============
  
  
  Row {data-height=110}
-------------------
  
  ### O problema
  
  O estúdio de filmes FilmR precisa escolher um(a) diretor(a) e um(a) protagonista para o seu próximo filme. Para isso ele conduziu uma análise exploratória em uma base de dados com diversas informações de quase 4 mil filmes lançados nos Estados Unidos desde 1916. O objetivo da FilmR é identificar os diretores e atores que trariam o maior retorno financeiro para a produtora. 

Row 
------------------------------------------------
  
  ### Qtd Filmes
  
  ```{r}
valueBox(nrow(imdb), icon = "fa-film")
```

### Qtd Diretores

```{r}
# dica1: pode usar imbd$diretor
# dica2: funcao n_distinct()
# usar icone "fa-video"
valueBox(n_distinct(imdb$diretor), icon = "fa-video")
```


### Qtd Atores

```{r}
# usar icone "fa-user"
atores <- unique(c(imdb$ator_1, imdb$ator_2, imdb$ator_3))
valueBox(length(atores), icon = "fa-user")
```

### Mais um value box

```{r}
valueBox(
  123, 
  icon = "fa-user", 
  color = "green"
)
```


Row
-----------------------------------------------
  
  ### Relação entre nota e lucro
  
  ```{r, fig.height=2.5, fig.width=4}
imdb <- imdb %>% mutate(lucro = receita - orcamento) 

###### grafico
grafico_1 <- imdb %>%
  filter(!is.na(nota_imdb), !is.na(lucro)) %>%
  ggplot(aes(x = nota_imdb, y = lucro)) +
  geom_point(size = 0.1) +
  labs(x = "Nota IMDB", y = "Lucro") +
  scale_y_continuous(labels = scales::dollar_format(big.mark = ".")) +
  stat_smooth(se = TRUE, color = "darksalmon", level = 0.999999)

plotly::ggplotly(grafico_1)

```

> Parece que se a nota é inferiror a uns 7, ela não é muito relacionada ao lucro do filme.
Mas em geral filmes com notas bem altas lucram mais do que os outros.

### Relação entre o orçamento e lucro

```{r, fig.height=3}
imdb %>%
  mutate(
    lucro = lucro/1e6,
    orcamento = orcamento/1000000
  ) %>%
  filter(!is.na(orcamento), !is.na(lucro)) %>%
  ggplot(aes(x = orcamento, y = lucro)) +
  geom_point(size = 0.1) +
  labs(x = "Orçamento (Milhões de Dólares)", y = "Lucro (Milhões de Dólares)") +
  # scale_y_continuous(labels = scales::dollar_format(big.mark = ".")) +
  # scale_x_continuous(labels = scales::dollar_format(big.mark = ".")) +
  stat_smooth(se = TRUE, color = "darksalmon", level = 0.999999)
```


> Filmes com maior orçamento têm maior possibilidade de prejuizo. Essas duas variáveis não são fortemente correlacionadas.

Gêneros
==============================================================
  
  
  Row
---------------------------------------------------------------
  
  ### Lucro por gênero
  
  ```{r}
imdb <- imdb %>%
  mutate(
    dv_acao = str_detect(generos, "Action"),
    dv_aventura = str_detect(generos, "Adventure"),
    dv_drama = str_detect(generos, "Drama"),
    dv_romance = str_detect(generos, "Romance"),
    dv_comedia = str_detect(generos, "Comedy"),
    dv_animacao = str_detect(generos, "Animation"),
    
    lucro = receita - orcamento
  )

imdb_genero <- imdb %>%
  gather(genero, valor, starts_with("dv")) %>%
  filter(valor) %>%
  mutate(
    genero = case_when(
      genero == "dv_acao" ~ "Ação",
      genero == "dv_aventura" ~ "Aventura",
      genero == "dv_drama" ~ "Drama",
      genero == "dv_romance" ~ "Romance",
      genero == "dv_comedia" ~ "Comédia",
      genero == "dv_animacao" ~ "Animação",
      TRUE ~ "Outro gênero"
    )
  )

# criar um boxplot.
# ordenar os boxplots (dos generos) por lucro usando a funcao fct_reorder().
imdb_genero %>%
  mutate(
    genero = fct_reorder(as_factor(genero), lucro, .fun = median, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = genero, y = lucro)) +
  geom_boxplot() +
  scale_y_continuous(label = scales::dollar_format()) +
  labs(x = "Gênero", y = "Lucro") +
  theme_minimal()
```

> O lucro mediano dos filmes parece ser bem parecido entre os principais gêneros. No entanto, parece que alguns gêneros tem bem mais filmes que estouraram.

### Filmes que estouraram

```{r}
calcula_valor_corte <- function(x) {
  quartis <- quantile(x, c(0.25,0.5,0.75), na.rm = TRUE)
  quartis[2] + 2*(quartis[3] - quartis[1])
}

valor_corte <- calcula_valor_corte(imdb$lucro)

imdb_genero %>%
  mutate(
    outlier = lucro > valor_corte
  ) %>%
  group_by(genero) %>%
  summarise(
    outlier = mean(outlier,  na.rm = TRUE)
  ) %>%
  mutate(
    genero = fct_reorder(genero, outlier)
  ) %>%
  ggplot(aes(x = genero, y =outlier)) +
  geom_col(fill = "darksalmon") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_minimal() +
  labs(y = "Percentual de filmes que estouraram", x = "Gênero")


# (depois de conseguir visualizar o gráfico de barras) usar mutate() e fct_reorder() para ordenar as barras. 

```

> Vemos que os filmes de animação tem a maior chance de "estourar" seguidos por aventura e ação.

Diretores {data-orientation=columns}
============================================
  
  Column
-------------------------------------------
  
  ### Diretores com mais filmes
  
  Sabemos que o estúdio quer contratar um(a) diretor(a) experiente, para ter menos riscos. Por isso vamos listar os 10 diretores com maior número de filmes realizados.

```{r}
library(knitr) # para usar a funcao kable(), que faz tabelas bonitas.

# top 10 diretores com mais filmes feitos (na nossa base...)
diretores_experientes <- imdb %>%
  filter(!is.na(diretor)) %>%
  group_by(diretor) %>%
  summarise(`Quantidade de Filmes` = n()) %>%
  top_n(10) %>%
  arrange(desc(`Quantidade de Filmes`))

# a tabela de filmes, mas apenas os filmes dos top 10 diretores mais experientes.
imdb_experientes <- diretores_experientes %>%
  left_join(imdb, by = c("diretor"))

imdb_experientes %>%
  group_by(diretor) %>%
  summarise(
    `Quantidade de Filmes` = n(),
    `Nota média` = mean(nota_imdb, na.rm = TRUE),
    `Orçamento` = mean(orcamento, na.rm = TRUE),
    `Lucro` = mean(lucro, na.rm = TRUE)
  ) %>%
  arrange(desc(`Quantidade de Filmes`)) %>%
  mutate(
    `Nota média` = scales::number(`Nota média`, accuracy = 0.1, decimal.mark=","),
    Orçamento = scales::dollar(Orçamento, big.mark = "."),
    Lucro = scales::dollar(Lucro, big.mark = ".")
  ) %>%
  kable()
```

Column {.tabset}
--------------------------------
  
  ### Notas no IMDB por ano
  
  ```{r fig.height=7}
# imdb_experientes %>%
# ggplot(aes(x = , y = )) +
# colocar pontos (geom)
# ligar pontos com linha (geom)
# colocar reta de tendencia com stat_smooth(method = "lm", se = FALSE, color = "darksalmon")
# fazer um grafico para cada diretor separadamente
# colocar labels melhores: labs(x = "Ano", y = "Nota IMDB")
```

### Lucro por ano

```{r fig.height=7}
# dica1: copie e cole o código anterior.
# dica2: use o scale_y_continuous() e o scales::dollar() para arrumar os rotulos do eixo Y.
```

Atores {data-orientation=columns}
============================================
  
  Column
--------------------------------------------
  
  ### Principais atores
  
  O estúdio prefere um ator com certa experiência, que pode ser medida pelo número de filmes. No entanto, não quer deixar a qualidade de lado - quer os atores de participaram com filmes que tiveram boas avaliações.

```{r}
imdb %>%
  select(ano, nota_imdb, lucro, starts_with("ator")) %>%
  gather(id_ator, ator, starts_with("ator")) %>%
  group_by(Ator = ator) %>%
  summarise(
    n = n(),
    `Nota IMDB` = mean(nota_imdb, na.rm = TRUE),
    `Ano Último Filme` = max(ano, na.rm = TRUE),
    `Lucro` = mean(lucro, na.rm = TRUE)
  ) %>%
  filter(n >= 10) %>%
  filter(row_number(desc(`Nota IMDB`)) <= 15) %>%
  arrange(desc(`Nota IMDB`)) %>%
  mutate(
    `Nota IMDB` = scales::format_format(decimal.mark=",")(round(`Nota IMDB`, 1)),
    Lucro = scales::dollar_format(big.mark = ".")(Lucro)
  ) %>%
  rename(`Qtd Filmes` = n) %>%
  kable()
```

# Column
--------------------------------------
  
  ### Relação Atores e Diretores
  
  Sabemos que em geral os diretores possuem preferência por alguns atores. Por isso,
listamos o(a) ator(atriz) que mais trabalhou em conjunto com cada diretor.

```{r}
# MODO DIFICIL: descricao livre, com menos dicas!

# imdb_experientes %>%
# empilhar as tres colunas de atores.
# contar quantos filmes cada par diretor/ator fizeram juntos
# pegar (filtrar) apenas o ator que mais fez filme com cada diretor
# use kable() para a tabela ficar apresentavel
```















Anotações {data-orientation=columns}
============================================
  
  <h4>Próximos passos</h4>
  
  1. reparar que dá para colocar código HMTL no texto.
2. revisitar os graficos e colocar ggplotly() onde lhe convier.
3. solicitar ao professor para falar sobre graficos waterfall.

<h4>Referências</h4>
  
  - [rmarkdown](https://rmarkdown.rstudio.com/lesson-1.html)
- [rmarkdown book](https://bookdown.org/yihui/rmarkdown/)
- [flexdashboard](https://rmarkdown.rstudio.com/flexdashboard/using.html)
- [kable](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html)
- [bookdown](https://bookdown.org/yihui/bookdown/get-started.html)


Agradecimento {data-orientation=columns}
============================================
  
  <h3>Agradecimento</h3>
  
  <h4>
  A Curso-R agradece a EDP pelo convite, pelo carinho e pelo aprendizado.
</h4>
  
  </br>
  </br>
  <center>
  <div style="width:800px">
  ![](../slides/img/professores.png){width=100%}
</div>
  </center>
  
  
  