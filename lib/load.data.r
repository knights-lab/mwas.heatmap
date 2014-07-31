# Loads a map and otu file (taxa or pathway), normalizes the OTU table and returns the OTU table, 
# map and kegg descriptions (if any) in order of the remaining samples
#
# mapfile: mapping metadata file
# otufile: OTU table in classic format
# normalize: normalizes, transforms, then collapses OTU table; set this to false when working with merged L1,..,L6 taxa files 
# minOTUInSamples: drop OTUs in less than this ratio of samples
# returns otu, map, and kegg vector containing kegg descriptions (named by whatever KEGG level was passed in)
load.data<-function(mapfile, otufile, minOTUInSamples = .001, normalize=TRUE)
{
	source(paste(Sys.getenv("MWAS.HEATMAP"),"lib","collapse-features.r",sep="/"))

	map <- read.table(mapfile,sep='\t',head=T,row=1,comment='')
	rownames(map) <- make.names(rownames(map)) # this is automatically done for otu table, so do this here to make sure sample ids are exactly the same 
			
	line1 <-readLines(otufile,n=1)
	if(line1=="# Constructed from biom file") {
		otu0 <-read.table(otufile,sep='\t',head=T,row=1,comment='',quote="",skip=1)
	} else {
		otu0 <-read.table(otufile,sep='\t',head=T,row=1,comment='',quote="")
	}

	# pathway files from picrust usually have an additional last column with descriptions, just drop this for now
	KEGG <- NULL
	if(colnames(otu0)[ncol(otu0)]=="KEGG_Pathways"){
		KEGG <- setNames(otu0[, ncol(otu0)], rownames(otu0))
		otu0 <- otu0[,-ncol(otu0)]
	}
	
	otu <- t(otu0)

	if(normalize==TRUE){
		otu <- sweep(otu, 1, rowSums(otu), '/')
		otu <- otu[, colMeans(otu) > minOTUInSamples, drop=FALSE]
		otu <- asin(sqrt(otu))
		ret <- collapse.by.correlation(otu, .95)
		otu <- otu[, ret$reps]
	}
		
	full <- merge(otu, map, by=0)	
	otu <- otu[full$Row.names,]
	map <- map[full$Row.names,]
	
	if(length(KEGG) > 0){
		KEGG <- KEGG[colnames(otu)] #use the same order as our final otu table
	}
	
	list(otu=otu, map=map, kegg=KEGG)
}
