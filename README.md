# spotlight
Spotlight is a news app that provides means of searching and filtering news. 
The app has been build mainly to exercise both Alamofire and Combine technologies alongside with Keychain and Core Data.

# Technical requirements

- Dependencies tool: Cocoapods

- Navigation: Coordinator pattern

- Architectural pattern: **MVVM-C**, it also uses **multicast delegate** pattern to propagate updates whenever an item is added/removed from favorites

- Networking: **Alamofire & Combine**

- UI: .storyboard & .xib files

- **Core Data** to save the search history & favorite items

- **Keychain** to auto login when the auth token exists

- Swiftgen

- Design: https://www.figma.com/file/Wb0ziupmua9alT92OjZGk6/News-App-UI-Kit-(Community)?node-id=89%3A1

Other interesting stuff touched:
- Floating tab bar
- UIBezierPath to draw some lines on the login screen

# Explore
![App flow](https://i.ibb.co/j5S79Bg/image-8.png)

[App demo here](https://streamable.com/oov9iu)

# Note
[News API](https://newsapi.org/v2/)
[Auth API](https://reqres.in/api/)
