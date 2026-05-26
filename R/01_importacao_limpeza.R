library(igraph)

# le arquivo no formato Matrix Market (bio-dmela.mtx)
ler_grafo_mtx <- function(caminho) {
  linhas <- readLines(caminho)
  linhas <- linhas[!grepl("^%", linhas)]      # remove linhas de comentario
  linhas <- linhas[nzchar(trimws(linhas))]    # remove linhas vazias
  arestas <- read.table(text = linhas[-1], header = FALSE)  # pula linha de dimensoes
  graph_from_data_frame(arestas[, 1:2], directed = FALSE)
}

# le arquivo no formato edge list (bio-HS-HT.edges) e ignora a coluna de peso
ler_grafo_edges <- function(caminho) {
  arestas <- read.table(caminho, header = FALSE)
  graph_from_data_frame(arestas[, 1:2], directed = FALSE)
}

# carrega as duas redes
g_dmela <- ler_grafo_mtx("bio-dmela/bio-dmela.mtx")
g_hs_ht <- ler_grafo_edges("bio-HS-HT/bio-HS-HT.edges")

# diagnostico antes da limpeza
cat("Antes da limpeza:\n")
cat("  bio-dmela:", vcount(g_dmela), "nós,", ecount(g_dmela), "arestas, direcionada =", is_directed(g_dmela), "\n")
cat("  bio-HS-HT:", vcount(g_hs_ht), "nós,", ecount(g_hs_ht), "arestas, direcionada =", is_directed(g_hs_ht), "\n")

# remove loops e arestas multiplas
g_dmela <- simplify(g_dmela, remove.multiple = TRUE, remove.loops = TRUE)
g_hs_ht <- simplify(g_hs_ht, remove.multiple = TRUE, remove.loops = TRUE)

# diagnostico depois da limpeza
cat("Depois da limpeza:\n")
cat("  bio-dmela:", vcount(g_dmela), "nós,", ecount(g_dmela), "arestas\n")
cat("  bio-HS-HT:", vcount(g_hs_ht), "nós,", ecount(g_hs_ht), "arestas\n")

# salva os grafos limpos como cache para as proximas etapas reaproveitarem
dir.create("R/output/redes", showWarnings = FALSE, recursive = TRUE)
saveRDS(g_dmela, "R/output/redes/g_dmela.rds")
saveRDS(g_hs_ht, "R/output/redes/g_hs_ht.rds")
