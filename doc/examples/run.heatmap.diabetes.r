#Sys.setenv(MWAS.HEATMAP=getwd())
run.heatmap.diabetes <- function()
{
	source(paste(Sys.getenv("MWAS.HEATMAP"),"run.heatmap.r",sep="/"))

	otufile<-"data/diabetes.metagenome.txt"
	mapfile<-"data/diabetes.map.txt"
	keep.pathways.file<-"data/diabetes.pathways.heatmap.txt"

	# create custom subsetting parameters required for this data set
	constraints <- list()
	constraints[["Diabetes"]] <- c(0, 1)
	constraints[["Location"]] <- c("fecal")
	constraints[["Week"]] <- c(6)
	constraints[["Sex"]] <- c("M")
	constraints[["Treatment"]] <- c("Control", "PAT")
	 
	# form all of the clustering and color parameters
	cluster.var <- c("Sex", "Treatment")
	color.list <- list()
	# !! names and values must match mapping file exactly!
	# this is a factor, number of colors = number of values
	color.list[["Treatment"]] <- setNames(c('antiquewhite','darkseagreen1','thistle'), c("Control", "PAT", "STAT"))
	# this is a factor, number of colors = number of values
	color.list[["Sex"]] <- setNames(c('pink','lightblue'), c("F","M"))
	# this is a numeric, therefore colors will be shown as a gradient between the two colors here
	color.list[["Diabetes_week"]] <- setNames(c('indianred1','snow3'), c("early Diabetes", "late Diabetes"))

	# make the heatmap
	run.heatmap(otufile=otufile, mapfile=mapfile, keep.pathways.file=keep.pathways.file, 
				heatmap.title="Differential pathways", outputfile="diabetes.pathways.pdf", 
				cluster.var=cluster.var, color.list=color.list, constraints=constraints)
}
