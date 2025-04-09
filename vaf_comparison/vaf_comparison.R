#!/bin/Rscript

## set up dirctory and load packages
library(stringr)
library(Rmisc)
library(ggplot2)
library(ggrepel)
library(grid)
setwd("/storage1/fs1/dinglab/Active/Projects/yingduo/gdan/kirc/smg/wxs_wgs")

## read in data
input <- "/storage1/fs1/dinglab/Active/Projects/yingduo/gdan/kirc/smg/wxs_wgs/all"
b <- list()
n <- 0
samples <- unique(word(list.files(input), sep = fixed("_"), 1))
# samples <- samples[samples != "MILD-B5AS"]
for (i in samples) {
    a <- list()
    for (j in list.files(input)[str_detect(list.files(input), i)]) {
        file <- list.files(paste0(input, "/", j))[str_detect(list.files(paste0(input, "/", j)), "T.rc.vaf")]
        dat <- read.table(paste0(input, "/", j, "/", file))
        a[[which(list.files(input)[str_detect(list.files(input), i)] == j)]] <- dat
        names(a)[which(list.files(input)[str_detect(list.files(input), i)] == j)] <- j
        # a[[which(list.files(input)[str_detect(list.files(input), i)] == j)]] <- dat[, 10]
        # names(a)[which(list.files(input)[str_detect(list.files(input), i)] == j)] <- j
    }
    if (length(a) == 2) {
        n <- n + 1
        ## make the row numbers all the same
        a[[1]]$check <- paste0(a[[1]]$V2, a[[1]]$V3, a[[1]]$V4, a[[1]]$V5, a[[1]]$V6)
        a[[2]]$check <- paste0(a[[2]]$V2, a[[2]]$V3, a[[2]]$V4, a[[2]]$V5, a[[2]]$V6)
        common <- intersect(a[[1]]$check, a[[2]]$check)
        rownames(a[[1]]) <- a[[1]]$check
        rownames(a[[2]]) <- a[[2]]$check
        a[[1]] <- a[[1]][common, ]$V10
        a[[2]] <- a[[2]][common, ]$V10

        ## vafs
        tmp <- data.frame(a[[1]], a[[2]])
        names <- names(a)
        colnames(tmp) <- c("sample1", "sample2")

        ## label marker genes
        file1 <- list.files(paste0(input, "/", j))[str_detect(list.files(paste0(input, "/", j)), "vcf2")]
        dat1 <- read.table(paste0(input, "/", j, "/", file1), fill = T, header = FALSE, row.names = NULL)
        dat1$check <- paste0(dat1$V2, dat1$V3, dat1$V4, dat1$V5, dat1$V6)
        dat1 <- dat1[!duplicated(dat1$check), ]
        rownames(dat1) <- dat1$check
        vcf_gene <- dat1[common, ]$V1
        cancer_gene <- read.table("smg_list.tsv")
        cancer_gene <- cancer_gene$V1
        Genes <- character(length(vcf_gene))
        Genes[which(vcf_gene %in% cancer_gene)] <- "driver gene"
        Genes[which(!(vcf_gene %in% cancer_gene))] <- "non-driver gene"
        pro <- dat1[common, ]$V7
        pro <- word(pro, sep = fixed("."), 2)
        pro_gene <- paste0(vcf_gene, "(", pro, ")")
        pro_gene[Genes == "non-driver gene"] <- ""

        tmp <- cbind(tmp, pro_gene, Genes)
        b[[n]] <- ggplot(data = tmp, aes(x = sample2, y = sample1, color = Genes)) +
            scale_color_manual(values = c("driver gene" = "red", "non-driver gene" = "gray50")) +
            geom_point(aes(size = ifelse(Genes == "driver gene", 4, 3)), alpha = 0.4) +
            geom_text_repel(aes(label = pro_gene),
                size = 6.5,
                max.overlaps = Inf,
                min.segment.length = 0.75,
                segment.size = 1.5,
                force = 5,
                box.padding = 1,
                point.padding = 0.8,
                nudge_y = 2, # 垂直方向稍微移动标签
                nudge_x = 2 # 水平方向稍微移动标签
            ) +
            xlab(names[2]) +
            ylab(names[1]) +
            theme(
                panel.grid = element_blank(), panel.background = element_rect(fill = "transparent", color = "black"),
                panel.border = element_rect(fill = "transparent", color = "transparent"),
                legend.position = "none",
                axis.title.x = element_text(size = 20),
                axis.title.y = element_text(size = 20),
                axis.text.x = element_text(size = 16),
                axis.text.y = element_text(size = 16)
            )
    }
}

## make plots
pdf("vaf_correlations_new.pdf", height = 20, width = 22)
grid.newpage()
pushViewport(viewport(layout = grid.layout(nrow = 3, ncol = 3)))
define_region <- function(row, col) {
    viewport(layout.pos.row = row, layout.pos.col = col)
}
print(b[[1]], vp = define_region(row = 1, col = 1))
print(b[[2]], vp = define_region(row = 1, col = 2))
print(b[[3]], vp = define_region(row = 1, col = 3))
print(b[[4]], vp = define_region(row = 2, col = 1))
print(b[[5]], vp = define_region(row = 2, col = 2))
print(b[[6]], vp = define_region(row = 2, col = 3))
print(b[[7]], vp = define_region(row = 3, col = 1))
print(b[[8]], vp = define_region(row = 3, col = 2))
print(b[[9]], vp = define_region(row = 3, col = 3))
dev.off()
