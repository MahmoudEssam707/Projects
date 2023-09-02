import streamlit as st
import pandas as pd

# Sidebar with options
st.sidebar.header('Options')
selected_option = st.sidebar.selectbox('Select an option:', 
                                        ('Overview', 'Most Information needed from data',
                                         "Details analysed for store",
                                        'Feedbacks and Requirements for Improvement',                                            
                                        ))

## Overview section
if selected_option == 'Overview':
    st.image(r"Images/Logos/Walmart Logo.png")
    st.header("Walmart Main Details")
    st.markdown("Walmart runs several promotional markdown events throughout the year. "
                "These markdowns precede prominent holidays, including the Super Bowl, "
                "Labour Day, Thanksgiving, and Christmas. These holiday weeks are weighted "
                "five times higher in the evaluation than non-holiday weeks.")
    st.markdown("The historical sales data covers sales from 2010-02-05 to 2012-11-01 "
                "and includes information about 45 Walmart stores located in different regions.")
    st.header("Attributes Included in the Data")
    st.markdown("The dataset contains the following attributes:")
    st.write("• **Store**: The store number")
    st.write("• **Date**: The date of the sales data")
    st.write("• **Weekly Sales**: The weekly sales amount")
    st.write("• **Holiday Flag**: 0 for regular weeks, 1 for special holidays")
    st.write("• **Temperature**: Temperature at the store location")
    st.write("• **Fuel Price**: Fuel price in the region")
    st.write("• **CPI**: Consumer Price Index")
    st.write("• **Unemployment**: Unemployment rate in the region")
    st.header("Objective")
    st.markdown("Walmart's focus is on increasing revenue based on historical data analysis.")
    st.header("Data Period")
    st.markdown("The dataset covers sales from 2010-02-05 to 2012-11-01.")
    st.header("Holiday Weighting")
    st.markdown("The weeks including Super Bowl, Labour Day, Thanksgiving, and Christmas holidays "
                "are weighted five times higher in the evaluation than non-holiday weeks.")
    ## Startup section
if selected_option == 'Most Information needed from data':
    # Read the wrangled data from the CSV file
    wrangled_data = pd.read_csv(r"Data/After_Wrangling.csv")
    wrangled_data.drop(columns=["Unnamed: 0"],inplace=True)
    # Check if the user wants to display the data
    Choice_Of_Result_Or_Image = st.radio(label="Choose what you need",options=["Show Data and Details","Show Startup Image"])
    if Choice_Of_Result_Or_Image == "Show Data and Details":
        # Display the description of the data wrangling process in markdown
        # Data Overview
        st.header("Data Overview")
        st.write("Here is a brief overview of the dataset:")
        st.subheader("Total Rows")
        st.write("6,435")
        st.subheader("Columns")
        st.write("8")

        st.subheader("Data Columns")
        st.write("1. **Store:** Store number (integer).\n"
                "2. **Date:** Date of sales data (date).\n"
                "3. **Weekly Sales:** Sales for the week (float).\n"
                "4. **Holiday Flag:** Indicates if it's a holiday week (0 for no, 1 for yes).\n"
                "5. **Temperature:** Temperature in the region (float).\n"
                "6. **Fuel Price:** Fuel price in the region (float).\n"
                "7. **CPI:** Consumer Price Index (float).\n"
                "8. **Unemployment:** Unemployment rate (float).")

        st.subheader("Data Types")
        st.write("- Integer: 2 columns\n"
                "- Float: 5 columns\n"
                "- Date: 1 column")

        ## Data Quality
        st.header("Data Quality")
        st.write("Here is an assessment of data quality:")
        st.subheader("Null Values")
        st.write("There are no null values in the dataset.")

        st.subheader("Duplicates")
        st.write("There are no duplicate rows in the dataset.")

        ## Sample Data
        st.header("Sample Data")
        st.write("Here's a sample of the dataset:")
        st.dataframe(data=wrangled_data.head(20))
        st.text("")
   
    elif Choice_Of_Result_Or_Image == "Show Startup Image":

        # Explanations for the image visualizations
        st.markdown("### Weekly Sales Distribution")
        st.write("- This histogram represents the distribution of weekly sales data for Walmart stores.")
        st.write("- The x-axis represents the range of weekly sales values, divided into 15 bins.")
        st.write("- The y-axis shows the frequency of occurrences of weekly sales values within each bin.")
        st.write("- The yellow bars represent the distribution of weekly sales data.")

        st.markdown("### Unemployment Distribution")
        st.write("- This histogram displays the distribution of unemployment rates.")
        st.write("- The x-axis represents the range of unemployment values, divided into 15 bins.")
        st.write("- The y-axis shows the frequency of occurrences of unemployment rates within each bin.")
        st.write("- The dark green bars represent the distribution of unemployment data.")

        st.markdown("### Temperature Distribution")
        st.write("- This box plot represents the distribution of temperature data.")
        st.write("- The x-axis represents the temperature values.")
        st.write("- The box plot includes elements such as the median (line inside the box), quartiles (box edges), and outliers (dots outside the box).")
        st.write("- The 'showmeans' parameter indicates the mean temperature value.")

        st.markdown("### Fuel Price Distribution")
        st.write("- This histogram illustrates the distribution of fuel prices in the dataset.")
        st.write("- The x-axis represents the range of fuel prices, divided into 15 bins.")
        st.write("- The y-axis shows the frequency of occurrences of fuel prices within each bin.")
        st.write("- The dark red bars represent the distribution of fuel price data.")

        st.markdown("### CPI Distribution")
        st.write("- This box plot displays the distribution of the Consumer Price Index (CPI) values.")
        st.write("- The x-axis represents the CPI values.")
        st.write("- The box plot includes elements such as the median (line inside the box), quartiles (box edges), and outliers (dots outside the box).")
        st.write("- The 'showmeans' parameter indicates the mean CPI value.")
        st.image("Images/environment_visualizations.png", output_format="auto")
if selected_option == 'Details analysed for store':
    options=['Which store has maximum sales?', 'Which store the sales vary a lot on?', 'Relation between sales and other numeric values?', 'Years,Months, Which year was the best?','Holidays vs Non-Holidays, and Weekly sales','Revenues per Seasons',]
    Options_For_Market = st.radio(label="Choose From Next Choices Please",options=options)
    if Options_For_Market == options[0]:
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Which Store Has Maximum Revenues?</h1>", unsafe_allow_html=True)
        st.subheader("Here, we'll show you the best-performing stores, sorted by revenue:")
        
        # Load the data
        Store_With_Maximum_Sales = pd.read_csv(r"Data\Store_With_Maximum_Sales.csv").head()
        
        # Display the data in a table
        st.table(Store_With_Maximum_Sales)
                
        # Explanation of the bar plot visualization
        st.write("- This bar plot displays the stores with the maximum weekly sales.")
        st.write("- Each bar represents a store, and the height of the bar corresponds to its total weekly sales.")
        st.write("- The stores are sorted in descending order based on weekly sales.")
        st.write("- The store with the highest weekly sales is highlighted in green.")
        st.markdown("<h2 style='text-align: center; font-size: 25px; font-weight: bold;'>Visualizing the Best Store</h2>", unsafe_allow_html=True)

        # Display the bar plot image
        st.image(r"Images\Max_Store_Weekly_Sales.png")
        
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>The Best Maximum store is Store Number 20</p>", unsafe_allow_html=True)
        
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Maximum Store",
            data=open("Data/Store_With_Maximum_Sales.csv", "rb").read(),
            file_name="Store_With_Maximum_Sales.csv",
            key="download-csv-button"
        )
    if Options_For_Market == options[1]:
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Which Store Has Most Varied Revenues per week?</h1>", unsafe_allow_html=True)
        st.subheader("Here, we'll show you the Best varied store, sorted by most one vary")
        
        # Load the data
        Store_With_Varianced_Values = pd.read_csv(r"Data\S_With_Varianced_Weekly_Sales.csv").head()
        
        # Display the data in a table
        st.table(Store_With_Varianced_Values)
                
        st.markdown("### Store with Maximum Weekly Sales Variance")
        st.write("- This bar plot displays the stores with the maximum variance in weekly sales.")
        st.write("- Each bar represents a store, and the height of the bar corresponds to the variance of its weekly sales.")
        st.write("- The stores are sorted in descending order based on weekly sales variance.")
        st.write("- The store with the highest variance in weekly sales is highlighted in purple.")
        st.markdown("<h2 style='text-align: center; font-size: 25px; font-weight: bold;'>Visualizing the Most Vary Store</h2>", unsafe_allow_html=True)

        # Display the bar plot image
        st.image(r"Images\max_variance_store.png")
        
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>The Most Varied store is Store Number 14</p>", unsafe_allow_html=True)
        
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Varied Stores",
            data=open("Data\S_With_Varianced_Weekly_Sales.csv", "rb").read(),
            file_name="S_With_Varianced_Weekly_Sales.csv",
            key="download-csv-button"
        )
    if Options_For_Market == options[2]:
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Does Weekly sales get affected from other Features?</h1>", unsafe_allow_html=True)
        st.subheader("Let's See if there's feature affect on weekly sales for stores")

        st.markdown("### Relationship Between Weekly Sales and Numeric Features")
        st.write("- These scatterplots depict the relationship between weekly sales and different numeric features.")
        st.write("- Each scatterplot focuses on one numeric feature, showing how it relates to weekly sales.")
        st.write("- The x-axis represents the numeric feature, and the y-axis represents weekly sales.")
        st.write("- Alpha (transparency) is set to 0.5 to visualize overlapping data points.")
        st.write("- The title of each scatterplot indicates which numeric feature is being analyzed.")
        st.write("- The scatterplots can help identify potential correlations or patterns between weekly sales and individual numeric features.")
        # Display the bar plot image
        st.image(r"Images\Each_Numeric_With_Weekly_Sales.png")
    if Options_For_Market == options[3]:
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Which year was the best year in revenues for the company??</h1>", unsafe_allow_html=True)
        st.subheader("Let's share simple head of data to give look at it")
        
        # Load the data
        Year_Monthly_Sales = pd.read_csv(r"Data\Year_Month_Weekly_Sales.csv").head()
        
        # Display the data in a table
        st.table(Year_Monthly_Sales)
                
        # Explanations for the heatmap visualization
        st.markdown("### Average Weekly Sales by Year and Month (Heatmap)")
        st.write("- This heatmap visualizes the average weekly sales data aggregated by year and month.")
        st.write("- Each cell in the heatmap represents the average weekly sales for a specific year and month combination.")
        st.write("- The color intensity in each cell indicates the magnitude of the average weekly sales, with darker colors representing higher sales.")
        st.write("- The annotation inside each cell displays the exact average weekly sales value (formatted to 3 decimal places).")
        st.write("- This heatmap helps identify sales trends over different years and months, highlighting periods of high and low sales.")
        
        # Display the bar plot image
        st.image(r"Images\Year_Month_Weekly_Sales.png")
        
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>The best year was 2011 at november month.</p>", unsafe_allow_html=True)
        
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Best Year for Stores",
            data=open("Data\Year_Month_Weekly_Sales.csv", "rb").read(),
            file_name="Year_Month_Weekly_Sales.csv",
            key="download-csv-button"
        )
    if Options_For_Market == options[4]:
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Does Holidays have great effect to the company?</h1>", unsafe_allow_html=True)
        st.subheader("Let's see if Holidays have effects on the company, and if it have, which holiday was better?")
        # Load the data
        Holiday_NonHoliday = pd.read_csv(r"Data\Holiday_Vs_Non_Holiday_mean.csv").head()
        Holiday_NonHoliday["Holiday_Flag"] = ["Non-Holiday","Holiday"]
        # Display the data in a table
        st.table(Holiday_NonHoliday)
        # Explanations for the pie chart visualization
        st.markdown("### Comparison Between Holidays and Non-Holidays (Pie Chart)")
        st.write("- This pie chart illustrates the comparison between weekly sales during holidays and non-holidays.")
        st.write("- It categorizes the data into 'Non-Holiday' and 'Holiday' segments.")
        st.write("- The segments are sized proportionally based on the mean weekly sales during those periods.")
        st.write("- The percentage values displayed on the chart represent the contribution of each segment to the total.")
        st.write("- This chart provides a simple visual comparison of sales during holidays and non-holidays.")
        # Display the bar plot image
        st.image(r"Images\Holidays vs Non-Holidays.png")
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Holiday_Vs_Non_Holiday_mean",
            data=open(r"Data\Holiday_Vs_Non_Holiday_mean.csv", "rb").read(),
            file_name="Holiday_Vs_Non_Holiday_mean.csv",
            key="download-csv-button0"
        )
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>They are Almost equally</p>", unsafe_allow_html=True)
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>What about most Store Effected with holidays?</h1>", unsafe_allow_html=True)
        # Load the data
        Store_Effected_With_Holidays = pd.read_csv(r"Data\Negative_Impact.csv").head()
        # Display the data in a table
        st.table(Store_Effected_With_Holidays)
        # Explanations for the bar chart visualization
        st.markdown("### Weekly Sales Comparison between Holidays and Non-Holidays by Store")
        st.write("- This bar chart compares the weekly sales between holidays and non-holidays for different stores.")
        st.write("- Each store is represented by a separate bar in the chart.")
        st.write("- The bars are grouped by 'Holiday' and 'Non-Holiday' categories, showing the mean weekly sales for each.")
        st.write("- The legend distinguishes between 'Non-Holiday' and 'Holiday' bars.")
        st.write("- This chart helps identify stores that may experience a negative impact on sales during holidays.")
        # Display the bar plot image
        st.image(r"Images\Negative_Impact.png")
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>That Shows that Most store was 20 at holidays, but why 33 is that bad?</p>", unsafe_allow_html=True)
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Negative Impacts for stores",
            data=open(r"Data\Negative_Impact.csv", "rb").read(),
            file_name="Negative_Impact.csv",
            key="download-csv-button1"
        ) 
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Let's give some minutes to know about Holidays?</h1>", unsafe_allow_html=True)
        # Load the data
        Compare_Between_every_Holiday = pd.read_csv(r"Data\Compare_Between_every_Holiday.csv").head()
        # Display the data in a table
        st.table(Compare_Between_every_Holiday)
        # Explanations for the bar chart visualization
        st.markdown("### Weekly Sales Comparison between Holidays and Non-Holidays for Different Days")
        st.write("- This bar chart compares the weekly sales between holidays and non-holidays for specific days.")
        st.write("- Each bar represents a specific holiday or non-holiday day.")
        st.write("- The bars are grouped by 'Non-Holiday' and 'Holiday' categories, showing the mean weekly sales for each.")
        st.write("- The y-axis uses a logarithmic scale for better visualization of differences.")
        st.write("- The legend distinguishes between 'Non-Holiday' and 'Holiday' bars.")
        st.write("- This chart helps identify the impact of specific holidays on weekly sales compared to non-holidays.")
        # Display the bar plot image
        st.image(r"Images\Compare_Between_every_Holiday.png")
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>That Shows that Most store was Thank's Giving Day is the best, but why labour day and christmas means are lower than non-holidays?</p>", unsafe_allow_html=True)
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Compare_Between_every_Holiday",
            data=open(r"Data\Compare_Between_every_Holiday.csv", "rb").read(),
            file_name="Compare_Between_every_Holiday.csv",
            key="download-csv-button2"
        )         
    if Options_For_Market == options[5]:
        st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Does Season affects on gains for store?</h1>", unsafe_allow_html=True)
        st.subheader("Let's share simple head of data to give look at it")
        
        # Load the data
        Seasons_VS_Years = pd.read_csv(r"Data\Seasons_VS_Years.csv").head()
        
        # Display the data in a table
        st.table(Seasons_VS_Years)
       # Explanations for the heatmap visualization
        st.markdown("### Average Weekly Sales by Year and Season (Heatmap)")
        st.write("- This heatmap visualizes the average weekly sales data aggregated by year and season.")
        st.write("- Each cell in the heatmap represents the average weekly sales for a specific year and season combination.")
        st.write("- The color intensity in each cell indicates the magnitude of the average weekly sales, with darker colors representing higher sales.")
        st.write("- The annotation inside each cell displays the exact average weekly sales value (formatted to 3 decimal places).")
        st.write("- This heatmap helps identify sales trends over different years and seasons, highlighting periods of high and low sales.")
        # Display the bar plot image
        st.image(r"Images\Seasons_VS_Years.png")
        
        st.markdown("<p style='text-align: center; font-size: 25px; font-weight: bold;'>I think you have noticed the greatness in revenue for Winter 2010, there's offers we need to annouce in feedbacks so.</p>", unsafe_allow_html=True)
        
        st.download_button(
            label="By pressing this button, you can access for the data has been used in this plot, the data is : Seasons_VS_Years",
            data=open("Data\Seasons_VS_Years.csv", "rb").read(),
            file_name="Seasons_VS_Years.csv",
            key="download-csv-button"
        )
if selected_option == 'Feedbacks and Requirements for Improvement':
    st.image(r"Images\Logos\Walmart Logo.png")
    st.header("Feedback and Key Considerations")
    st.subheader("Feedback and important insights the company should focus on to boost revenue")
    
    # Add bullet points with enhanced design
    st.markdown("**Here are some critical points to ponder:**")
    st.markdown("- :star2: Why have the last three stores, especially Store number **33**, underperformed in terms of income? It's essential to investigate the reasons behind their poor revenue.")
    st.markdown("- :rocket: Store number **20** stands out as the highest income generator, whereas Store **14** exhibits the most variability.")
    st.markdown("- :heart: The revenue during holidays seems on par with non-holiday periods. We need to examine holidays with lower revenue than the non-holiday mean.")
    st.markdown("- :dart: Stores **33, 30, 36, 37, 38, 5, 3, and 44** significantly impact revenue negatively. A thorough investigation is warranted to understand the underlying issues.")
    st.markdown("- :package: Why are labor and Christmas-related sales figures so low?")
    st.markdown("- :bulb: What drives the strong preference for Winter? How do other seasons compare?")
    
    st.markdown("**Proposed Solutions from My Perspective:**")
    st.markdown("- :chart_with_upwards_trend: After investigating the underperforming stores, consider implementing special offers on their products to boost revenue.")
    st.markdown("- :computer: Upgrade the e-commerce platform for a more seamless shopping experience.")
    st.markdown("- :moneybag: Offer free home delivery for a limited time to stimulate increased orders.")
    st.markdown("- :mag: Conduct surveys to understand customer preferences in the low-performing stores and take steps to increase sales of preferred items.")
    st.markdown("- :date: Implement more seasonal and Christmas promotions to capitalize on these periods.")
    st.markdown("- :iphone: Develop a mobile app to enhance customer engagement and convenience.")
    st.markdown("- :gift: Provide exclusive promotions to frequent buyers to enhance their loyalty.")
    st.markdown("- :bar_chart: Regularly analyze sales data to identify trends and opportunities for improvement.")
    
    st.markdown("---")
    
    # LinkedIn and Email links
    st.markdown("<h3>Connect with me on LinkedIn:</h3>", unsafe_allow_html=True)
    st.markdown("<a href='https://www.linkedin.com/in/mahmoudessam7' target='_blank'><img src='https://cdn-icons-png.flaticon.com/512/174/174857.png' alt='LinkedIn' width='50'></a>", unsafe_allow_html=True)
    # GitHub link
    st.markdown("<h3>Give a look in my Github:</h3>", unsafe_allow_html=True)
    st.markdown("<a href='https://github.com/MahmoudEssam707' target='_blank'><img src='https://cdn-icons-png.flaticon.com/512/25/25231.png' alt='GitHub' width='50'></a>", unsafe_allow_html=True)
    st.markdown("<h1 style='text-align: center; font-size: 36px; font-weight: bold;'>Thanks For Listening !!</h1>", unsafe_allow_html=True)
