library(igraph)

# carrega os grafos limpos gerados pelo script 01
g_dmela <- readRDS("R/output/redes/g_dmela.rds")
g_hs_ht <- readRDS("R/output/redes/g_hs_ht.rds")

# calcula as metricas basicas de uma rede e devolve como linha de tabela
caracterizar <- function(g, nome) {
  data.frame(
    rede = nome,
    ordem = vcount(g),
    arestas = ecount(g),
    densidade = edge_density(g),
    diametro = diameter(g, directed = FALSE, unconnected = TRUE),
    transitividade = transitivity(g, type = "global"),
    assortatividade = assortativity_degree(g, directed = FALSE)
  )
}

# monta a tabela comparativa das duas redes
tabela <- rbind(
  caracterizar(g_dmela, "bio-dmela"),
  caracterizar(g_hs_ht, "bio-HS-HT")
)

print(tabela)

# salva como csv para o relatorio
dir.create("R/output/tabelas", showWarnings = FALSE, recursive = TRUE)
write.csv(tabela, "R/output/tabelas/caracterizacao_basica.csv", row.names = FALSE)
