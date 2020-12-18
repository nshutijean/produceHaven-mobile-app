# ProduceHaven mobile app (WIP)

### What is this app about?
- It complementary app to an ecommerce web app that takes care quality of assurance of fresh produce in real-time. It adds functionalities that are required to be performed on a mobile app

### Problem statement
 - It's really hard to know if the product (fresh produce) is as fresh and of good quality as you want it to.

### Proposed solutions
 - With this app, a vendor can upload timestamped product details that may expire as time goes on. 
 - With a product QRcode anywhere, it is easy for a vendor to make his/her product known

### Functional requirements
 - The app should register either a vendor or buyer
 - The app should be able to login a vendor or buyer
 - The app must allow a vendor to create and upload products 
 - The app must allow a vendor to take a real-time picture of the product
 - The app should create a QRcode at each product created
 - The app will be able to scan a QRcode created and redirect to the product on a web app (using in-app web browsing)
 - The mobile app will enable a vendor to delete products if required
 - The app should allow a vendor to update any necessary information
 - Vendors and buyer will be allowed to update their profile as well
 - A buyer will be able to see their orders

### Technologies used
 - **Figma**: for prototyping
 - **Dart/Flutter**: for UI mobile app design
 - **PHP/Laravel**: for backend and API development

### Dart/Flutter dependencies used
 - ``http``: used it to handle http requests
 - ``shared_preferences``: used it to store simple data from the API
 - ``barcode_scan``: used to scan QRcode
 - ``image_picker``: used it to select images from gallery and take picture  
 - ``flutter_web_browser``: used it to handle in-app web browsing when redirecting
 - ``dio``: used its FormData to upload pictures
 - ``esys_flutter_share``: used it to share QRcode image with other apps
