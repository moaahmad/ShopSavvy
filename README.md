# ShopSavvy
- An iOS app that makes use of the [DummyJSON](https://dummyjson.com/docs) API to fetch products
  - Utilises SwiftUI, Combine, and Async/Await
  - Compiles and runs on Xcode 14.3
  - Unit Test Coverage:
     - NB, The snapshot tests may fail on first run, which is expected. Run them again and they should pass. 
  
  ![Screenshot 2023-05-03 at 15 55 18](https://user-images.githubusercontent.com/23720725/235954781-c37a1d99-9b48-4dd6-931d-5ed192064b06.png)

## Requirements
- [x] Show a list of products
- [x] Retrieve products from the API and paginate on scroll
- [x] Ability to add a product to the cart if it's in stock
- [x] Show a shopping cart detailing the products and quantities added
- [x] Be able to increase and decrease the number of products

## Discussion
- Accessibility labels have only been added to the `ToolbarCartButton` and `ProductCardView` thus far. They still need to be added to the shopping cart view.
- `Kingfisher` has been added as a dependency to handle downloading images and caching etc.
- There's an issue with the `Stepper` on the `ShoppingCartView`, where when you reach the limit of products that you can add to the cart, the stepper doesn't disable when it should. This isn't an ideal user experience, but for now at least the correct number of products are being counted.
- Other things I'd like to have spent time on include: ~Error handling~, ~String localization~, ~Snapshot testing~, ~UI testing~, and iPad support.

## Architecture
- Packages:
  - `CoreKit`: A foundational package containing core components and extensions used across the `ShopSavvy` app.
  - `ModelKit`: A package containing the required models for the `ShopSavvy` app
  - `NetworkKit`: Networking layer to be used to make HTTP requests to the `DummyJSON` API
  - `DesignKit`: Design system components and UI helpers for the `ShopSavvy` app
- Main App:
  - `MVVM` architecture implemented to allow for a more flexible, well-separated code base. 
    - `View`s are focused only on UI presentation and user interaction
    - `ViewModel`s focus on business logic, whilst also allowing for easier unit testing and potential reuse of key components

## Current App State
![Simulator Screen Recording - iPhone 14 Pro - 2023-05-03 at 16 01 23](https://user-images.githubusercontent.com/23720725/235956499-19274af2-70f6-450e-bc5c-d4dddbaa6d2b.gif)


