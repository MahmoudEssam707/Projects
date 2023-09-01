# Simple linear regression vs Multiple Linear Regression
library(XML)
library(knitr)
library(RODBC)
library(readxl)
library(jsonlite)
library(haven)
library(feather)
SLR <- function(Data){
  # Getting needed data
  X <- Data[, 1]
  y <- Data[, -1]
  
  # Calculating SXX, Syy, and SXy
  n <- length(X)
  SXX <- sum(X^2) - n*mean(X)^2
  Syy <- sum(y^2) - n*mean(y)^2
  SXy <- sum(X * y) - n*mean(y)*mean(X)
  
  # Calculating intercept (Beta Node) and slope (Beta 1)
  Beta_1 <- SXy / SXX
  Beta_0 <- mean(y) - Beta_1 * mean(X)
  
  # Calculating sum of squares (Regression, Error, Total)
  SSR <- Beta_1 * SXy
  SSE <- Syy - SSR
  SST <- SSR + SSE
  
  # Calculating mean squares (Regression, Error, Total)
  MSR <- SSR / 1
  MSE <- SSE / (n - 2)
  MST <- MSR + MSE
  # Degree of Fredooms
  DOR = 1
  DOE = n-2
  DOT = n-1
  # Result of F0
  F0 = MSR/MSE
  # Create ANOVA table
  anova_table <- data.frame(
    row.names = c("Regression", "Error", "Total"),
    SS = c(SSR, SSE, SST),
    DF = c(DOR, DOE,DOT),
    MS = c(MSR, MSE, ""),
    F0 = c(F0, "", "")
  )
  # Confidence level input
  CL <- as.numeric(readline("Please choose your confidence level: "))
  # Performing Test for checking if regression Exist or no
  Fc<- qf((1-(CL/100)), DOR, DOE)
  # Calculate the value of R-squared
  R_squared <- SSR / SST
  R_Squared_adj <- 1-((SSE/DOE)/(SST/DOT))
  # Calculate Confidence Intervals for Beta
  calculate_CI_Beta <- function(Beta_1, Beta_0, MSE, SXX, X, CL) {
    if (n >= 30) {
      rc <- qnorm(CL / 2, mean = 0, sd = 1, lower.tail = FALSE)
    } else {
      rc <- qt(CL / 2, df = n - 2, lower.tail = FALSE)
    }
    
    SE_Beta_1 <- sqrt(MSE / SXX)
    SE_Beta_0 <- sqrt(MSE * (1/n + mean(X)^2 / SXX))
    
    Upper_Beta_1 <- Beta_1 + rc * SE_Beta_1
    Lower_Beta_1 <- Beta_1 - rc * SE_Beta_1
    
    Upper_Beta_0 <- Beta_0 + rc * SE_Beta_0
    Lower_Beta_0 <- Beta_0 - rc * SE_Beta_0
    
    CI_results <- list(
      Upper_Beta_1 = Upper_Beta_1,
      Lower_Beta_1 = Lower_Beta_1,
      Upper_Beta_0 = Upper_Beta_0,
      Lower_Beta_0 = Lower_Beta_0
    )
    
    return(CI_results)
  }
  # Calculate Confidence Intervals for Y0 Mean Response
  calculate_CI_Y0_for_mean <- function(X0, Beta_0, Beta_1, MSE, SXX, X, CL) {
    Y0 <- Beta_0 + Beta_1 * X0
    
    if (n >= 30) {
      rc <- qnorm(CL / 2, mean = 0, sd = 1, lower.tail = FALSE)
    } else {
      rc <- qt(CL / 2, df = n - 2, lower.tail = FALSE)
    }
    
    SE_Y0 <- sqrt(MSE * (1/n + (X0 - mean(X))^2 / SXX))
    
    Upper_Y0 <- Y0 + rc * SE_Y0
    Lower_Y0 <- Y0 - rc * SE_Y0
    
    CI_results <- list(
      Upper_Y0 = Upper_Y0,
      Lower_Y0 = Lower_Y0
    )
    
    return(CI_results)
  }
  # Calculate Confidence Intervals for Y0 New Response
  calculate_CI_Y0_for_new <- function(X0, Beta_0, Beta_1, MSE, SXX, X, CL) {
    Y0 <- Beta_0 + Beta_1 * X0
    
    if (n >= 30) {
      rc <- qnorm(CL / 2, mean = 0, sd = 1, lower.tail = FALSE)
    } else {
      rc <- qt(CL / 2, df = n - 2, lower.tail = FALSE)
    }
    
    SE_Y0 <- sqrt(MSE * (1+ 1/n + (X0 - mean(X))^2 / SXX))
    
    Upper_Y0 <- Y0 + rc * SE_Y0
    Lower_Y0 <- Y0 - rc * SE_Y0
    
    CI_results <- list(
      Upper_Y0 = Upper_Y0,
      Lower_Y0 = Lower_Y0
    )
    
    return(CI_results)
  }
  # Calculate Confidence Intervals for Beta
  CI_Beta <- calculate_CI_Beta(Beta_1, Beta_0, MSE, SXX, X, CL=(1-(CL/100)))
  # Calculate Confidence Intervals for Y0 Mean Response
  X0_for_mean <- as.numeric(readline("Please enter the value to get its mean response confidence interval: "))
  CI_Y0_mean <- calculate_CI_Y0_for_mean(X0_for_mean, Beta_0, Beta_1, MSE, SXX, X, CL=(1-(CL/100)))
  # Calculate Confidence Intervals for Y0 New Obs
  X0_for_new <- as.numeric(readline("Please enter the value to get its new observation confidence interval: "))
  CI_Y0_new <- calculate_CI_Y0_for_new(X0_for_new, Beta_0, Beta_1, MSE, SXX, X, CL=(1-(CL/100)))
  # Print summary statistics
  Printing_Function <- function(SXX, Syy, SXy, Beta_1, Beta_0, SST, SSR, SSE, R_squared,anova_table, CI_Beta, CI_Y0_mean, Fc, F0) {
    # Print header
    cat("Summary statistics:\n")
    
    # Format and print each statistic
    cat(sprintf("  %-20s %.2f\n", "SXX:", SXX))
    cat(sprintf("  %-20s %.2f\n", "SYY:", Syy))
    cat(sprintf("  %-20s %.2f\n", "SXy:", SXy))
    cat(sprintf("  %-20s %.2f\n", "Beta One (Slope):", Beta_1))
    cat(sprintf("  %-20s %.2f\n", "Beta Zero (Intercept):", Beta_0))
    cat(sprintf("  %-20s %.2f\n", "SST:", SST))
    cat(sprintf("  %-20s %.2f\n", "SSR:", SSR))
    cat(sprintf("  %-20s %.2f\n", "SSE:", SSE))
    cat(sprintf("  %-20s %.2f%%\n", "R-squared:", round(R_squared * 100, 2)))
    cat(sprintf("  %-20s %.2f%%\n", "R-squared Adjusted:", round(R_Squared_adj * 100, 2)))
    
    
    # Add a separator
    cat("\n-----------------------------\n")
    
    # Print ANOVA table header
    cat("ANOVA table:\n")
    
    # Print ANOVA table with formatted columns
    print(kable(anova_table), right = FALSE)
    
    # Add a separator
    cat("\n-----------------------------\n")
    # Print test result
    cat("Test Result:\n")
    if (Fc > F0) {
      cat("H0: Beta 1 = 0\n")
      cat("Ha: Beta 1 != 0\n")
      cat("Result: There's no regression exist\n")
    } else {
      cat("H0: Beta 1 = 0\n")
      cat("Ha: Beta 1 != 0\n")
      cat("Result: There's regression exist\n")
    }

    # Add a separator
    cat("\n-----------------------------\n")
    
    # Print confidence intervals header
    cat("Confidence intervals:\n")
    
    # Format and print each confidence interval
    cat(sprintf("  %-20s %.2f < B1 < %.2f\n", "CI for Beta One:", CI_Beta$Lower_Beta_1, CI_Beta$Upper_Beta_1))
    cat(sprintf("  %-20s %.2f < B0 < %.2f\n", "CI for Beta Zero:", CI_Beta$Lower_Beta_0, CI_Beta$Upper_Beta_0))
    cat(sprintf("  %-20s %.2f < Y0 < %.2f\n", "CI for Y0 Mean Response:", CI_Y0_mean$Lower_Y0, CI_Y0_mean$Upper_Y0))
    cat(sprintf("  %-20s %.2f < Y0 < %.2f\n", "CI for Y0 New Response:", CI_Y0_new$Lower_Y0, CI_Y0_new$Upper_Y0))
    
    
    # Add a separator
    cat("\n-----------------------------\n")
    cat("Simple notes :-\n Blue is confidence interval of Beta one\nGreen for Confidence interval of Mean response\nYellow for Confidence interval of New observation")
  }
  # Run the print : 
  Printing_Function(SXX, Syy, SXy, Beta_1, Beta_0, SST, SSR, SSE, R_squared, anova_table, CI_Beta, CI_Y0_mean, Fc, F0)
  # Plotting Regression 
  plot(X, y, xlab = "X", ylab = "Y", main = "Linear Regression", pch = 16)
  abline(a = Beta_0, b = Beta_1, col = "red", lwd = 3)
  abline(v=CI_Beta$Lower_Beta_1,col="blue",lwd=3,lty="dotdash")
  abline(v=CI_Beta$Upper_Beta_1,col="blue",lwd=3,lty="dotdash")
  abline(v = CI_Y0_mean$Lower_Y0, col = "green", lwd = 3, lty = "dashed")
  abline(v = CI_Y0_mean$Upper_Y0, col = "green", lwd = 3, lty = "dashed")
  abline(v = CI_Y0_new$Lower_Y0, col = "yellow", lwd = 3, lty = "dashed")
  abline(v = CI_Y0_new$Upper_Y0, col = "yellow", lwd = 3, lty = "dashed")
  legend("topright", legend = "Regression Line", col = "red", lwd = 3)
}
MLR <- function(Data){
  # Getting needed data
  data <- as.matrix(Data)
  n_row <- nrow(Data)
  big_x <- cbind(b0 = rep(1, n_row), data)
  n_col <- length(colnames(big_x))
  X <- big_x[,-n_col]
  y <- subset(big_x, select = n_col)
  # Constructing Matrices 
  X_transpose <- t(X)
  Y_transpose <- t(y)
  X_transpose_X <- X_transpose%*%X
  C <- X_transpose_X_Inverse <- solve(X_transpose_X)
  # Calculating Betas
  Betas <- X_transpose_X_Inverse%*%X_transpose%*%y
  Betas_Transpose <- t(Betas)
  # Predicted Y 
  Y_prediction <- X%*%Betas
  # Calculating sum of squares (Regression, Error, Total)
  SST <- Y_transpose%*%y - n_row*mean(y)^2
  SSE <- Y_transpose%*%y - Betas_Transpose%*%X_transpose%*%y
  SSR <- SST-SSE
  # Number of independents and parameters
  k <- ncol(X)-1
  p <- k + 1
  # Degree of Freedooms
  DOR <- k
  DOE <- n_row-p
  DOT <- n_row-1
  # Calculating mean squares (Regression, Error, Total)
  MSR <- SSR/DOR
  MSE <- SSE/DOE
  MST <- SST/DOT
  # Result of F0
  F0 <- MSR/MSE
  # Create ANOVA table
  anova_table <- data.frame(
    Type = c("Regression", "Error", "Total"),
    SS = c(SSR, SSE, SST),
    DF = c(DOR, DOE,DOT),
    MS = c(MSR, MSE, ""),
    F0 = c(F0, "", "")
  )
  kable(anova_table)  
  # Confidence level input
  CL <- as.numeric(readline("Please choose your confidence level: "))
  # Performing Test for checking if regression Exist or no
  Fc<- qf((1-(CL/100)), DOR, DOE)
  # Calculate the value of R-squared
  R_squared <- SSR / SST
  R_Squared_adj <- 1-((SSE/DOE)/(SST/DOT))
  # Calculate Confidence Intervals for Beta
  calculate_CI_Beta <- function(Betas, MSE, DOE, CL) {
    # Reliability Coefficient
    rc <- qt((1-(CL/100) / 2), df = DOE, lower.tail = FALSE)
    
    CI_results <- list()  # Initialize an empty list to store results
    
    for (i in 1:length(Betas)) {
      SE_Betas <- sqrt(MSE %*% C[i, i])  # C is the Inverse matrix
      Upper_Betas <- Betas[i] + rc * SE_Betas
      Lower_Betas <- Betas[i] - rc * SE_Betas
      
      CI_results[[i]] <- list(
        Upper_Betas = Upper_Betas,
        Lower_Betas = Lower_Betas
      )
    }
    
    return(CI_results)
  }
  # Calculate Confidence Intervals for Y0 Mean Response
  calculate_CI_Y0_mean <- function(Betas,C, MSE, DOE, CL) {
    # Reliability Coefficient
    rc <- qt(1-(CL/100) / 2, df = DOE, lower.tail = FALSE)
    
    CI_results <- list()  # Initialize an empty list to store results
    X0_input <- matrix(nrow = length(colnames(X))-1,ncol = 1)
    for (i in 1:(length(colnames(X))-1)) {
      X0_input[i] <- as.numeric(readline(paste("Please put the value of" , colnames(X)[i+1]," to calculate your mean response for this observation: ")))
    }
    # Needed X0
    X0 <- rbind(1,X0_input)
    # Transpose of X0
    X0_transpose <- t(X0)
    # The predicted Value 
    Y0 <- X0_transpose %*% Betas
    SE_Y0_Mean <- sqrt(MSE*(X0_transpose%*%C%*%X0))  
    Upper_Y0_Mean <- Y0 + rc * SE_Y0_Mean
    Lower_Y0_Mean <- Y0 - rc * SE_Y0_Mean
    
    CI_results <- list(
      Upper_Y0_Mean = Upper_Y0_Mean,
      Lower_Y0_Mean = Lower_Y0_Mean
    )
    
    return(CI_results)
  }
  # Calculate Confidence Intervals for Y0 New Response
  calculate_CI_Y0_new <- function(Betas,C, MSE, DOE, CL) {
    # Reliability Coefficient
    rc <- qt(1-(CL/100) / 2, df = DOE, lower.tail = FALSE)
    
    CI_results <- list()  # Initialize an empty list to store results
    X0_input <- matrix(nrow = length(colnames(X))-1,ncol = 1)
    for (i in 1:(length(colnames(X))-1)) {
      X0_input[i] <- as.numeric(readline(paste("Please put the value of" , colnames(X)[i+1],"to calculate your new observation: ")))
    }
    # Needed X0
    X0 <- rbind(1,X0_input)
    # Transpose of X0
    X0_transpose <- t(X0)
    # The predicted Value 
    Y0 <- X0_transpose %*% Betas
    SE_Y0_new <- sqrt(MSE * (1+X0_transpose%*%C%*%X0))  
    Upper_Y0_new <- Y0 + rc * SE_Y0_new
    Lower_Y0_new <- Y0 - rc * SE_Y0_new
    
    CI_results <- list(
      Upper_Y0_new = Upper_Y0_new,
      Lower_Y0_new = Lower_Y0_new
    )
    
    return(CI_results)
  }
  # Calculate Confidence Intervals for Beta
  CI_Beta <- calculate_CI_Beta(Betas, MSE, DOE,CL=(1-(CL/100)))
  # Calculate Confidence Intervals for Y0 Mean Response
  CI_Y0_mean <- calculate_CI_Y0_mean(Betas, C, MSE, DOE, CL=(1-(CL/100)))
  # Calculate Confidence Intervals for Y0 New Obs
  CI_Y0_new <- calculate_CI_Y0_new(Betas, C, MSE, DOE, CL=(1-(CL/100)))
  # Calculating Error 
  di <- (y - Y_prediction)/sqrt(MSE[1]) 
  # Performing dimensionality reduction using Partial F test
  partial_f_test <- function(Data,CL,DOE,n_row,n_col) {
    for (i in 1:(n_col - 2)) {
      matrixed_data <- as.matrix(Data)
      matrixed_data_without_y <- matrixed_data[,-(n_col)]
      matrixed_data_with_subtracted_column <- matrixed_data_without_y[, -i]
      cat("H0:",colnames(matrixed_data_without_y)[i], "= 0\n")
      cat("H1:",colnames(matrixed_data_without_y)[i], "!= 0\n")
      big_x_r <- cbind(b0 = rep(1, n_row), matrixed_data_with_subtracted_column)
      x_reduced <- big_x_r[, -ncol(big_x_r)]
      y_reduced <- subset(matrixed_data_with_subtracted_column, select = ncol(matrixed_data_with_subtracted_column))
      X_t_r <- t(x_reduced)
      X_transpose_X_r <- X_t_r %*% x_reduced
      X_transpose_X_r_inerse <- solve(X_transpose_X_r)
      X_transpose_y_r <- X_t_r %*% y_reduced
      betas_reduced <- X_transpose_X_r_inerse %*% (X_t_r %*% y_reduced)
      y_hat_reduced <- x_reduced %*% betas_reduced
      betas_t_r <- t(betas_reduced)
      betas_x_t_r <- betas_t_r %*% X_t_r
      SSE_reduced <- (t(y_reduced) %*% y_reduced) - (betas_x_t_r %*% y_reduced)
      SST_reduced <- (t(y_reduced) %*% y_reduced) - n_row * (mean(y_reduced))^2
      SSR_reduced <- SST_reduced - SSE_reduced
      R_squared_adj_r <- SSR_reduced/SST_reduced
      F_node_reduced <- (SSR[1] - SSR_reduced[1]) / MSE[1]
      F_calc_reduced <- qf(1-(CL/100), 1, DOE)
      if (F_node_reduced > F_calc_reduced) {
        cat("Reject H0, then the model depends on",colnames(matrixed_data_without_y)[i], "\n\n")
      } else {
        cat("Failed to reject H0, then the model doesn't depend on",colnames(matrixed_data_without_y)[i], "\n")
      }
      cat("And it's accuracy by removing ",colnames(matrixed_data_without_y)[i]," = ",round(R_squared_adj_r*100,2),"\n\n")
    }
  }
  
  # Print summary statistics
  Printing_Function <- function(X,y,Y_prediction,C,SST, SSR, SSE, R_squared,R_Squared_adj,anova_table,F0,Fc, CI_Beta, CI_Y0_mean) {
    # Print header
    cat("Summary statistics:\n")
    # Format and print each statistic
    cat("Design Matrix :")
    print(kable(X))
    cat("Inverse Matrix:")
    print(kable(C))
    cat("Target Values:")
    print(kable(y))
    cat("Beta values for each independent variable")
    print(kable(Betas))
    cat("Predicted Values:")
    print(kable(Y_prediction))
    cat("Error :")
    print(kable(di))
    
    cat("\n-----------------------------\n")
    cat(sprintf("  %-20s %.2f\n", "SST:", SST))
    cat(sprintf("  %-20s %.2f\n", "SSR:", SSR))
    cat(sprintf("  %-20s %.2f\n", "SSE:", SSE))
    cat(sprintf("  %-20s %.2f%%\n", "R-squared:", round(R_squared * 100, 2)))
    cat(sprintf("  %-20s %.2f%%\n", "R-squared Adjusted :", round(R_Squared_adj * 100, 2)))
    
    
    # Add a separator
    cat("\n-----------------------------\n")
    
    # Print ANOVA table header
    cat("ANOVA table:\n")
    
    # Print ANOVA table with formatted columns
    print(kable(anova_table), right = FALSE)
    
    # Add a separator
    cat("\n-----------------------------\n")
    
    # Print test result
    cat("Test Result:\n")
    cat("H0: Beta 1 = Beta 2 = Beta 3 = Beta n = 0\n")
    cat("Ha: At least one beta is not equal to 0\n")
    if (F0 > Fc) {
      cat("Result: Regression exists\n")
    } else {
      cat("Result: No regression exists\n")
    }
    
    # Add a separator
    cat("\n-----------------------------\n")
    
    # Print confidence intervals header
    cat("Confidence intervals:\n")
    
    # Format and print each confidence interval
    # Print confidence intervals for each beta coefficient
    for (i in 1:(length(Betas)-1)) {
      cat(sprintf("  CI for %s: %.2f > B > %.2f\n", colnames(X)[i+1], CI_Beta[[i+1]]$Lower_Betas, CI_Beta[[i+1]]$Upper_Betas))
    }
    
    cat(sprintf("  %-20s %.2f > Y0 > %.2f\n", "CI for Y0 Mean Response:", CI_Y0_mean$Lower_Y0_Mean, CI_Y0_mean$Upper_Y0_Mean))
    cat(sprintf("  %-20s %.2f > Y0 > %.2f\n", "CI for Y0 New Observation:", CI_Y0_new$Lower_Y0_new, CI_Y0_new$Upper_Y0_new))
    
    # Add a separator
    cat("\n-----------------------------\n")
    cat("Testing if there exist any column can be removed from data\n") 
    partial_f_test(Data,CL,DOE,n_row,n_col)
    # Add a separator
    cat("\n-----------------------------\n")
  }
  # Run the print : 
  Printing_Function(X,y,Y_prediction,C,SST, SSR, SSE, R_squared,R_Squared_adj,anova_table,F0,Fc, CI_Beta, CI_Y0_mean)
  # Plotting Regression 
  Plot_Function <- function(){
    par(mfrow = c(1, 2))
    
    # Plotting X and Y
    plot(X[, 2], y, main = "Linear Regression", xlab = "", ylab = "Y", sub = "These are the results of comparison between \nReal values and Predicted values")
    points(X[, 2], Y_prediction, col = "red")  # Overlay predicted values
    
    # Plotting error
    plot(di, xlim = c(10, -10), ylim = c(10, -10), main = "Error Scales",xlab = "", ylab = "Error values", sub = "All values within the general \nstandard error range (-3 and 3) are considered non-outliers.")
    abline(h = c(3, -3), col = "red")
    
  }
  Plot_Function()
}
repeat {
  path <- noquote(file.choose())
  Data <- read.csv(path)
  
  value_of_format <- as.numeric(readline("Which type of Data do you need? :\n1-CSV\n2-Excel\n3-Json\n4-XML\n5-SQL\n6-SAS\n7-SPSS\n8-Feather\n"))
  
  Data <- switch(value_of_format,
                 read.csv(path),
                 read_excel(path),
                 fromJSON(path),
                 xmlTreeParse(file = path),
                 sqlQuery(con(odbcConnect(path)), "SELECT * FROM MY TABLE"),
                 read_sas(path),
                 read_spss(path),
                 read_feather(path),
                 stop("Invalid input. Please choose one of the options above.")
  )
  
  value_of_regression <- as.numeric(readline("Which type of method do you need?\n1-SLR (Simple Linear Regression)\n2-MLR (Multiple Linear Regression)\n"))
  
  switch(value_of_regression,
         SLR = {
           SLR(Data)
         },
         MLR = {
           MLR(Data)
         },
         stop("Invalid input. Please choose one of the options above.")
  )
  
  continue <- readline("Do you want to continue? (y/n): ")
  if (tolower(continue) != "y") {
    cat("Thanks for using my programme, see you soon! ")
    break  # Break the loop if the user does not want to continue
  }
}
