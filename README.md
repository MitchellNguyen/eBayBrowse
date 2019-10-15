# ebay_browse_app

A Flutter app that provides an eBay browse experience.

### Functionalities that have been implemented in this project:
1. Implement search
	* Implement a key word search that provides a list of results.
2. Implement infinite scrolling
	* The user should be able to scroll down and see more results. Keep loading results as long as the user scrolls or until you run out of results.
3. Implement item detail screen
	* The user should be able to tap on a result and go to another screen to see more details about the item.
	
### Notes for future implementations (with more time to work on this project):
* Add a way to filter by category, price, etc.
* Add a way to sort by date posted, etc.
* Implement unit-testing

### References:
* Creating the UI for the Search-List-Screen with the "search bar" and ListView of items
	* https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b
	* https://github.com/Norbert515/BookSearch/tree/master
* Implementing infinite-scrolling by adding a "ScrollController", which coordinates when to fetch the next page of data
	* https://inducesmile.com/google-flutter/how-to-create-an-infinite-scroll-with-listview-in-flutter/
* Regex for removing XML tags from parsed data
	* https://stackoverflow.com/questions/51593790/remove-html-tags-from-a-string-in-dart
* Retrieving substring of parsed data when trying to retrieve nested tag content
	* https://stackoverflow.com/questions/57186404/how-to-get-substring-between-two-strings-in-dart
	