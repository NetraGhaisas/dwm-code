df = read.csv("D:/BHAGYASHREE/LY Sem 7/DWM/Codes/nba.csv",na.strings=c("","NA"))
print(summary(df))

print(head(df))

#check missing values
colSums(is.na(df))

#replace null values in weight with mean
df[is.na(df[,7]), 7] <- mean(df[,7], na.rm=TRUE)

print(head(df))

#replace null values in salary with mean
df[is.na(df[,9]), 9] <- mean(df[,9], na.rm=TRUE)

print(head(df))

#replace null values in age with mode
uniq <- unique(df[,5])
print(uniq)
class(uniq)
freq <- vector(mode="integer",length=length(uniq))
print(freq)

for(val in df[,5]){
  i <- match(c(val),uniq)
  freq[i] = freq[i]+1
}
print(freq)
i <- match(c(max(freq)),freq)
print("Mode")
mode <- uniq[i]
print(mode)

df[is.na(df[,5]), 5] <- mode
print(head(df,10))


#replace null values in number with mode
uniqNum <- unique(df[,3])
print(uniqNum)
class(uniqNum)
freqNum <- vector(mode="integer",length=length(uniqNum))
print(freqNum)

for(val in df[,3]){
  i <- match(c(val),uniqNum)
  freqNum[i] = freqNum[i]+1
}
print(freqNum)
i <- match(c(max(freqNum)),freqNum)
print("Mode")
modeNum <- uniqNum[i]
print(modeNum)

df[is.na(df[,3]), 3] <- modeNum
print(head(df,10))

#replace null values in college with mode
uniqCol <- unique(df[,8])
print(uniqCol)
class(uniqCol)
freqCol <- vector(mode="integer",length=length(uniqCol))
print(freqCol)

for(val in df[,8]){
  i <- match(c(val),uniqCol)
  freqCol[i] = freqCol[i]+1
}
print(freqCol)
i <- match(c(max(freqCol)),freqCol)
print("Mode")
modeCol <- uniqCol[i]
print(modeCol)

df[is.na(df[,8]), 8] <- modeCol
print(head(df))

write.csv(df, file = "D:/BHAGYASHREE/LY Sem 7/DWM/Codes/preprocessed-nba.csv")