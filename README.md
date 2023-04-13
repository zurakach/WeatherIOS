# Weather iOS

This application uses OpenWeather API to load weather forecast.

**Features:**
- Load forecast for a city that user is located in
- Search city by name and display it's forecast


## Architecture

Using **Clean Swift (VIP)** Architecture with Dependency Injection.  
VIP architecture is similar to VIPER. Main difference is that VIP has **circular** (one way) dependencies between View (ViewController), Interactor and Presenter.  
- ViewController only sends messages to Interactor. 
- Interactor only sends messages to Presenter. 
- Presenter only sends messages to View.

Allegedly VIP is one step ahead of VIPER, since it allows to fix VIPER's main problem of having huge Presenter classes.  Although this is theory and I wouldn't say that VIP is clearly better than VIPER :)


## Components

**Setup**  
When app launches, it initializes appropriate dependencies (**DependencyContainer** and **Router**). SceneDelegate then asks Router to provide initialViewController.

**Router**  
Router is responsible for handling **transitions** between Scenes (ViewControllers) and handling events like showing an alert.  Router is a great pattern to use. This allows us to decouple different Scenes from each other. VC doesn't need to know what context it is displayed in. VC should only care about managing their own content.


**Dependencies**  
Using **ServiceLocator** pattern as a dependency injection for this app.  I especially like ServiceLocator for following benefits:
- Unlike on-demand approach, we avoid creating huge graph of dependencies. Object can interact with serviceLocator and get any dependencies they need.
- We can have short-lived and long-leaved dependencies by having Factory methods. This is good since we don't have to instantiate all dependencies in advance.
- I've seen many ways that others implement a process of locating a service. Using Property wrappers or protocol extensions. I tend to not like those approaches since effectively they use singleton pattern. I prefer to explicitly inject the dependencies. Using DependencyContainer allows me to do exactly that.

**Repository**  
Repositories are good way to separate Data Layer from Presentation Layer. Presentation Layer doesn't need to know what is happening under the hood (loading data from remote api, or disk or cache, or just returning fake data). Another great way to decouple code.


**RemoteAPI**  
RemoteAPIs are used by Repositories to load data. Here again I use Protocol Oriented Programming to be able to set appropriate objects based on environment.


## Presentation Layer

In VIP the main player is **Scene** (ViewController). Router displays Scene and then Scene is responsible to handle it's UI and data.

Scene consists of three components:

- **ViewController:** Responsible for managing UI elements and handling user inputs. I use VC as a Scene since it allows us to cleanly integrate VIP into UIKit.
- **Interactor:** Responsible for communicating with Data layer. In cases where there are more complex interactions between Interactor and Repositories, We can use **Workers**. This allows us to have less code in Interactor.
- **Presenter:** Responsible for handling Interactor's output and converting Domain model into Presentation model. This allows us to cleanly separate Presentation Layer from Domain Layer.

All three components are protocols, So each one can be replaced with different implementation based on environment. e.g. if we wanted to test Interactor, we would introduce Mock Presenter that checks if all the necessary messages where send with correct values.


## Testing

Almost all components in this project are **Protocols**. This allows us to set up an environment where we can test **single** component at a time.  
Currently I only implemented Interactor **Unit Tests** that use **Stub** Repositories to check if data is processed correctly.


## Code

- In SceneDelegate I set up appropriate DependencyContainer and Router. 
For UI Testing we can provide Stub Router and Dependency Container for quick and easy testing.
- Router provides initialViewController by setting up NavigationController with WeatherForecastViewController as it's root VC.
Router is responsible for setting up Scene. It creates Scene's VIP elements with appropriate dependencies.

- When WeatherForecastVC is presented, it starts loading procedure. 
First it asks Interactor to load weather based on user's current location. Interactor talks with appropriate Repositories to load data. 
If loading location weather fails, then WeatherForecastVC asks interactor to load last displayed city weather. 
- Interactor talks with presenter to give updates about the state of loading. Presenter converts these messages to PresentationModel and gives it to WeatherForecastVC.
- WeatherForecastVC has WeatherForecastDetailsView to display forecast. View is managed by WeatherForecastDetailsViewModel. 
ViewModel is responsible for setting appropriate data to View. ViewModel also loads weather icon and sets it when done. 
This is borrowed from MVVM. It allows us to decouple presentation model handling code from UI code.

- City Search: WeatherForecastViewController also sets up SearchViewController and CitySearchResultViewController. When search is requested, it asks Interactor to do the search and when presenter gives results, 
 results are sent to SearchResultVC. Here I could have decoupled code even more. e.g. by putting search handling in separate ViewModel.


## Notes
- Project structure isn't the best. Ideally I would create separate Module/Package for Data Layer. Stub and Production implementations being in same place is not ideal either.
- For Geocoding I'm using CoreLocation's geocoding instead of OpenWeather one. After I implemented it I figured OpenWeather api would be better suited to provide multiple city suggestion. 
This can be fixed in the future by creating a OpenWeatherGeocoderRepository and using it instead of CLGeocoderRepository.
- Handling errors such as 'no access to location' can be done more gracefully. I can add alert messages to let user know that I need access to location and then open settings app.
