# Configurations --------------------------------------------------------------
graphics.off() # clear plots
rm(list = ls()) # clear global environment
cat("\014") # clear console
set.seed(1) # seed random number generator

# Set working directory -------------------------------------------------------
setwd("/Users/swafa/Documents/mea-ml-phenotyping/Saved Data")

# Load libraries --------------------------------------------------------------
library(ggplot2)
library(circlize)
library(ComplexHeatmap)

# Load data -------------------------------------------------------------------
time = read.csv("time.csv",
                 stringsAsFactors=FALSE,
                 header=FALSE)

time = data.frame(t(time))

features = read.csv("patient_heatmap_features.csv",
                stringsAsFactors=FALSE,
                header=FALSE)

mdf = read.csv("patient_heatmap_activity.csv",
                stringsAsFactors=FALSE,
                header=FALSE)

mdf = data.frame(data.matrix(mdf))
row_features = features$V1
rownames(mdf) = row_features
colnames(mdf) = c(9, '', '', '', '', '', 15, '', '', '', '', '',
                  '', '', '', '', 25, '', '', '', '', '', '',
                  '', '', '', 35,
                  9, '', '', '', '', '', 15, '', '', '', '', '',
                  '', '', '', '', 25, '', '', '', '', '', '',
                  '', '', '', 35,
                  9, '', '', '', '', '', 15, '', '', '', '', '',
                  '', '', '', '', 25, '', '', '', '', '', '',
                  '', '', '', 35,
                  9, '', '', '', '', '', 15, '', '', '', '', '',
                  '', '', '', '', 25, '', '', '', '', '', '',
                  '', '', '', 35,
                  9, '', '', '', '', '', 15, '', '', '', '', '',
                  '', '', '', '', 25, '', '', '', '', '', '',
                  '', '', '', 35)

split_columns = c(rep('Q2-01', 27),
                  rep('Q2-03', 27),
                  rep('Q2-04', 27),
                  rep('Q2-07', 27),
                  rep('Q2-17', 27)
                  )
split_columns = factor(split_columns,
                       levels=c('Q2-01', 'Q2-03', 'Q2-04', 'Q2-07', 'Q2-17'))

minlimit = -1
maxlimit = 1
nout = 11

myColor = colorRamp2(seq(from=minlimit, to=maxlimit, length.out=nout),
                     c("#313695", "#4575b4", "#74add1", "#abd9e9", "#e0f3f8",
                       "#ffffff",
                       "#fee090", "#fdae61", "#f46d43", "#d73027", "#a50026"))

border_color = 'grey60'
fs = 30 # fontsize

p = ComplexHeatmap::pheatmap(
  data.matrix(mdf),
  name='Scaled difference',
  col=myColor,
  border_color=NA,
  cluster_rows=FALSE,
  cluster_cols=FALSE,
  show_rownames=TRUE,
  show_colnames=TRUE,
  column_gap=unit(12, "mm"),
  column_split=split_columns, 
  show_parent_dend_line=FALSE,
  labels_row=row_features,
  labels_col=colnames(mdf),
  fontsize=fs,
  angle_col='0',
  fontsize_col=gpar(fontsize=fs),
  border=TRUE,
  row_names_max_width=max_text_width(
    rownames(mdf), gp=gpar(fontsize=fs)),
  row_title=NA,
  row_title_side="left",
  row_title_gp=gpar(fontsize=fs, fontface='bold'),
  row_title_rot=90,
  column_title=NA,
  column_title_side="bottom",
  column_title_gp=gpar(fontsize=fs, fontface='bold'),
  legend=FALSE,
  heatmap_legend_param=list(
    legend_direction="vertical", 
    legend_width=unit(6, "cm"),
    legend_height=unit(6, "cm"),
    at=c(minlimit, 0, maxlimit),
    labels=c('<=-1', '0', '>=+1'),
    border='black',
    title_position="leftcenter-rot",
    title_gp=gpar(fontsize=30, fontface='bold'),
    labels_gp=gpar(fontsize=0)
  )
)
p

# Width = 3000, Height = 1500