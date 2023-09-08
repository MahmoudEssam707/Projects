# League of Legends Predictive Model

![League of Legends](lol.png)

## Abstract

League of Legends is a popular online multiplayer game where two teams compete to destroy each other's Nexus while overcoming various challenges and objectives. This project aims to predict the outcome of League of Legends ranked games based on in-game features. We have developed two machine learning models, a Decision Tree classifier, and a Random Forest classifier, to determine the winning team based on these features.

## Table of Contents

- [Introduction](#introduction)
- [Data](#data)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
- [Building the Model](#building-the-model)
- [Usage](#usage)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)

## Introduction

League of Legends is known for its complexity and competitiveness. Understanding which in-game features contribute to a team's victory is crucial for both players and analysts. In this project, we use a dataset of over 50,000 ranked EUW (Europe West) games to train predictive models that can forecast game outcomes based on events such as first blood, first tower, and more.

## Data

The dataset contains detailed information about each game, including game duration, season ID, which team secured objectives like first blood, first tower, first inhibitor, and various other factors that may influence the game's outcome.

## Exploratory Data Analysis (EDA)

Before building the predictive models, we perform exploratory data analysis (EDA) to gain insights into the dataset. EDA includes visualizations and statistical summaries that help us understand the relationships between different variables and their impact on game results.

## Building the Model

We have developed two machine learning models:

### 1. Decision Tree Classifier

The Decision Tree classifier is trained to predict the winning team based on in-game features. We optimize its hyperparameters, including criteria for splitting nodes, maximum tree depth, and minimum samples required for splits and leaves, and achieved 96% accuracy.

### 2. Random Forest Classifier

The Random Forest classifier is an ensemble model that combines multiple Decision Trees. Similar to the Decision Tree, we optimize its hyperparameters to ensure the best performance,and achieved 97% accuracy.

Both models are evaluated using accuracy on a separate test dataset.

## Usage

To use our predictive models, follow these steps:

1. Run the Streamlit app using the command `streamlit run app.py`.
2. Input game details, such as first blood, first tower, etc., in the app interface.
3. Click either the "Predict using Decision Tree" or "Predict using Random Forest" button to obtain predictions for the winning team.

## Results

Our models provide predictions for the winning team based on the provided in-game features. Additionally, they estimate the win probabilities for each team. You can use these predictions to gain insights into which team is likely to win a League of Legends game based on specific events.

## Contributing

Contributions to this project are welcome! You can contribute by improving the models, adding more features, enhancing the Streamlit app, or providing valuable insights related to League of Legends analytics. Feel free to open issues and pull requests to contribute to this project.

## License

This project is licensed under the MIT License, which allows open collaboration and usage while attributing the original work to the authors.

We hope that this project will aid both League of Legends enthusiasts and data analysts in gaining deeper insights into the game and improving their strategies.
