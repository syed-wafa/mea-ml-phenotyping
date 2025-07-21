# Configurations --------------------------------------------------------------
graphics.off() # clear plots
rm(list = ls()) # clear global environment
cat("\014") # clear console
set.seed(1) # seed random number generator

# Set working directory -------------------------------------------------------
setwd("/Users/swafa/Documents/mea-ml-phenotyping/Saved Data")

# Load libraries --------------------------------------------------------------
library(circlize)
library(RColorBrewer)
library(ComplexHeatmap)

# Load data -------------------------------------------------------------------
time = read.csv("time.csv",
                 stringsAsFactors=FALSE,
                 header=FALSE)

time = data.frame(t(time))

features = read.csv("pooled_heatmap_features.csv",
                stringsAsFactors=FALSE,
                header=FALSE)

df = read.csv("pooled_heatmap_activity.csv",
                stringsAsFactors=FALSE,
                header=FALSE)

df = data.frame(data.matrix(df))
rownames(df) = features$V1
colnames(df) = c(9, '', '', '', '', '', 15, '', '', '', '', 20,
                 '', '', '', '', 25, '', '', '', '', 30, '',
                 '', '', '', 35)

xlabel = expression(paste('Time (days ', italic('in vitro'), ')'))
fs = 17.5 # fontsize

# Load performance ------------------------------------------------------------

#colors = #33A02C, #D01C8B, #00BFC4, #F8766D

minlimit = -1
maxlimit = 1
nout = 11

myColor = colorRamp2(seq(from=minlimit, to=maxlimit, length.out=nout),
                     c("#313695", "#4575b4", "#74add1", "#abd9e9", "#e0f3f8",
                       "#ffffff",
                       "#fee090", "#fdae61", "#f46d43", "#d73027", "#a50026"))

# myColor = colorRamp2(seq(from=minlimit, to=maxlimit, length.out=nout),
#                      c('#000080', '#333399', '#6666B3', '#9999CC', '#CCCCE6',
#                        '#FFFFFF',
#                        '#F5D4D4', '#EBA8A8', '#E17D7D', '#D75151', '#CD2626')
# )

border_color = 'grey60'

p = ComplexHeatmap::pheatmap(data.matrix(df),
                             name='Scaled difference',
                             col=myColor,
                             border=TRUE,
                             border_color='grey60',
                             cluster_rows=TRUE,
                             cluster_cols=FALSE,
                             show_rownames=TRUE,
                             clustering_method='ward.D2',
                             clustering_distance_rows='euclidean',
                             treeheight_row=unit(2, "cm"),
                             column_title=expression(paste('Time (days ', italic('in vitro'), ')')),
                             column_title_side='bottom',
                             column_title_gp=gpar(fontsize=23.3, fontface='bold'),
                             labels_row=rownames(df),
                             labels_col=colnames(df),
                             fontsize=fs,
                             fontsize_row=gpar(fontsize=fs),
                             angle_col='0',
                             row_names_max_width=max_text_width(
                              rownames(df), gp=gpar(fontsize=fs)),
                             heatmap_legend_param=list(
                               legend_direction="horizontal", 
                               legend_width=unit(4, "cm"),
                               legend_height=unit(8, "cm"),
                               at=c(-1, 0, +1),
                               labels=c('<-1', '0', '>+1'),
                               border='black',
                               title_position="topcenter",
                               title_gp=gpar(fontsize=fs),
                               labels_gp=gpar(fontsize=fs)
                             )
)
draw(p, heatmap_legend_side="top", legend_grouping="original")

# width=1100, height=1165 ## width=1000, height=1000