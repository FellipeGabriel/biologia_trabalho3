# Trabalho 3 de Biologia Computacional

Este repositório contém o código e os dados do Trabalho 3 da disciplina. O objetivo do trabalho é analisar duas redes biológicas em R usando o pacote igraph, estudando estrutura, decomposição em K core, ataque direcionado, falha aleatória e comparação final entre as redes.

## Como abrir o projeto

Basta clonar o repositório e abrir o arquivo `biologia_trabalho3.Rproj` no RStudio. Ele já configura o diretório de trabalho automaticamente.

Antes de rodar os scripts, instale os pacotes necessários caso ainda não tenha:

```r
install.packages(c("igraph", "graphlayouts", "ragg"))
```

O `igraph` é a biblioteca principal de análise de redes. O `graphlayouts` fornece algoritmos de layout otimizados para redes grandes, usados na geração das figuras coloridas por coreness. O `ragg` é um device gráfico mais eficiente que o padrão do Windows, importante para salvar as figuras em PNG sem demora.

## Datasets

Os dois datasets já estão versionados no repositório. Eles foram obtidos do Network Repository.

A rede `bio-dmela` está na pasta `bio-dmela/` e é uma rede de interação proteica da Drosophila melanogaster.

A rede `bio-HS-HT` está na pasta `bio-HS-HT/` e é uma rede de associação funcional entre genes humanos.

## Estrutura de pastas

A pasta `R/` guarda os scripts numerados por etapa do trabalho. A pasta `R/output/figuras/` guarda as figuras geradas. A pasta `R/output/tabelas/` guarda as tabelas geradas.
