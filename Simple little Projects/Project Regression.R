# Write your model
# Simple linear regression
# Check list
# SXX,Syy,Sxy(Checked)(Mahmoud and Zyad).
# Beta 1,Beta0(Checked)(Mahmoud and Zyad).
# SSR,SSE(Checked)(Bisho and Hamdi).
# Anova table(Checked)(ziad and ali).
# Confidence interval for estimator at given significant level(Checked)(gaber and safy).
# Calculation of C.l. for mean response and new observation(Checked)(Gowely and Ashraf).
# Scatter plot contain fitted line(Checked)(Mahmoud).
SLR <- function(Data){
  # Getting needed data
  X <- Data$x
  y <- Data$y
  # Calculating SXX and SXy and Syy
  SXX <- sum(X^2) -length(X)*(mean(X)^2) 
  Syy <- sum(y^2) -length(y)*(mean(y)^2)
  SXy <- sum(X*y) -length(X)*mean(X)*mean(y)
  # Calculating intercept(Beta Node) and Slope(Beta 1)
  Beta_1 <- SXy / SXX
  Beta_0 <- mean(y) - Beta_1*mean(X)
  # Calculating Sum squares (Regression,error,Total)
  SST <- round(Syy,digits = 2)
  SSR <- round(Beta_1*SXy,digits = 2)
  SSE <- SST - SSR
  # Calculating Mean squares (Regression,error,Total)
  MSR = SSR/1
  MSE = round(SSE/(length(X)-2),2)
  MST = MSR+MSE
  # Draw Anova Table
  anova_table <- data.frame(
    row.names =  c("Regression", "Error", "Total"),
    SS = c(SSR,SSE,SST),
    DOF = c(1,length(X)-2,length(X)-1),
    MS = c(MSR,MSE,""),
    F0 = c(round(MSR/MSE,2),"","")
  )
  # CI for Estimators
  SL = as.numeric(readline("PLease choose your significance level : "))
  if(length(X)>=30){  
    # CI for BETA 1 using Z
    Upper_Beta_1 = round(Beta_1 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE/SXX),2)
    Lower_Beta_1 = round(Beta_1 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE/SXX),2)
    # CI for BETA 0 using Z
    Upper_Beta_0 = round(Beta_0 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX)),2)
    Lower_Beta_0 = round(Beta_0 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX)),2)
  }else{
    # CI for BETA 1 using T
    Upper_Beta_1 = round(Beta_1 + qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE/SXX),2)
    Lower_Beta_1 = round(Beta_1 - qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE/SXX),2)
    # CI for BETA 0 using T
    Upper_Beta_0 = round(Beta_0 + qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX)),2)
    Lower_Beta_0 = round(Beta_0 - qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX)),2)
  }
  # CI for Mean Response and New Obs.
  X0 <- as.numeric(readline("Please Choose the value of X0 :"))
  Y0 <- Beta_0 + Beta_1*X0
  if(length(X)>=30){  
    # CI for Y0 mean response using Z
    Y0_mean_reponse_upper = round(Y0 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX))),2)
    Y0_mean_reponse_lower = round(Y0 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX))),2)
    # CI for Y0 New obs. using Z
    Y0_new_obs_upper = round(Y0 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX))),2)
    Y0_new_obs_lower = round(Y0 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX))),2)
  } else{
    # CI for Y0 mean response using T
    Y0_mean_reponse_upper = round(Y0 + qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX))),2)
    Y0_mean_reponse_lower = round(Y0 - qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX))),2)
    # CI for Y0 New obs. using T
    Y0_new_obs_upper = round(Y0 + qt(SL/2,df = length(X)-2,lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX))),2)
    Y0_new_obs_lower = round(Y0 - qt(SL/2,df = length(X)-2,lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX))),2)
  }
  # Print function
  cat("Value of SXX is",SXX
      ,"\nValue of SYY is",Syy
      ,"\nValue of SXy is",SXy
      ,"\nValue of Beta One(slope) is",Beta_1
      ,"\nValue of Beta node(intercept) is",Beta_0
      ,"\nValue of SST =",Syy
      ,"\nValue of SSR =",SSR
      ,"\nValue of SSE =",SSE
      ,"\n*and here's Anova Table* \n")
  print(anova_table)
  cat("The CI for BETA One :",Lower_Beta_1,"< B1 <",Upper_Beta_1,
      "\nThe CI for BETA Node :",Lower_Beta_0,"< B0 <",Upper_Beta_0)
  cat("\nThe CI for Y0 Mean Resp. :",Y0_mean_reponse_lower,"< Y0 <",Y0_mean_reponse_upper,
      "\nThe CI for Y0 New obs. :",Y0_new_obs_lower,"< Y0 <",Y0_new_obs_upper)
  plot(X,y)
  abline(a=Beta_0,b=Beta_1)
}
MLR <- function(Data){
  print("Not available for now")
}
path <- readline("Please put your path : ")
Data <- read.csv(path)
SLR(Data)
