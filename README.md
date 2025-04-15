# Clean Architecture Flutter Template

This is a Flutter project template that implements **Clean Architecture** with **Dependency Injection** and **Routing** using **GoRouter** and **flutter_bloc**. This template is designed to help you quickly start building Flutter applications using best practices.

## Features

- **Clean Architecture**: A modular structure with separation of concerns for maintainability and scalability.
- **Dependency Injection**: Using **get_it** for managing dependencies.
- **Bloc State Management**: Using **flutter_bloc** for managing app state in a predictable and testable way.
- **Routing**: Navigation is handled with **GoRouter**.
- **Testing**: A basic test structure to help you get started with unit and widget testing.

## Project Structure

The project is organized as follows:

lib/ ├── core/ │ ├── errors/ │ ├── usecases/ │ └── utils/ ├── features/ │ └── todo/ │ ├── data/ │ │ ├── models/ │ │ └── repositories/ │ ├── domain/ │ │ ├── entities/ │ │ ├── repositories/ │ │ └── usecases/ │ └── presentation/ │ ├── bloc/ │ ├── pages/ │ └── widgets/ └── injection_container.dart


### Core

- **`core/`**: Contains shared resources such as utilities, error handling, and common use cases.

### Features

- **`features/`**: Contains different features of the app, each separated by its own domain logic, data layer, and presentation layer.
  - **`todo/`**: Example feature with a Todo list (can be replaced with your own feature).

### Dependency Injection

**`injection_container.dart`**: Manages the registration and resolution of dependencies using **get_it**. The DI container is set up at the start of the app.

### Routing

**`AppRouter`**: Uses **GoRouter** to manage routes and navigation. The app is structured to allow easy navigation between pages.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Vladeouz/flutter_clean_architecture_template.git
cd flutter_clean_architecture_template
```
### 2. Install dependencies

```bash
flutter pub get
```
### 3.  Run the app

```bash
flutter run
```

### 4. Customizing the Template
- Replace the Todo feature with your own domain.
- Modify use cases, repositories, and entities to fit your app’s needs.
- Add more features following the same structure as the todo feature.
- Update the routes in AppRouter to match your application's navigation.

### Contributing
Feel free to fork this template and use it in your projects. If you have any improvements or bug fixes, please open a pull request.

### License
This project is licensed under the MIT License - see the LICENSE file for details.

### Penjelasan:
- **Project Structure**: Penjelasan singkat mengenai struktur folder dan file dalam proyek ini.
- **Dependency Injection**: Menjelaskan bagaimana **get_it** digunakan untuk dependency injection di proyek ini.
- **Routing**: Menjelaskan penggunaan **GoRouter** untuk manajemen navigasi.
- **Getting Started**: Langkah-langkah untuk menyiapkan proyek di komputer lokal.
- **Testing**: Menyediakan informasi untuk menjalankan tes unit dan widget yang ada.
- **Contributing**: Mengundang kolaborasi dari orang lain untuk menyempurnakan template ini.
