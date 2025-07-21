# Configurations --------------------------------------------------------------
graphics.off() # clear plots
rm(list = ls()) # clear global environment
cat("\014") # clear console
set.seed(1) # seed random number generator

# Set working directory -------------------------------------------------------
setwd("/Users/swafa/Documents/mea-ml-phenotyping/Saved Data")

library(slingshot, quietly=FALSE)
library(Seurat)
library(scales)

# Load data -------------------------------------------------------------------
s = read.csv("seurat_df.csv",
             stringsAsFactors=FALSE,
            header=FALSE)
s = data.matrix(s)
rownames(s) <- paste0('feat_', 1:41)
colnames(s) <- paste0('obs_', 1:4860)
so <- CreateSeuratObject(counts=s)

t = read.csv("seurat_time.csv",
             stringsAsFactors=FALSE,
             header=FALSE)
t = as.numeric(as.matrix(t))

rd = read.csv("seurat_tphate.csv",
              stringsAsFactors=FALSE,
              header=FALSE)
rd = data.matrix(rd[, 1:3])
rownames(rd) <- paste0('obs_', 1:4860)
colnames(rd) <- paste0('dim_', 1:3)

so[["tphate"]] <- CreateDimReducObject(
  embeddings=rd, 
  key="dim_",
  assay=DefaultAssay(so))

data <- FindNeighbors(so, reduction='tphate', dims=1:3, 
                      k.param=29, prune.SNN=0.001)
data <- FindClusters(object=data, resolution=1, algorithm=1)

dimred <- data@reductions$tphate@cell.embeddings
clustering <- data$RNA_snn_res.1

rd = dimred
cl = as.numeric(clustering)

pal = hue_pal()(nlevels(clustering))
# pal = pal[sample(1:nlevels(clustering))]

plot(dimred[, 1:2], col=pal[clustering], cex = 0.5, pch = 16)
for (i in levels(clustering)) {
  n = as.numeric(i)
  text(mean(dimred[cl==as.numeric(levels(clustering)[n + 1]), 1]),
       mean(dimred[cl==as.numeric(levels(clustering)[n + 1]), 2]),
       labels=i,
       font=2)
}

write.csv(data.frame(cl), "seurat_louvain_clusters.csv", row.names=FALSE)

lineages <- getLineages(rd, cl,
                        start.clus=c('26', '26', '26', '26', '26', '26'),
                        end.clus=c('18', '4', '5', '11', '1', '8'),
                        times=t,
                        use.median=TRUE
)

#par(mfrow = c(1, 2))
#plot(dimred[, 1:2], col=pal[clustering], cex = 0.5, pch = 16)
#for (i in levels(clustering)) {
#  text(mean(dimred[clustering == i, 1]), mean(dimred[clustering == i, 2]), labels = i, font = 2)
#}
plot(dimred[, 1:2], col = pal[clustering], cex = 0.5, pch = 16)
lines(SlingshotDataSet(lineages), lwd = 3, col = "black")