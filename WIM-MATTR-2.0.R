# WIM-MATTR 2.0

# formerly titled "Cunningham & Haley 2020.R" after the authors. This update (2.0, adamjacks) consolidates output of WIM and MATTR to one data file and fixes a bug in the output. Adds an explicit file location for input.

#Two methods of calculating lexical diversity in R. This data collection process was used in
#Cunningham, K. T., & Haley, K. L. (2020). Measuring Lexical Diversity for Discourse Analysis in Aphasia: Moving-Average Type-Token Ratio and Word Information Measure. Journal of Speech, Language, and Hearing Research, 1-12.
#Data set available at https://aphasia.talkbank.org/

#Calculates the Word Information Measure (WIM) and the Moving-Average Type-Token Ratio (MATTR)
#for every .txt file in dataDir, and writes ONE combined CSV (one row per file, both metrics as columns).
#  Rinker, T. W. (2020). qdap: Quantitative Discourse Analysis Package. 2.3.6. Buffalo, New York. http://github.com/trinker/qdap
#  Michalke, M. (2018). koRpus: An R Package for Text Analysis (Version 0.11-5). Available from https://reaktanz.de/?c=hacking&s=koRpus

library(qdap)
library(koRpus)

#Set language to English for koRpus. Please see package documentation for further information (?koRpus)
set.kRp.env(lang = "en")
koRpus.lang.en::lang.support.en()

#dataDir <- "C:/path/to/your/data"   # <- change this to the folder containing your .txt transcripts
#fileNames <- dir(path = dataDir, pattern = ".txt", full.names = TRUE)

dataDir <- rstudioapi::selectDirectory("Choose your data folder")  # pops up a folder browser - needs RStudio
# Alternative if you'd rather paste the path directly: use forward slashes, even on
# Windows, e.g. dataDir <- "C:/Users/you/OneDrive - University/Aphasia Study/CSVs"

fileNames <- dir(path = dataDir, pattern = "\\.txt$", full.names = TRUE)

results <- data.frame(fileName = character(), WIM = numeric(), MATTR = numeric(), stringsAsFactors = FALSE)

for (fileName in fileNames) {
  
  #Word Information Measure (Shannon diversity)

  sample <- readChar(fileName, file.info(fileName)$size)
  df <- diversity(sample)
  wim <- df$shannon
  
  #Moving-Average Type-Token Ratio, analysis window currently set to 5 words
  tokenized.obj <- tokenize(fileName, lang = "en")
  m <- MATTR(tokenized.obj, window = 5)
  m <- m@MATTR
  mattr <- m$MATTR
  
  results <- rbind(results, data.frame(fileName = basename(fileName), WIM = wim, MATTR = mattr, stringsAsFactors = FALSE))
}

write.table(results, file = file.path(dataDir, "data_WIM_MATTR.csv"), sep = ",", row.names = FALSE, col.names = TRUE)
