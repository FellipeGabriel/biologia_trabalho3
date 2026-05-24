library(igraph)

ler_grafo_mtx <- function(caminho) {
  linhas <- readLines(caminho)
  linhas <- linhas[!grepl("^%", linhas)]
  linhas <- linhas[nzchar(trimws(linhas))]
  arestas <- read.table(text = linhas[-1], header = FALSE)
  graph_from_data_frame(arestas[, 1:2], directed = FALSE)
}

ler_grafo_edges <- function(caminho) {
  arestas <- read.table(caminho, header = FALSE)
  graph_from_data_frame(arestas[, 1:2], directed = FALSE)
}

g_dmela <- ler_grafo_mtx("bio-dmela/bio-dmela.mtx")
g_hs_ht <- ler_grafo_edges("bio-HS-HT/bio-HS-HT.edges")

cat("Antes da limpeza:\n")
cat("  bio-dmela:", vcount(g_dmela), "nós,", ecount(g_dmela), "arestas, direcionada =", is_directed(g_dmela), "\n")
cat("  bio-HS-HT:", vcount(g_hs_ht), "nós,", ecount(g_hs_ht), "arestas, direcionada =", is_directed(g_hs_ht), "\n")

g_dmela <- simplify(g_dmela, remove.multiple = TRUE, remove.loops = TRUE)
g_hs_ht <- simplify(g_hs_ht, remove.multiple = TRUE, remove.loops = TRUE)

cat("Depois da limpeza:\n")
cat("  bio-dmela:", vcount(g_dmela), "nós,", ecount(g_dmela), "arestas\n")
cat("  bio-HS-HT:", vcount(g_hs_ht), "nós,", ecount(g_hs_ht), "arestas\n")

dir.create("output/redes", showWarnings = FALSE, recursive = TRUE)
saveRDS(g_dmela, "output/redes/g_dmela.rds")
saveRDS(g_hs_ht, "output/redes/g_hs_ht.rds")
