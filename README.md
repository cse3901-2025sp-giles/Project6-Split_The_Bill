# Split the Bill

A Ruby on Rails application designed to help groups track and settle shared expenses during trips or events.

## Background

When a group of people go on a multi-day trip together, there are many shared expenses: gas, lodging, food, and entertainment. Keeping track of who owes whom what can be a headache. This web application aims to streamline this process.

## Features

### Current Features
*   User authentication (Sign up, Sign in, Sign out, Edit profile) using Devise.

### Required Features (To be implemented)
*   Create new trips (specify name, dates, participants).
*   Add expenses to a trip (description, amount, date, participants involved).
*   Calculate total spent per person.
*   Calculate total owed per person.
*   Provide a strategy/list of transactions to settle debts.

### Potential Extensions
*   Support for multiple trips per user.
*   Support for multiple currencies with conversion.
*   Expense categorization (gas, food, lodging, etc.).
*   Support for different expense splitting methods (equally, by shares, specific amounts).

## Technology Stack

*   Ruby (See `.ruby-version` file)
*   Ruby on Rails (See `Gemfile`)
*   Devise (Authentication)
*   SQLite3 (Default database for development/test)
*   Importmap (JavaScript management)
*   Turbo / Stimulus (Hotwire)

## Setup Instructions

1.  **Prerequisites:**
    *   Ensure you have Ruby installed (version specified in `.ruby-version`).
    *   Ensure you have Bundler installed (`gem install bundler`).
    *   Ensure you have Node.js and Yarn installed (for Rails asset pipeline/JavaScript).

2.  **Clone the repository:**
    ```bash
    git clone https://github.com/cse3901-2025sp-giles/Project6-Split_The_Bill.git
    cd Project6-Split_The_Bill
    ```

3.  **Install dependencies:**
    ```bash
    bundle install
    ```

4.  **Set up the database:**
    ```bash
    rails db:create
    rails db:migrate
    # Optional: rails db:seed (if seed data is added later)
    ```

## How to Run

1.  **Start the Rails server:**
    ```bash
    rails server
    ```
2.  **Access the application:**
    Open your web browser and navigate to `http://localhost:3000`.

## How to Use

*   Use the "Sign up" link to create a new user account.
*   Use the "Sign in" link to log in with an existing account.
*   Once logged in, you can manage your profile or sign out.
*   Trip and expense management features are yet to be implemented.

## Contributing

This project is currently under development. Contributions are welcome! Please feel free to fork the repository, implement new features or fixes, and submit pull requests.
