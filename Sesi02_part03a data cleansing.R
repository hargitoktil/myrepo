# -------------------------------------------------------------
# Topik dataset: Hasil performance review manager di perusahaan ABC
# -------------------------------------------------------------

manager <- c(1,2,3,4,5) #managerID
date <- c("10/01/14","10/01/15","10/1/16","10/12/16","5/1/17") #tanggal menjadi manager
date <- as.Date(date, format="%m/%d/%y") # membaca tanggal dengan format spesifik
gender <- c("M","F","F","M","F")
age <- c(32,45,27,58,99)
score1 <- c(5,3,3,3,2)
score2 <- c(4,5,5,3,2)
score3 <- c(5,5,5,NA,2)
score4 <- c(5,5,2,NA,1)
leadership <- data.frame(manager,date,gender,age,score1,score2,score3,score4, 
                         stringsAsFactors=FALSE)

rm(manager,date,gender,age,score1,score2,score3,score4) # remove the individual elements

### Data Type Formatting ###

# Mengubah nama column dengan plyr::rename()
#library(plyr)
leadership <- plyr::rename(leadership, c(manager="managerID", date="datePromoted"))

# Memastikan data type nya benar dengan "is"
str(leadership)
is.numeric(leadership$age)
is.character(leadership$age)
is.vector(leadership$age)
is.matrix(leadership$age)

# Mengubah data type dengan "as"
is.character(leadership$managerID)
leadership$managerID <- as.character(leadership$managerID)
is.character(leadership$managerID)

# Menampilkan tanggal dengan format spesifik
today <- Sys.Date()
format(today, format="%A") # %A untuk Weekday
format(today, format="%B %d %Y") #%B Month text, %d date
format(today, format="%m/%d/%y") #%m month number

# Menambahkan variable selisih tanggal menjadi manager dan tanggal evaluasi
leadership$daysasManager <- today-leadership$datePromoted

# Menghapus variable
# Cara 1: assign dengan NULL
leadership$daysasManager <- NULL

# Cara 2: gunakan tanda seru !
leadership$daysasManager <- today-leadership$datePromoted
myvars <- names(leadership) %in% "daysasManager" 
leadership <- leadership[!myvars]

# Menambahkan variable kategori umur
leadership$agecat[leadership$age > 55] <- "Elder"
leadership$agecat[leadership$age >= 35 & leadership$age <= 55] <- "Middle-Aged"
leadership$agecat[leadership$age < 35] <- "Young"

### Handling Missing Values ###

is.na(leadership) #seluruh dataset
is.na(leadership[, c("score1","score2","score3","score4")]) #hanya variable ke-6 sampai ke-10

# 1) Filter out incomplete observation (pemisahan data) dengan na.omit()
leadership_clean <- na.omit(leadership)

# Mengexclude NA dari perhitungan dengan na.rm()
x <- c(1, 2, NA, 3)
sum_x1 <- sum(x) #NA masih ikut dihitung
sum_x2 <- sum(x, na.rm=TRUE) #NA dikecualikan

# 2) Impute NA values
scores <- leadership[5:8]
scores$imputed_score3 <- with(scores, impute(score3, mean))
scores$imputed_score4 <- with(scores, impute(score4, min))
mean(scores$score4)
mean(scores$imputed_score4)
