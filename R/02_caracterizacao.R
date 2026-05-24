library(igraph)

g_dmela <- readRDS("output/redes/g_dmela.rds")
g_hs_ht <- readRDS("output/redes/g_hs_ht.rds")

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

tabela <- rbind(
  caracterizar(g_dmela, "bio-dmela"),
  caracterizar(g_hs_ht, "bio-HS-HT")
)

print(tabela)

dir.create("output/tabelas", showWarnings = FALSE, recursive = TRUE)
write.csv(tabela, "output/tabelas/caracterizacao_basica.csv", row.names = FALSE)
