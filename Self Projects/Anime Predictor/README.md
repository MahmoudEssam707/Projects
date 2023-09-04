# Anime Recommendation System

The Anime Recommendation System is a Python project that uses collaborative filtering to recommend anime to users based on their viewing history and ratings. It utilizes a dataset containing information from 73,516 users on 12,294 anime titles. This README file provides an in-depth overview of the project, including dataset details, requirements, usage instructions, data cleaning, visualization, recommendation system, and more.

![Anime Recommendation System](https://storage.googleapis.com/kaggle-datasets-images/1225408/2045512/556c46d136da51c2ac6690b199f1c6e5/dataset-cover.jpeg?t=2021-03-21-23-20-40.png)

## Table of Contents

- [Dataset](#dataset)
- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
- [Data Cleaning and Preprocessing](#data-cleaning-and-preprocessing)
- [Data Visualization](#data-visualization)
- [Anime Genre Analysis](#anime-genre-analysis)
- [Recommendation System](#recommendation-system)
- [Example Recommendations](#example-recommendations)
- [Contributing](#contributing)
- [License](#license)

## Dataset

The dataset used in this project can be found on Kaggle: [Anime Recommendations Database](https://www.kaggle.com/datasets/CooperUnion/anime-recommendations-database). It consists of two main CSV files: `anime.csv` and `rating.csv`.

### Features

#### `anime.csv`

- `anime_id`: Unique ID for each anime on MyAnimeList.net.
- `name`: Full name of the anime.
- `genre`: Comma-separated list of genres for the anime.
- `type`: Type of anime (e.g., movie, TV, OVA).
- `episodes`: Number of episodes in the show (1 if it's a movie).
- `rating`: Average rating out of 10 for the anime.
- `members`: Number of community members associated with this anime.

#### `rating.csv`

- `user_id`: Non-identifiable randomly generated user ID.
- `anime_id`: The anime that the user has rated.
- `rating`: Rating out of 10 assigned by the user (-1 if the user watched it but didn't assign a rating).

## Requirements

To run the Anime Recommendation System, you'll need the following libraries and tools:

- Python 3.x
- Libraries: pandas, numpy, matplotlib, seaborn, scikit-learn, wordcloud, tabulate, tkinter (for file dialog)

You can install these libraries using pip:

```shell
pip install pandas numpy matplotlib seaborn scikit-learn wordcloud tabulate
git clone https://github.com/yourusername/anime-recommendation-system.git
cd anime-recommendation-system
python anime_recommendation.py
```

# Data Cleaning and Preprocessing

The script performs data cleaning and preprocessing, handling missing values, duplicates, and text cleaning.

# Data Visualization

Explore various data visualizations, including bar plots and histograms, to understand anime popularity and user ratings.

# Anime Genre Analysis

Discover the most common anime genres using a word cloud visualization.

# Recommendation System

The recommendation system uses collaborative filtering with Nearest Neighbors and cosine similarity to recommend anime titles to users based on their preferences.

# Example Recommendations

See an example of how to find anime recommendations for a specific title.

# Contributing

Contributions to this project are welcome! If you have any improvements, bug fixes, or new features to add, please open an issue or create a pull request.

# License

See the [LICENSE](https://creativecommons.org/publicdomain/zero/1.0/) file for details.
