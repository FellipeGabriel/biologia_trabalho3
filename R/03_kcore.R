library(igraph)
library(graphlayouts)

g_dmela <- readRDS("R/output/redes/g_dmela.rds")
g_hs_ht <- readRDS("R/output/redes/g_hs_ht.rds")

# função genérica: faz toda a análise k-core de uma rede e devolve em lista
analisar_kcore <- function(g, nome) {
  cor <- coreness(g)
  k_max <- max(cor)
  nos_no_core <- V(g)[cor == k_max]
  sub_core <- induced_subgraph(g, nos_no_core)
  graus <- sort(degree(sub_core), decreasing = TRUE)
  top5 <- head(graus, 5)

  cat("\nRede:", nome, "\n")
  cat("  k máximo:", k_max, "\n")
  cat("  nós no k máximo:", length(nos_no_core), "\n")
  cat("  top 5 nós (grau dentro do núcleo):\n")
  print(top5)

  list(rede = nome, coreness = cor, k_max = k_max,
       nos_no_core = nos_no_core, top5 = top5)
}

# aplica nas duas redes
resultado_dmela <- analisar_kcore(g_dmela, "bio-dmela")
resultado_hs_ht <- analisar_kcore(g_hs_ht, "bio-HS-HT")

# cache: salva o resultado completo para as próximas etapas usarem
dir.create("R/output/redes", showWarnings = FALSE, recursive = TRUE)
saveRDS(resultado_dmela, "R/output/redes/kcore_dmela.rds")
saveRDS(resultado_hs_ht, "R/output/redes/kcore_hs_ht.rds")

# tabela top 5 para o relatório
top5_tabela <- data.frame(
  rede = c(rep("bio-dmela", 5), rep("bio-HS-HT", 5)),
  no = c(names(resultado_dmela$top5), names(resultado_hs_ht$top5)),
  grau_no_core = c(resultado_dmela$top5, resultado_hs_ht$top5)
)
dir.create("R/output/tabelas", showWarnings = FALSE, recursive = TRUE)
write.csv(top5_tabela, "R/output/tabelas/top5_kcore.csv", row.names = FALSE)

# abre device de png mais rápido disponível: ragg > cairo > padrão
abrir_png <- function(arquivo, w = 1600, h = 1600, res = 150) {
  if (requireNamespace("ragg", quietly = TRUE)) {
    ragg::agg_png(arquivo, width = w, height = h, res = res)
  } else {
    png(arquivo, width = w, height = h, res = res, type = "cairo")
  }
}

# função de plot: extrai LCC, faz layout sparse stress, salva png com
# tempo medido por etapa para diagnóstico
plotar_coreness <- function(g, cor, nome, arquivo) {
  t_inicio <- Sys.time()

  cat(sprintf("[%s] extraindo maior componente conectada...\n", nome))
  t0 <- Sys.time()
  comp <- components(g)
  maior <- which.max(comp$csize)
  mask <- comp$membership == maior
  g_lcc <- induced_subgraph(g, V(g)[mask])
  cor_lcc <- cor[mask]
  pct <- round(100 * vcount(g_lcc) / vcount(g), 1)
  cat(sprintf("[%s] LCC: %d nós (%s%%) | %ss\n",
              nome, vcount(g_lcc), pct,
              round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)))

  cat(sprintf("[%s] calculando layout...\n", nome))
  t0 <- Sys.time()
  set.seed(42)
  layout_g <- layout_with_sparse_stress(g_lcc, pivots = 100)
  cat(sprintf("[%s] layout pronto | %ss\n",
              nome, round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)))

  paleta <- colorRampPalette(c("#fff7bc", "#fec44f", "#d95f0e", "#990000"))(max(cor_lcc))
  V(g_lcc)$color <- paleta[pmax(cor_lcc, 1)]

  cat(sprintf("[%s] renderizando png...\n", nome))
  t0 <- Sys.time()
  abrir_png(arquivo)
  plot(g_lcc,
       layout = layout_g,
       vertex.label = NA,
       vertex.size = 2,
       vertex.frame.color = NA,
       edge.color = adjustcolor("gray40", alpha.f = 0.3),
       edge.width = 0.3,
       main = paste("Coreness:", nome, "(componente maior)"))
  dev.off()
  cat(sprintf("[%s] png salvo | %ss\n",
              nome, round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)))

  dt <- round(as.numeric(difftime(Sys.time(), t_inicio, units = "secs")), 1)
  cat(sprintf("[%s] total: %ss\n\n", nome, dt))
}

dir.create("R/output/figuras", showWarnings = FALSE, recursive = TRUE)
plotar_coreness(g_dmela, resultado_dmela$coreness, "bio-dmela",
                "R/output/figuras/kcore_dmela.png")
plotar_coreness(g_hs_ht, resultado_hs_ht$coreness, "bio-HS-HT",
                "R/output/figuras/kcore_hs_ht.png")
