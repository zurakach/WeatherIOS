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




 
