# Prerequisites: set MWAS.HEATMAP to the mwas.heatmap folder location
#
# otufile: name of file containing OTU Table or PICRUST pathway table
# mapfile: name of file containing mapping metadata
# keep.pathways.file: [pathway analysis only] file containing pathways to filter by (keep); can be any level (L1-L3)
# heatmap.title: title to display on the heatmap 
# outputfile: heatmap output file name 
# cluster.var: vector of column names to cluster samples by (e.g. can be a single column for simple heatmaps, such as Treatment)
# color.list: list of color vectors, one vector per color.var to specify the colors used
# contraints: optional. list of vectors, each named after a map column; vector values represent values to keep
run.heatmap <- function(otufile, mapfile, keep.pathways.file="",
					heatmap.title, outputfile, cluster.var, color.list, constraints=NULL)
{
	source(paste(Sys.getenv("MWAS.HEATMAP"),"lib","load.data.r",sep="/"))
	source(paste(Sys.getenv("MWAS.HEATMAP"),"lib","mwas.heatmap.r",sep="/"))	
	source(paste(Sys.getenv("MWAS.HEATMAP"),"lib","factor.to.numeric.r",sep="/"))	
	source(paste(Sys.getenv("MWAS.HEATMAP"),"lib","get.next.kegg.r",sep="/"))	
	source(paste(Sys.getenv("MWAS.HEATMAP"),"lib","filter.pathways.r",sep="/"))	
		
	# read in data files	
	minOTUInSamples = .0001
	ret <- load.data(otufile=otufile, mapfile=mapfile, minOTUInSamples=minOTUInSamples, normalize=TRUE)
	otu <- ret$otu
	map <- ret$map
	kegg <- ret$kegg
	kegg_pathways <- NULL
	if(length(kegg)>0){
		# filter the kegg pathways and return the next level up for displaying
		kegg <- filter.pathways(kegg, keep.pathways.file)
		next.kegg <- get.next.kegg(kegg)
		names(next.kegg) <- names(kegg)
		kegg_pathways<-next.kegg
	}

	# some custom subsetting TODO: can we make this generic?
	#	map <- subset(map, !is.na(Diabetes) & Location=="fecal" & Week==6 & Sex %in% c("M") & Treatment %in% c("Control","PAT"))
	#	map <- subset(map, CaptiveWild %in% c("Wild", "Semi-captive"))
	#	map <- map[-which(map$Population=='Long face group'),]
	# if constraints are present, subset the samples accordingly
	if(length(constraints) > 0)
	{
		for(i in 1:length(constraints))
		{
			col.name <- names(constraints)[i]
			# get only the rows that meet this constraint
			map <- map[map[, col.name] %in% constraints[[i]],]
		}
	}
	otu <- otu[rownames(map),]



	# make the heatmap
	mwas.heatmap(otu, map, cluster.var, color.var=names(color.list), color.list, kegg_pathways=kegg_pathways, heatmap.title=heatmap.title, outputfile=outputfile)
}



