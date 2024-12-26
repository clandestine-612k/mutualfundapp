# Mutual Fund App

1\. Explanation of the App's Features and FunctionalityThe Mutual Fund App is designed to provide users with detailed information about various mutual funds, including their historical data with graphical representation, NAV (Net Asset Value), and gains over selected periods. Additionally, it offers a personalized experience by enabling users to mark and manage their favorite funds. Below are the core features:Features

1.  **Home Screen**:
    
    *   Displays a list of all available mutual funds.
        
    *   Includes a search functionality to filter mutual funds by scheme name or scheme code.
        
    *   Option to look into the favorite mutual funds
        
2.  **Details Screen**:
    
    *   Provides detailed information about a selected mutual fund.
        
    *   Displays historical NAV data in tabular format.
        
    *   Plots NAV trends over different time periods (1 year, 3 years, and 5 years).
        
    *   Shows percentage gains for different periods.
        
    *   Allows users to mark/unmark a mutual fund as a favorite.
        
3.  **Favorites Page**:
    
    *   Users can add or remove mutual funds from their favorites.
        
    *   A dedicated "Favorites" page lists all marked funds for quick access.
        
4.  **Persistent Data Storage**:
    
    *   Favorite mutual funds and fetched data are saved locally using GetStorage to ensure persistence between sessions.
        
5.  **Real-Time Notifications**:
    
    *   Provides visual feedback when a fund is added to or removed from favorites.
        

2\. Steps to Set Up and Run the AppPrerequisites

*   Flutter SDK installed on your system.
    
*   Android Studio or Visual Studio Code with Flutter extensions.
    
*   An Android or iOS emulator, or a physical device for testing.
    
*   API access credentials (if applicable).
    

Steps**Clone the Repository**:git clone [https://github.com/clandestine-612k/mutualfundapp](https://github.com/clandestine-612k/mutualfundapp)

1.  cd mutualfundapp
    
2.  **Install Dependencies**: Run the following command to install required dependencies:
    
3.  flutter pub get
    
4.  **Add API**
    
    *   Add any API keys or configuration details required for the app.
        
5.  **Run the App**:
    
    *   Launch an emulator or connect a physical device.
        
6.  Run the command:
    
    *   flutter run
        
7.  **Navigate the App**:
    
    *   Use the search bar on the home screen to filter mutual funds.
        
    *   Tap a mutual fund to view its details.
        
    *   Mark funds as favorites and view them on the "Favorites" page.
        

3\. Challenges Faced and Solutions Implemented

1. Handling Large Data Sets:

  **Challenge**: Fetching and displaying historical NAV data for multiple mutual funds.
  **Solution**: Implemented efficient data fetching with caching using **GetStorage** to minimize API calls and improve performance.

2. Real-Time Data Updates:

   **Challenge**: Ensuring that changes to favorites are reflected instantly across the app.
   **Solution**: Used **GetX** for state management to provide reactive updates to the UI whenever the favorites list changes.

3. Data Visualization:

   **Challenge**: Rendering historical NAV trends and gains in an intuitive and interactive format.
   **Solution**: Integrated the **fl\_chart** package to create dynamic and visually appealing line charts.

4. Error Handling:

   **Challenge**: Handling API failures and ensuring a smooth user experience.
   **Solution**: Added robust error messages to display when API calls fail.
