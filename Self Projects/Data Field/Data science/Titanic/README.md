## Dataset Description

### Overview
The data has been split into two groups:

- Training set (train.csv)
- Test set (test.csv)

The training set should be used to build your machine learning models. For the training set, we provide the outcome (also known as the “ground truth”) for each passenger. Your model will be based on “features” like passengers’ gender and class. You can also use feature engineering to create new features.

The test set should be used to see how well your model performs on unseen data. For the test set, we do not provide the ground truth for each passenger. It is your job to predict these outcomes. For each passenger in the test set, use the model you trained to predict whether or not they survived the sinking of the Titanic.

We also include `gender_submission.csv`, a set of predictions that assume all and only female passengers survive, as an example of what a submission file should look like.

### Data Dictionary

| Variable  | Definition           | Key                                      |
|-----------|----------------------|------------------------------------------|
| survival  | Survival             | 0 = No, 1 = Yes                          |
| pclass    | Ticket class         | 1 = 1st, 2 = 2nd, 3 = 3rd                |
| sex       | Sex                  |                                          |
| Age       | Age in years         |                                          |
| sibsp     | # of siblings/spouses aboard the Titanic |                                  |
| parch     | # of parents/children aboard the Titanic |                                  |
| ticket    | Ticket number        |                                          |
| fare      | Passenger fare       |                                          |
| cabin     | Cabin number         |                                          |
| embarked  | Port of Embarkation  | C = Cherbourg, Q = Queenstown, S = Southampton |


### Understanding the Code

#### Importing Libraries
The code starts by importing necessary libraries such as Pandas, Matplotlib, NumPy, LabelEncoder, RandomForestClassifier, GridSearchCV, and suppressing warnings.

#### Data Wrangling
- The `wrangle` function is defined to read the train data, perform some initial data exploration (e.g., printing the head, info, and statistics), categorize passengers into age categories, create a 'Family_Size' column, and determine if a passenger is 'Alone' or not. It returns the modified train DataFrame.
- The `train` and `test` DataFrames are created using the `wrangle` function for the training and test datasets, respectively.
- The code also separates male and female passengers into the `male` and `female` DataFrames.

#### Exploratory Data Analysis (EDA)
- The code calculates and prints the percentage of survivors for females and males.
- It visualizes the number of passengers who survived or died by age category and sex using a bar chart.
- It plots a pie chart to show the distribution of survivors by ticket class (Pclass).
- It creates a bar chart to display the number of survivors by family size.

#### Data Visualization
- A heatmap of the correlation matrix for numeric columns in the dataset is plotted.

#### Building the Model
- A list of selected features is defined.
- X_train, X_test, and y_train are defined by selecting the specified features and one-hot encoding categorical variables.
- A RandomForestClassifier is initialized with a random state of 42.
- Hyperparameters and their values to be tuned are defined in the `param_grid` dictionary.
- GridSearchCV is used to perform hyperparameter tuning with 5-fold cross-validation.
- The best hyperparameters and the best estimator (model) are printed.
- The accuracy score of the model on the training data is printed.
- Finally, predictions are made on the test data using the best model, and the results are saved to a CSV file named 'submission.csv'.

#### Conclusion
The code provided performs various data preprocessing steps, exploratory data analysis, and builds a machine learning model (Random Forest) to predict the survival of passengers on the Titanic based on features like class, gender, family size, and more.

This code demonstrates a typical workflow for a machine learning competition where the goal is to predict outcomes on a test dataset using a trained model.

You can further enhance the documentation by adding explanations for specific parts of the code, or any additional insights or observations from the EDA and model building process.
