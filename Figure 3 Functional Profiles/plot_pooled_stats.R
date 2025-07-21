# Configurations --------------------------------------------------------------
graphics.off() # clear plots
rm(list = ls()) # clear global environment
cat("\014") # clear console
set.seed(1) # seed random number generator

# Set working directory -------------------------------------------------------
setwd('/Users/swafa/Documents/mea-ml-phenotyping/Saved Data')

# Load libraries --------------------------------------------------------------
library(ggplot2)
library(circlize)
library(ComplexHeatmap)

# Load data -------------------------------------------------------------------
features = read.csv("pooled_stats_features.csv",
                stringsAsFactors=FALSE,
                header=FALSE)

fs = 17.5 # fontsize

pvals = read.csv("pooled_stats.csv",
                 stringsAsFactors=FALSE,
                 header=FALSE)

fs = data.frame(c(features$V1, features$V1))
colnames(fs) = 'Feature'

ps = data.frame(c(pvals$V1, pvals$V2))
colnames(ps) = 'p'

fdf = data.frame(fs, ps)
fdf_nrows = nrow(fdf)

lf = nrow(features)
fdf$Feature = factor(fdf$Feature, levels=features$V1[rev(1:lf)])
fdf$Significance = NA
fdf$log10_p = -log10(fdf$p)
fdf$Effect = data.frame(c(rep('Genotype', fdf_nrows/2),
                          rep('Genotype x Time', fdf_nrows/2)))

for (i in 1:fdf_nrows){
  if (fdf$p[i] > 0.05/82) {
    fdf$Significance[i] = 'NS'
  } else {
    fdf$Significance[i] = 'p<=0.00061'
  }
}
fdf$Significance = factor(fdf$Significance, levels=c('NS', 'p<=0.00061'))

colnames(fdf[, 5]) = 'Effect'

p = ggplot(data=fdf, aes(x=-log10(p), y=Feature, col=Significance)) +
  geom_point(size=10) +
  scale_color_manual(name='Significance', 
                     values=c("#404040", "#4dac26")) +
  scale_y_discrete(position="right") +
  theme_bw() +
  xlab(expression(-log[10](p*"-"*value))) +
  facet_grid(. ~ Effect) +
  xlim(-1, 70) +
  theme(text=element_text(size=20),
        strip.background=element_blank(),
        strip.text.x=element_text(size=20),
        axis.title.y=element_blank(),
        legend.justification=c('right', 'top'),
        axis.text.x=element_text(colour="black", size=17.5),
        axis.text.y=element_text(colour="black", size=17.5)
        #axis.ticks=element_blank()
        ) +
  theme(legend.position="none") +
  geom_vline(xintercept=-log10(0.05 / 82), 
             linetype="solid", # 'solid', 'dashed', 'longdash', 'dotted'
             linewidth=2,
             color="#4dac26")

p

# Width = 1260, Height = 1500