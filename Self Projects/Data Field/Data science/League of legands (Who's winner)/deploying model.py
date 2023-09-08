import streamlit as st
import pickle
import numpy as np

def load_model(path):
    with open(path, 'rb') as file:
        model = pickle.load(file)
    return model

tree = load_model('tree.pkl')
rf = load_model('rf.pkl')

game = {
    "feature": ["first_blood", "first_tower", "first_inhibitor", "first_Baron", "first_Dragon", "first_RiftHerald",
                "t1_tower", "t1_inhibitor", "t1_baron", "t1_dragon", "t2_tower", "t2_inhibitor", "t2_baron",
                "t2_dragon"]
}


st.set_page_config(
    page_title="Game Features Prediction",
    layout="wide",
    initial_sidebar_state="expanded"
)

def lol_def():
    # Set Streamlit app title
    st.title('League of Legends Ranked Games Dataset')
    # Set Image 
    st.image("lol.png")
    # Game Details Section
    st.header('Game Details')

    st.markdown('''\
    This dataset comprises over 50,000 ranked EUW (Europe West) games from the popular game League of Legends. 
    In addition to the game records, there are accompanying JSON files that facilitate the conversion between champion and summoner spell IDs and their corresponding names.
    ''',unsafe_allow_html=True)

    st.markdown('''\
    - **Game ID**: A unique identifier for each game.
    - **Creation Time**: The timestamp when the game was created, in Epoch format.
    - **Game Duration**: The duration of the game in seconds.
    - **Season ID**: Identifies the season in which the game took place.
    - **Winner**: Indicates the winning team (1 for team1, 2 for team2).
    - **First Baron, Dragon, Tower, Blood, Inhibitor, and Rift Herald**: Specifies which team secured these objectives (1 for team1, 2 for team2, 0 for none).
    - **Champions and Summoner Spells**: The champions and summoner spells chosen by each team, stored as Riot's champion and summoner spell IDs.
    - **Number of Objectives Kills**: The number of tower, inhibitor, Baron, dragon, and Rift Herald kills for each team.
    - **Bans**: The five champion bans made by each team, using champion IDs.
    ''',unsafe_allow_html=True)

    # Data Collection Section
    st.header('Data Collection')

    st.markdown('''\
    This comprehensive dataset was collected using the Riot Games API, which simplifies the retrieval of user-ranked history and game records. 
    However, obtaining a list of usernames can be a challenging task. 
    In this case, a list of usernames was obtained by scraping third-party League of Legends websites.
    ''')

    st.markdown('''\
    Please note that this dataset provides valuable insights into League of Legends gameplay and statistics and can be used for various analytical purposes.
    If you intend to create a data analysis or visualization tool using this dataset, make sure to handle data preprocessing and visualization as needed.
    ''')


def main():
        run = st.toggle(label="Run the Program!")
        if run:
            st.title("Game Features Prediction")
            selected_values = []

            # Organize elements into two columns
            col1, col2 = st.columns(2)

            # Add inputs to the first column
            with col1:
                for feature in game["feature"]:
                    if feature.startswith("first"):
                        label = feature.replace("_", " ").capitalize()
                        selected_value = st.selectbox(label, [1, 2], key=feature, help="Select the value")
                    else:
                        label = feature.replace("_", " ").capitalize()
                        if "tower" in feature:
                            selected_value = st.selectbox(label, list(range(0, 13)), key=feature, help="Select the value")
                        elif "inhibitor" in feature:
                            selected_value = st.selectbox(label, list(range(0, 4)), key=feature, help="Select the value")
                        elif "baron" in feature:
                            selected_value = st.selectbox(label, list(range(0, 6)), key=feature, help="Select the value")
                        elif "dragon" in feature:
                            selected_value = st.selectbox(label, list(range(0, 11)), key=feature, help="Select the value")

                    selected_values.append(selected_value)
                    results = np.array(selected_values).reshape(1, -1)  # Reshape to 2D array

            # Add buttons to the second column with styling
            with col2:
                button_for_tree = st.button("Predict using Decision Tree", key="tree_button")
                button_for_rf = st.button("Predict using Random Forest", key="rf_button")
                if button_for_tree:
                    st.write("Predicting using Decision Tree...")
                    # Add your prediction logic using the 'tree' model here
                    st.write(f"The Prediction Using First model saying,,, that first team win rate for the game will be = {tree.predict_proba(results)[0][0]:.0%}, while second team will be {tree.predict_proba(results)[0][1]:.0%} win rate!!,so we can say that the winner is team number {tree.predict(results)}")
                elif button_for_rf:
                    st.write("Predicting using Random Forest...")
                    # Add your prediction logic using the 'rf' model here
                    st.write(f"The Prediction Using Second model saying,,, that first team win rate for the game will be = {rf.predict_proba(results)[0][0]:.0%}, while second team will be {rf.predict_proba(results)[0][1]:.0%} win rate!!,so we can say that the winner is team number {rf.predict(results)}")
                st.image(image="lol.jpg")

        else:
            lol_def()

if __name__ == '__main__':
    main()
