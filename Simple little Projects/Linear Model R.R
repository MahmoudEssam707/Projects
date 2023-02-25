# Simple Linear Regression Model, with simple example
Data_Frame <- data.frame (
    X = c(0, 1, 2),
    y = c(1, 0, 2)
  )
# The bar value of X
X_bar <- mean(Data_Frame$X)
# The bar value of y
y_bar <- mean(Data_Frame$y)
# The summation of X values
X_sum <- sum(Data_Frame$X)
# The summation of y values
y_sum <- sum(Data_Frame$y)
# The square values of x
X_squared <- (Data_Frame$X)^2
# The squared value of X bar
X_bar_squared <- X_bar^2
# The Multiplication of X and Y values
XY <- Data_Frame$X*Data_Frame$y
# The summation of XY values
XY_sum <- sum(XY)
# Length of the data frame "you can assign x or y because both are same length"
n <- length(Data_Frame$X)
# "Model of linear = intercept + Slope*X" 
# Intercept value "beta node value"
intercept <- function(XY_sum,n,X_bar,y_bar,X_squared,X_bar_squared){
  (XY_sum - n*X_bar*y_bar)/(sum(X_squared)-n*X_bar_squared)
}
slope <- function(y_mean,Beta_one,X_bar){
    y_mean-(Beta_one*X_bar)
  }
# Assign the value into Beta one
Beta_one <- intercept(XY_sum,n,X_bar,y_bar,X_squared,X_bar_squared)
# Assign the value into Beta node
Beta_node <- slope(y_bar,Beta_one,X_bar)
# Generate the model
Model <- Beta_node + Beta_one*Data_Frame$X
# The Error values ei = Y - Y_pred
ei <- Data_Frame$y - Model
# Done your model !