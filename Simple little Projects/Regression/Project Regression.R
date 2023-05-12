# Write your model
# Simple linear regression vs Multiple Linear Regression
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
  SST <- Syy
  SSR <- Beta_1*SXy
  SSE <- SST - SSR
  # Calculating Mean squares (Regression,error,Total)
  MSR = SSR/1
  MSE = (SSE/(length(X)-2))
  MST = MSR+MSE
  # Draw Anova Table
  anova_table <- data.frame(
    row.names =  c("Regression", "Error", "Total"),
    SS = c(SSR,SSE,SST),
    DOF = c(1,length(X)-2,length(X)-1),
    MS = c(MSR,MSE,""),
    F0 = c(MSR/MSE,"",""))
  # Calculate the Value of R^2
  R_squared <- SSR / SST
  direction <- ifelse(Beta_1 < 0, "negative", "positive")
  # Generate output text
  # CI for Estimators
  SL = as.numeric(readline("PLease choose your significance level : "))
  if(length(X)>=30){  
    # CI for BETA 1 using Z
    Upper_Beta_1 = Beta_1 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE/SXX)
    Lower_Beta_1 = Beta_1 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE/SXX)
    # CI for BETA 0 using Z
    Upper_Beta_0 = Beta_0 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX))
    Lower_Beta_0 = Beta_0 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX))
  }else{
    # CI for BETA 1 using T
    Upper_Beta_1 =  Beta_1 + qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE/SXX)
    Lower_Beta_1 =  Beta_1 - qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE/SXX)
    # CI for BETA 0 using T
    Upper_Beta_0 =  Beta_0 + qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX))
    Lower_Beta_0 =  Beta_0 - qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*((1/length(X)) + mean(X)^2/SXX))
  }
  # CI for Mean Response and New Obs.
  X0 <- as.numeric(readline("Please Choose the value of X0 : "))
  Y0 <- Beta_0 + Beta_1*X0
  if(length(X)>=30){  
    # CI for Y0 mean response using Z
    Y0_mean_reponse_upper = Y0 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX)))
    Y0_mean_reponse_lower = Y0 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX)))
    # CI for Y0 New obs. using Z
    Y0_new_obs_upper = Y0 + qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX)))
    Y0_new_obs_lower = Y0 - qnorm(SL/2, mean = 0, sd = 1, lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX)))
  } else{
    # CI for Y0 mean response using T
    Y0_mean_reponse_upper = Y0 + qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX)))
    Y0_mean_reponse_lower = Y0 - qt(SL/2,df = length(X)-2, lower.tail=F)*sqrt(MSE*(1/length(X) + ((X0-mean(X))^2/SXX)))
    # CI for Y0 New obs. using T
    Y0_new_obs_upper = Y0 + qt(SL/2,df = length(X)-2,lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX)))
    Y0_new_obs_lower = Y0 - qt(SL/2,df = length(X)-2,lower.tail=F)*sqrt(MSE*(1 + 1/length(X) + ((X0-mean(X))^2/SXX)))
  }
  # put all this text in lonely file
  # Print summary statistics
  cat("Summary statistics:\n"
 ,"  SXX: ", SXX, "\n"
 ,"  SYY: ", Syy, "\n"
 ,"  SXy: ", SXy, "\n"
 ,"  Beta One (slope): ", Beta_1, "\n"
 ,"  Beta node (intercept): ", Beta_0, "\n"
 ,"  SST: ", Syy, "\n"
 ,"  SSR: ", SSR, "\n"
 ,"  SSE: ", SSE, "\n"
 ,"  R-squared: ", round(R_squared * 100, 2), "% in the ", direction, " direction.\n")
  # Print ANOVA table
  cat("ANOVA table:\n",file="output.txt")
  print(anova_table)
  
  # Print confidence intervals
  cat("\nConfidence intervals:\n"
 ,"  CI for Beta One: ", Lower_Beta_1, " < B1 < ", Upper_Beta_1, "\n"
 ,"  CI for Beta Node: ", Lower_Beta_0, " < B0 < ", Upper_Beta_0, "\n"
 ,"  CI for Y0 Mean Response: ", Y0_mean_reponse_lower, " < Y0 < ", Y0_mean_reponse_upper, "\n"
 ,"  CI for Y0 New Observation: ", Y0_new_obs_lower, " < Y0 < ", Y0_new_obs_upper, "\n")
  
  # Plot regression line
  plot(X, y)
  abline(a = Beta_0, b = Beta_1, col = "red", lwd = 3)
}
MLR <- function(Data){
  # Constructing needed data
  my_df <- as.matrix(data)
  big_x <- cbind(b0=rep(1,length(data)),my_df)
  x <- big_x[,-ncol(big_x)]
  y <- subset(my_df, select = ncol(my_df))
  xt <- t(x)
  xtx <- xt%*%x
  xtx_inverse <- solve(xtx)
  xty <- xt%*%y
  # OPERATIONS FOR SS
  betas <- xtx_inverse%*%xt%*%y
  y_bar <- mean(y)
  betas_t <- t(betas)
  # SUM SQUARES
  SSE<- (t(y)%*%y)-(betas_t%*%xt%*%y) 
  # Calaulate SST
  SST<-(t(y)%*%y)-(length(y))*(y_bar)^2    
  # CAlculate SSR
  SSR=SST-SSE               
  R_square <- SSR/SST
  #ANOV
  k <- ncol(big_x[, -c(1, ncol(big_x))])
  p <- k+1
  MSR = SSR/k
  MSE = SSE/(length(y)-p)
  MST = MSR+MSE
  # Draw Anova Table
  anova_table <- data.frame(
    row.names =  c("Regression", "Error", "Total"),
    SS = c(SSR,SSE,SST),
    DOF = c(k,length(y)-p,p),
    MS = c(MSR,MSE,""),
    F0 = c(MSR/MSE,"",""))
  # Calculate the Value of R^2
  R_squared <- SSR / SST
  cat("Summary statistics:\n"
      ,"  Matrix of X: ", x, "\n"
      ,"  Matrix of y: ", y, "\n"
      ,"  Matrix of (XtX): ", xtx, "\n"
      ,"  Matrix of C (XtX)^-1: ", xtx_inverse, "\n"
      ,"  Beta values: ", betas, "\n"
      ,"  SST: ", SST, "\n"
      ,"  SSR: ", SSR, "\n"
      ,"  SSE: ", SSE, "\n"
      ,"  R-squared: ", round(R_squared * 100, 2))
  # Print ANOVA table
  cat('ANOVA table')
  print(anova_table)
}
path <- noquote(file.choose())
Data <- read.csv(path)
value_of_regression <- as.numeric(readline("Which type of method do you need? :\n1-SLR(Simple Linear Regression)\n2-MLR(Multiple Linear Regression)"))
Function <- switch(value_of_regression,
                   SLR = SLR(Data),
                   MLR = MLR(Data),
                   stop("Invalid input. Please enter 1 or 2."))
print(Function)
