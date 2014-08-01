#Sys.setenv(MWAS.HEATMAP=getwd())
source(paste(Sys.getenv("MWAS.HEATMAP"),"run.heatmap.r",sep="/"))
# form all of the clustering and color parameters
cluster.var <- "CaptiveWild"
color.list <- list()
# names must match columns exactly!
color.list[["CaptiveWild"]] <- setNames(c('springgreen4','orange', 'firebrick1'), c("Wild", "Semi-captive", "Captive"))

# run.heatmap(otufile="data/doucs.metagenome.txt", mapfile="data/doucs.map.txt", keep.pathways.file="data/doucs.pathways.heatmap.txt", 
# 						heatmap.title="Differential pathways", outputfile="doucs.pathways.pdf", cluster.var=cluster.var, color.list=color.list)

	run.heatmap(otufile= "data/doucs.otu.txt", mapfile="data/doucs.map.txt",
							heatmap.title="Differential taxon", outputfile="doucs.taxa.pdf", cluster.var=cluster.var, color.list=color.list)
