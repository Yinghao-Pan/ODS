## create the example data sets for secondary analysis in ODS design

library(fMultivar)
set.seed(100)
N <- 3000                      # number of the full cohort
beta0 <- 1
beta1 <- 0.5
beta2 <- c(-0.5, 1, 0.5)
gamma0 <- 1
gamma1 <- 0.5
gamma2 <- c(-0.5, 1, 2)
delta1 <- 1
delta2 <- 1
rho <- 0.8
## simulate the data ##
X <- rnorm(N, mean=0 , sd=1)
Z1 <- rbinom(N, size=1, prob=0.45)
Z2 <- rbinom(N, size=1, prob=0.2)
Z3 <- rbinom(N, size=1, prob=0.8)
Z <- cbind(Z1, Z2, Z3)
t <- rnorm2d(N, rho)
e <- t[,1]*delta1
epsilon <- t[,2]*delta2
rm(t)
Y1 <- as.vector(beta0 + beta1 * X + Z %*% beta2 + e)
Y2 <- as.vector(gamma0 + gamma1 * X + Z %*% gamma2 + epsilon)
data <- cbind(Y1, Y2, X, Z)
#  pick an ODS sample
meanY1 <- mean(Y1)
sdY1 <- sd(Y1)
a <- 1                           # cut off point
n0 <- 200                         # size of the simple random sample
n1 <- 100                         # sample from lower tail of Y
n3 <- 100                         # sample from upper tail of Y
index1 <- sample(1:N, n0)
SRS <- data[index1,]
data <- data[-index1,]
upperY1 <- data[data[,1]>=meanY1+a*sdY1,]
lowerY1 <- data[data[,1]<=meanY1-a*sdY1,]
middleY1 <- data[data[,1]<meanY1+a*sdY1 & data[,1]>meanY1-a*sdY1,]
index2 <- sample(1:nrow(lowerY1), n1)
lowerODS <- lowerY1[index2,]
lowerY1 <- lowerY1[-index2,]
index3 <- sample(1:nrow(upperY1), n3)
upperODS <- upperY1[index3,]
upperY1 <- upperY1[-index3,]
NVsample <- rbind(middleY1,upperY1,lowerY1)           # Nonvalidation sample

## create the subject-indicator ##
## 1 = SRS
## 2 = lowerODS
## 3 = upperODS
## 0 = NVsample
subj_ind <- c(rep(1,200), rep(2,100), rep(3,100), rep(0,2600))

NVsample[,3] <- NA
tempdata <- rbind(SRS, lowerODS, upperODS, NVsample)

## the final example data for secondary analysis in ODS design
ods_data_secondary <- cbind(subj_ind, tempdata)


## create the example data set for secondary analysis in case-cohort data

set.seed(1)
lambda0 <- 1
gamma1 <- log(1.2)
gamma2 <- 0.5
gamma3 <- c(-0.5, 1, 0.5)

beta0 <- 1
beta1 <- 0.5
beta2 <- c(-0.5, 2, 3, 1)
sigma <- 1

N <- 1000          # full cohort size
Z11 <- rbinom(N, size=1, prob=0.45)
Z12 <- rbinom(N, size=1, prob=0.2)
Z13 <- rbinom(N, size=1, prob=0.8)
Z14 <-  rnorm(N, 0, 1)
Z1 <- cbind(Z11, Z12, Z13, Z14)
Z21 <- Z11
Z22 <- rbinom(N, size=1, prob=0.4)
Z23 <- rbinom(N, size=1, prob=0.3)
Z2 <- cbind(Z21, Z22, Z23)
Z31 <- Z11
Z32 <- Z22
Z33 <- Z23
Z3 <- cbind(Z31, Z32, Z33)
X <- rnorm(N, mean=0, sd=1)
epsilon <- rnorm(N, mean=0, sd=sigma)

Y2 <- as.vector(beta0 + beta1*X + Z1%*%beta2 + epsilon)
failure.rate <- lambda0*exp(gamma1*Y2+gamma2*X+Z2%*%gamma3)
tildeT <- rexp(N, rate=failure.rate)

C <- runif(N, min=0, max=0.42)

T <- pmin(tildeT, C)
Delta <- ifelse(tildeT<C, 1, 0)
Data <- cbind(T, Delta, Y2, X, Z1, Z2, Z3)

### select a case-cohort sample ###
### select a SRS sub-cohort ###
n.SRS <- 300           # size of the SRS sub-cohort
index <- sample(1:N, n.SRS)
SRS <- Data[index,]
SRS <- data.frame(SRS)

### add additional cases to the case cohort sample ###
Data.remaining <- Data[-index,]
cases.remaining <- Data.remaining[Data.remaining[,2]==1,]
controls.remaining <- Data.remaining[Data.remaining[,2]==0,]

CCH <- rbind(SRS, cases.remaining)
CCH <- data.frame(CCH)

### note: data structure for CCH (T, Delta, Y2, X, Z1, Z2, Z3) ###
### note: data structure for NVsample (T, Delta, Y2, Z1, Z2, Z3) ###
### NVsample is the set where we dont observe the expensive exposure ###

NVsample <- controls.remaining
NVsample[,4] <- NA

### create the subject indicator ###
### 1 = SRS
### 2 = supplemental cases
### 0 = non-validation sample
subj_ind <- c(rep(1, 300), rep(2, nrow(CCH)-300), rep(0, N-nrow(CCH)))

data <- rbind(CCH, NVsample)
data <- cbind(subj_ind, data)

## the final example data for secondary analysis in case-cohort design
casecohort_data_secondary <- data

### create the example data set for analyzing the primary outcome in ODS design ###
### this data set is part of the data set ods_data_secondary ###

## take the validation sample out of ods_data_secondary ##

ods_data <- ods_data_secondary[1:400, c(2,4:7)]
