library(ggvis)
#clear environment variables
rm(list=ls())
#read csv with NA replacement
#emp <- read.csv("F:/Netra/LY Engg/DWM/Code/employee.csv",na.strings=c("","NA"),stringsAsFactors = T)
emp <- read.csv("F:/Netra/LY Engg/DWM/Code/employee.csv",stringsAsFactors = T)
emp[1:5,]
# checking summary
summary(emp)
for(col in emp){
  print(levels(col))
}

emp[emp==""]<-"NA"

# checking summary again
summary(emp)

#checking NA columns
colSums(is.na(emp))

#checking levels in Gender column
emp$Gender <- as.factor(emp$Gender)
levels(emp$Gender)
#correcting misspelled values
levels(emp$Gender)[2]<-"F"
levels(emp$Gender)[3]<-"M"
levels(emp$Gender)[4]<-"M"
levels(emp$Gender)

colnames(emp)

plot(emp$PayRate)
plot(emp$DaysLateLast30)

getMode <- function(x, na.rm=F){
  uniq <- unique(x)
  #print(uniq)
  #class(uniq)
  freq <- vector(mode="integer",length=length(uniq))
  #print(freq)
  
  for(val in x){
    i <- match(c(val),uniq)
    freq[i] = freq[i]+1
  }
  #print(freq)
  i <- which.max(freq)
  print("Mode")
  mode <- uniq[i]
  #print(mode)
  return(mode)
}

#impute median value for columns whose distribution is heavily skewed
median(na.omit(emp$DaysLateLast30))
median(na.omit(emp$PayRate))

mean(na.omit(emp$EngagementSurvey))
mean(na.omit(emp$EmpSatisfaction))

getMode(emp$Gender)
getMode(emp$RecruitmentSource)
getMode(emp$TermReason)
getMode(emp$CitizenDesc)

#normalization of numeric columns
emp$PayRate<-scale(emp$PayRate)
emp$EmpSatisfaction<-scale(emp$EmpSatisfaction)
summary(emp$PayRate)
summary(emp$EmpSatisfaction)

emp_data <- emp

emp_data$DaysLateLast30[is.na(emp_data$DaysLateLast30)] <- median(na.omit(emp$DaysLateLast30))
emp_data$PayRate[is.na(emp_data$PayRate)] <- median(na.omit(emp$PayRate))

emp_data$EngagementSurvey[is.na(emp_data$EngagementSurvey)] <- mean(na.omit(emp$EngagementSurvey))
emp_data$EmpSatisfaction[is.na(emp_data$EmpSatisfaction)] <- mean(na.omit(emp$EmpSatisfaction))

emp_data$Gender[is.na(emp_data$Gender)] <- getMode(emp$Gender)
emp_data$RecruitmentSource[is.na(emp_data$RecruitmentSource)] <- getMode(emp$RecruitmentSource)
emp_data$TermReason[is.na(emp_data$TermReason)] <- getMode(emp$TermReason)
emp_data$CitizenDesc[is.na(emp_data$CitizenDesc)] <- getMode(emp$CitizenDesc)

summary(emp_data)
write.csv(emp_data,file = "cleaned_employee.csv",row.names = F)

