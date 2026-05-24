
#' Este script acompanha o "Exercício 3", carregando no RStudio sugestões de  
#' dados indicados na tarefa EaD3, juntamente com sugestões de análise.

################################################################################
### Instalação de pacotes necessários para este script
################################################################################
install.packages("igraph")
install.packages("ggplot2")
install.packages("knitr")
install.packages("rmarkdown")
install.packages("remotes")
remotes::install_github("sysbiolab/RGraphSpace", build_vignettes=TRUE)

################################################################################
### Script Mínimo: Decomposição K-core
################################################################################
library(igraph)
library(RGraphSpace)
library(ggplot2)

#-------------------------------------------------------------------------------
# Supondo que 'g' seja o grafo já importado e simplificado
# (Usaremos um grafo de exemplo 'Zachary' para ilustrar o código)
g <- make_graph("Zachary")

#-------------------------------------------------------------------------------
# --- CÁLCULO DE MÉTRICAS ---

# Calcular o 'coreness' de cada nó
v_coreness <- coreness(g)

# Identificar o valor do K-core máximo (o "núcleo" da rede)
k_max_val <- max(v_coreness)
cat("O valor do K-core máximo desta rede é:", k_max_val, "\n")

# Filtrar os nós que pertencem ao K-core máximo
nodes_in_core <- V(g)[v_coreness == k_max_val]
cat("Número de nós no núcleo máximo:", length(nodes_in_core), "\n")

# Cálcular Betweenness (INTERMEDIAÇÃO)
# O Betweenness mede quantas vezes um nó está no caminho mais curto entre outros dois.
# É a métrica ideal para identificar "pontes" e gargalos na rede.
v_betweenness <- betweenness(g, directed = FALSE)

#-------------------------------------------------------------------------------
# Adicionar variáveis no objeto igraph
V(g)$coreness <- v_coreness
V(g)$betweenness <- v_betweenness

#-------------------------------------------------------------------------------
# --- VISUALIZAÇÃO COM GGPLOT2 + RGRAPHSPACE ---

# Criar o espaço do grafo com layout de força (Fruchterman-Reingold)
gs <- GraphSpace(g, layout = layout_with_fr(g))

# Plotagem customizada
ggplot() +
    geom_edgespace(data = gs) +
    geom_nodespace(mapping = aes(fill = coreness, size = betweenness),
        data = gs) +
    scale_fill_viridis_c() +
    scale_size(range = c(2, 10)) +
    theme_gspace_coords() +
    labs(title = "Análise Hierárquica e de Intermediação",
        subtitle = paste("K-max identificado:", k_max_val))

