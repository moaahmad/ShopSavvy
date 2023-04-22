# ShopSavvy
- An iOS app that makes use of the [DummyJSON](https://dummyjson.com/docs) API to fetch products
  - Utilises SwiftUI & Combine
  - Compiles and runs on Xcode 14.0

## Requirements
- [x] Show a list of products
- [x] Retrieve products from the API and paginate on scroll
- [x] Ability to add a product to the cart if it's in stock
- [x] Show a shopping cart detailing the products and quantities added
- [x] Be able to increase and decrease the number of products

## Discussion
- - ~The `ProductFeedViewModel` currently adheres to both the `ProductFeedViewModeling` and `ShoppingCartViewModeling`. This isn't ideal as one view model is handling too many responsibilities. A separate view model should be implemented to just focus on the responsibilities of the shopping cart.~ ShoppingCartViewModel has now been separated into it's own concrete class.
- Accessibility labels have only been added to the `ToolbarCartButton` and `ProductCardView` thus far. They still need to be added to the shopping cart view.
- `Kingfisher` has been added as a dependency to handle downloading images and caching etc.
- There's an issue with the `Stepper` on the `ShoppingCartView`, where when you reach the limit of products that you can add to the cart, the stepper doesn't disable when it should. This isn't an ideal user experience, but for now at least the correct number of products are being counted.
- Other things I'd like to have spent time on include: Error handling, ~String localization~, Snapshot testing, UI testing, and iPad support.

## Current App State
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-17 at 02 19 53](https://user-images.githubusercontent.com/23720725/232356502-9df6f723-d60f-4c2d-98c8-0c1dbd4dfada.gif)
