# Pokemon

## How to Build
1. Pull code and install frameworks from Swift Package Manager (SPM).

## Architecture

### MVVM-C

1. **MVVM**: Utilizes the Model-View-ViewModel (MVVM) architecture to decouple business logic from the model, enhancing testability and maintainability.
2. **Coordinator Pattern**: Employs the coordinator pattern to decouple routing logic from the view controller, facilitating navigation logic isolation.
3. **CoreData**: Adopts CoreData for data storage to cache API responses, thereby improving the user experience.
4. **XIBs**: Prefers XIB files as the main interface builder method to streamline UI development and facilitate modular design.

## Frameworks

1. **Combine**: Implements a functional programming coding style and binds the view model to the view, simplifying state management.
2. **Kingfisher**: An efficient image caching framework to effortlessly handle image loading and caching.
3. **Moya**: A concise network abstraction layer built on top of Alamofire, aiming to simplify API calls and responses handling.
4. **CoreData**: Utilized as a robust and efficient local data storage solution, ensuring data persistence and quick data retrieval.

## Utilized LLM tools

Most of the time, I've only asked ChatGPT for several things:

1. Swift grammar correction: Since I haven't been writing Swift for a year, I was immersed in Flutter for my current project. So, I am brushing up on Swift through this project.
2. Core Data: I usually choose Realm as the project data storage in my actual work. Therefore, I am brushing up on Core Data through this project.

## Note
1. I can't find Evolution chain and Pokedex description in `GET https://pokeapi.co/api/v2/pokemon/{id}`. The evolution chain is in `GET https://pokeapi.co/api/v2/evolution-chain/{id}` and The pokedex description is in `https://pokeapi.co/api/v2/pokemon-species/{id or name}` both of which I haven't integrated.
