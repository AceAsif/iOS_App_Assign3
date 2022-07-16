# iOS_App_Assign3
This is my iOS App assignment for KIT305 assignment-3. 
 I got 95% which is a HD for this assignment. 
 I have not make the app compatible for all phone screens (yet!) as it was not a requirement for the assignment.
 
 Some notes for testing my app:

1) The app was designed in iPhone 11 simulator.

2) The orientation is vertical.

3) You need to swipe left an item to delete an item in the History table (i.e. Dot Game History and Free to Play History).

4) You need to press the "return" button (which is the same as "Enter") on the iPhone keyboard to save your name.

5) If you see the "Loading sign" with "Searching for image" text for more than 5 seconds (depends on your internet speed) on the History page that means that I took the picture and it could only be viewed on my emulator or phone. If the user didn't take pictures, then it will show a default image from an URL so please wait 2 seconds or maybe less (depending on your internet speed).

6)  dtFormatter.dateFormat = "ss.SSS"

shows the milliseconds with seconds. This allows the user to see how many milliseconds it took him to press each button. I didn't include hour and minute because the user can see from the start and end time so it would be redundant information.
