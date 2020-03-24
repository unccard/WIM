#Two methods of calculating lexical diversity in R. This data collection process was used in
#Cunningham, K. T., & Haley, K. L. (2020). Measuring Lexical Diversity for Discourse Analysis in Aphasia: Moving-Average Type–Token Ratio and Word Information Measure. Journal of Speech, Language, and Hearing Research, 1-12.
#Data set available at https://aphasia.talkbank.org/

#Simple script to calculate the Word Information Measure for all .txt files in the working directory. 
#  Rinker, T. W. (2020). qdap: Quantitative Discourse Analysis Package. 2.3.6. Buffalo, New York. http://github.com/trinker/qdap
library(qdap) 
fileNames = dir(pattern = ".txt")
for (fileName in fileNames){
  sample <- readChar(fileName, file.info(fileName)$size)
  df <- diversity(sample)
  write.table(c(fileName, df$shannon), file="data_WIM.csv", append=TRUE, sep = ",", row.names = FALSE, col.names = FALSE)
}

#Simple script to calculate the moving-average type-token ratio for all text files in a directory. Outputs a single CSV file with filename 
#  Michalke, M. (2018). koRpus: An R Package for Text Analysis (Version 0.11-5). Available from https://reaktanz.de/?c=hacking&s=koRpus
library(koRpus)
#Set language to English for koRpus. Please see package documentation for further information (?koRpus)
set.kRp.env(lang="en")
koRpus.lang.en::lang.support.en()

#This now calculates MATTR at your specified analysis window
fileNames = dir(pattern = ".txt")
datalist=list()
for (fileName in fileNames){
  tokenized.obj <- tokenize(fileName, lang = "en") #using the tokenize function in koRpus
  m <- MATTR(tokenized.obj, window = 5) #this is the analysis window, currently set to 5 words
  m <- m@MATTR
  m <-m$MATTR
  datalist[[fileName]] <- m
}
mattrK = do.call(rbind, datalist)
write.table(c(fileName, mattrK), file="data_MATTR.csv", append=TRUE, sep = ",", row.names = FALSE, col.names = FALSE)


