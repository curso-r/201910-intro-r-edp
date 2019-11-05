# Projeto no R (.Rproj): o ícone de cubo azul
# RStudio e os 4 quadrantes

# Nome dos objetos/variáveis ----------------------------------------------

# Criando objetos/variáveis -----------------------------------------------

obj <- 1
obj = 1
obj
meus_dados <- mtcars

# também dizemos 'guardando as saídas'
y = seq(1, 10, length.out = 5)
y

# ATALHO para rodar o código: CTRL + ENTER
# ATALHO para a <- : ALT - (alt menos)

# O R difencia minúscula de maiúscula!

a <- 5
A <- 42

# Os nomes devem começar com uma letra. Podem conter letras, números, _ e .

eu_uso_snake_case
outrasPessoasUsamCamelCase
algumas.pessoas.usam.pontos
E_algumasPoucas.Pessoas_RENUNCIAMconvenções

# Vetores -----------------------------------------------------------------

# Vetores são conjuntos ordenados de números

c(1, 4, 3, 10)

1:10

# Subsetting

vetor <- c(4, 8, 15, 16, 23, 42)

vetor[1]
vetor[-5]

vetor[ c(1, 3)]
vetor[-c(1, 3)]



vetor
vetor[ c(1, 3)]
vetor[-c(1, 3)]




# exercícios:
# 1) crie um vetor de 0 a 5 e guarde num objeto 
# chamado 'zero_a_cinco'
# dica: usar o operador : (1:10)
zero_a_cinco <- 0:5

# 2) extraia apenas os números 0 e 5 desse vetor
zero_a_cinco[c(1, 6)]


# Tipos -------------------------------------------------------------------

# Numéricos (numeric)

a <- 10
class(a)

# Caracteres (character, strings)

obj <- "a"
obj <- '1'
obj2 <- c("masculino", "a")
letters
LETTERS[-1]
class(obj2)

# lógicos (logical, booleanos)

verdadeiro <- TRUE
falso <- FALSE

class(falso)

# Bases (data.frame)

mtcars
class(mtcars)

# o operador $
mtcars$mpg

# exercício 1: na linha debaixo, coloque o $ e aperte TAB
mtcars$disp

# exercício 2: selecione a coluna 'cyl' usando o $ e 
# depois extraia os valores de 4 a 8
mtcars[c(4:8), ]
mtcars$cyl[c(4, 5, 6, 7, 8)]

# Funções -----------------------------------------------------------------

# Argumentos e ordem

seq(to = 10, from = 1, by = 2)
seq(1, 10, 2)

# Funções dentro de funções

mean(seq(1, 10, 2))

# Guardando as saídas

y <- seq(1, 10, length.out = 5)
y

mean(seq(1, 10, length.out = 5) + 5)

# exercícios:
# 1) use a funcao 'sum' para somar os valores de 1 a 100
sum(1:100)

# 2) agora some os valores da coluna mpg do banco de dados mtcars (dica: use o $)
sum(mtcars$mpg)

# Criando funções

minha_soma <- function(x, y) {
  
  x + y
  
}

minha_soma(2, 3)

# Retornando explicitamente

minha_soma2 <- function(x, y) {
  
  x <- x^2
  y <-y^2
  
  soma <- x + y
  
  return(soma)
  
}

minha_soma2(1, 2)

# Comparações lógicas ------------------------------------------------------

1 > 0
2 < 1
3 == 3
3 != 1
6 %in% c(2, 4, 5)
estados_importantes <- c("SP", "SP", "ES", "RS")
!estados_importantes %in% c("SP", "RJ", "ES")

# e também
!5 %in% c(2, 4, 5)
1 >= 1
2 <= 1

# exercício: crie um vetor de números e veja o que acontece se você fizer
# uma comparação lógica com ele.
vetor <- c(2, 3, 5) 
vetor %in% c(1,2,3)

x <- "conv"
energia_da_proposta <- c("conv", 5, 1)
x %in% energia_da_proposta
energia_da_proposta %in% x
vetor > 3
idade <- c(40, 20, 30)
idade > 30

# Valores especiais -------------------------------------------------------

# Existem valores reservados para representar dados faltantes, 
# infinitos, e indefinições matemáticas.

NA   # (Not Available) significa dado faltante/indisponível. 

NaN  # (Not a Number) representa indefinições matemáticas, como 0/0 e log(-1). 
# Um NaN é um NA, mas a recíproca não é verdadeira.

Inf  # (Infinito) é um número muito grande ou o limite matemático, por exemplo, 
# 1/0 e 10^310. Aceita sinal negativo -Inf.

NULL # representa a ausência de informação.


# Comparação lógica com valores especiais --------------------------------
# Use as funções is.na(), is.nan(), is.infinite() e is.null() 
# para testar se um objeto é um desses valores.

x <- c("olá", "", NA, "tchau")
x == NA
is.na(x)

a <- c(1, 2, 3, NA, 5)
is.na(a)

zero_dividido_por_zero <- 0/0
zero_dividido_por_zero == NaN
is.nan(zero_dividido_por_zero)

# família de funções que começam com is.*()
is.numeric()
is.character()
is.data.frame()
is.logical()
is.na()
is.nan()
is.null()

# Identação ---------------------------------------------------------------

funcao_com_muitos_argumentos(
  argumento_1 = 10, 
  argumento_2 = 14, 
  argumento_3 = 30, 
  argumento_4 = 11
)

# ATALHO: CTRL+I

# Pacotes -----------------------------------------------------------------

# Para instalar pacotes

install.packages("tidyverse")
install.packages("dplyr")
install.packages(c("readxl", "writexl", "rmarkdown", "devtools", "RSQLite", "jsonlite", "purrr"))

# Para carregar pacotes

library(dplyr)

# Também é possível acessar as funções usando ::

dplyr::tbl_vars()

# No dia a dia:
# Instala o pacote APENAS uma vez. (install.packages("pacote"))
# Carrega o pacote sempre que for precisar nas análises. (library(pacote))


# Operações vetoriais  -----------------------------------------------------

a <- 1:4
b <- 4:9

a + 1
a ^ 2
b * 5
b / b
a * a

a + b
b * a

# exercícios:
# 1) crie um vetor 'mpg2' que receba a coluna 'mpg' 
# do mtcars, mas com seus valores ao quadrado
mpg2 <- mtcars$mpg^2


# Coerção ------------------------------------------------------------------
class(c(1, 2, 3))
class(c("a", "b", "c"))
class(c(TRUE, TRUE, FALSE))

# misturando diferentes classes...
c(1, 2, 3, "a")
c(TRUE, FALSE, "a")
c(1L, "a", "2")
c(TRUE, FALSE, 1, 0)

c("1,2", "1,6", "14,5")

# logico < inteiro < numerico < caracter

#-----------------------------------------------------------------------
# uma das coerções mais importantes: lógico para numérico
x <- 1:10

x < 4
as.numeric(x < 4)
sum(x < 4) # soma de vetores lógicos é a mesma coisa que contagem.
mean(x < 4) # média de vetores lógicos é a mesma coisa que proporção.

x[x < 4]
sum(x[x < 4])

# exemplo mais complexo!
mtcars$mpg[mtcars$wt >= 3]

# logico < inteiro < numerico < caracter

# exercícios:
# 1) crie um vetor lógico 'maior_que_300' que indique se o vetor mpg2 é maior que 300.
maior_que_300 <- mpg2 > 300

# 2) calcule a soma de maior_que_300 (utilize a função sum()).
sum(maior_que_300)



# Categorização ------------------------------------------------------------

x <- -10:30

x_categorizado <- ifelse(x < 0, "negativo", ifelse(x < 10, "menor que 10", "menor que 10"))

x_categorizado <- case_when(
  x < 0 & y == 3 | idade > 40 ~ "negativo",
  x == 0 ~ "zero",
  x < 10 ~ log(x + y)/media(idade),
  TRUE ~ "GRUPO GENERICO"
)