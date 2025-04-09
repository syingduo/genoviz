##### https://bioconductor.org/packages/3.7/bioc/vignettes/ComplexHeatmap/inst/doc/s8.oncoprint.html
##### somaticMut.mat
# ,s1,s2,s3
# g1,snv;indel,snv,indel
# g2,,snv;indel,snv
# g3,snv,,indel;snv


# setwd("/Users/scao/Desktop/all/projects/cptac3")

my_args <- commandArgs(trailingOnly = TRUE)
input_file <- my_args[1]
output_file <- my_args[2]

mat <- read.table(input_file, header = T, sep = ",")

mat[, 1] <- NULL
mat <- as.matrix(mat)

library(ComplexHeatmap)

## set outside color

# a6cee3
# 1f78b4
# b2df8a
# 33a02c
# fb9a99
# e31a1c
# fdbf6f
# ff7f00
# cab2d6
# 6a3d9a
# ffff99
# b15928

col <- c(Missense = "#96D84B", In_Frame_Indel = "#00BE7D", Frame_Shift = "#007094", Nonsense = "#353E7C", Splice_Site = "#4B0055", Nonstop = "#009B95", SV = "#F0AB0C", Fus = "#803E19", Amp = "red", Del = "blue")

## set inner color
alter_fun <- list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#E5E5E5", col = NA))
  },
  Missense = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#96D84B", col = NA))
  },
  In_Frame_Indel = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#00BE7D", col = NA))
  },
  Nonsense = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#353E7C", col = NA))
  },
  Nonstop = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#009B95", col = NA))
  },
  Splice_Site = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#4B0055", col = NA))
  },
  Frame_Shift = function(x, y, w, h) {
    grid.rect(x, y, w - unit(0.5, "mm"), h - unit(0.5, "mm"), gp = gpar(fill = "#007094", col = NA))
  }
  # SV = function(x, y, w, h) {
  #  grid.rect(x, y, w-unit(0.5, "mm"), h*0.225, vjust = -1.05, gp = gpar(fill = "#F0AB0C", col = NA))
  # },
  # Amp = function(x, y, w, h) {
  #   grid.rect(x, y, w-unit(0.5, "mm"), h*0.225, vjust = 2.05, gp = gpar(fill = "red", col = NA))
  # },
  # Del = function(x, y, w, h) {
  #  grid.rect(x, y, w-unit(0.5, "mm"), h*0.225, vjust = 2.05, gp = gpar(fill = "blue", col = NA))
  # },
  # Fus = function(x, y, w, h) {
  #  grid.rect(x, y, w-unit(0.5, "mm"), h*0.225, vjust = 1.1, gp = gpar(fill = "#803E19", col = NA))
  # }
)

## set sample group
# df = data.frame(type = c(rep("Primary", 23), rep("Relapsed", 23)))
# ha = HeatmapAnnotation(df = df, col = list(type = c("Primary" =  "blue", "Relapsed" = "red")), annotation_legend_param = list(type = list(title = "")))

## set plot

ht <- oncoPrint(mat,
  get_type = function(x) strsplit(x, ";")[[1]],
  alter_fun = alter_fun,
  col = col,
  # row_order = NULL,
  # column_order = sample_order,
  # top_annotation = HeatmapAnnotation(cbar = anno_oncoprint_barplot(),
  # foo1 = 1:172,
  # bar1 = anno_points(1:172)),
  show_column_names = TRUE,
  # printSamples = T,
  # bottom_annotation = ha,
  # bottom_annotation_height = unit(2, "mm")
  # remove_empty_columns = TRUE,
  heatmap_legend_param = list(title = "Mutations", nrow = 10)
)
# %v%
# 	Heatmap(matrix(rnorm(ncol(mat)*10), nrow = 10), name = "expr", height = unit(4, "cm"))

# print(rownames(ht))

# row=ht$rowInd
# col=ht$colInd

# m=mat[row,col]

# write.table(m,file=output_csv, append=FALSE, quote=F,sep="\t", eol="\n", row.names=TRUE, col.names=TRUE)

## draw plot
pdf(output_file, width = 24, height = 8)
draw(ht, annotation_legend_side = "bottom")
# draw(ht, heatmap_legend_side = "left")
dev.off()
