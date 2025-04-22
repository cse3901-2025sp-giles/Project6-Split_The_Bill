# Split the Bill

A Ruby on Rails application designed to help groups track and settle shared expenses during trips or events.

## Features Implemented

*   **User Authentication:** Sign up, Sign in, Sign out, Edit profile using Devise.
*   **Trip Management:**
    *   Create trips with a name, start date, and end date.
    *   Add participants (name and email) to trips dynamically when creating or editing.
    *   View a list of trips you created or are participating in.
    *   Edit existing trip details and participants.
    *   Delete trips.
*   **Expense Management:**
    *   Add expenses to a specific trip, including description, amount, date, and category.
    *   Select the user (from registered participants) who paid the expense.
    *   Select the participants who shared the expense using checkboxes.
    *   Edit existing expenses.
    *   Delete expenses.
*   **Debt Calculation & Settlement:**
    *   Calculates the net balance for each participant based on expenses paid vs. shared.
    *   Provides a list of suggested transactions to settle all debts within a trip.
*   **User Dashboard:**
    *   Shows the total amount the logged-in user has spent across all trips where they were the payer.
    *   Lists trips the user created or is participating in.
*   **UI/UX:**
    *   Styled using Bootstrap 5 for a clean interface.
    *   Responsive navigation bar.
    *   Improved form layouts for creating/editing trips and expenses.
    *   Dynamic addition/removal of participant fields via JavaScript.
    *   Basic currency display toggle (USD/EUR with fixed rate) on the trip details page.

## Technology Stack

*   Ruby (See `.ruby-version` file)
*   Ruby on Rails (See `Gemfile`)
*   Devise (Authentication)
*   SQLite3 (Default database for development/test)
*   Importmap (JavaScript management)
*   Turbo / Stimulus (Hotwire)
*   Bootstrap 5 (Frontend styling)
*   Chart.js (Included, but potentially unused)

## Setup Instructions

1.  **Prerequisites:**
    *   Ensure you have Ruby installed (version specified in `.ruby-version`). Use a Ruby version manager like `rbenv` or `rvm`.
    *   Ensure you have Bundler installed (`gem install bundler`).
    *   Ensure you have Node.js and Yarn installed (for Rails asset pipeline/JavaScript).

2.  **Clone the repository (if you haven't already):**
    ```bash
    # Replace with your repository URL if needed
    git clone <your-repository-url>
    cd <repository-directory>
    ```

3.  **Install dependencies:**
    ```bash
    bundle install
    ```

4.  **Set up the database:**
    *This command creates the database, loads the schema, and seeds data (if `db/seeds.rb` exists).*
    ```bash
    bin/rails db:prepare
    ```
    *Alternatively, for more control:*
    ```bash
    # bin/rails db:create
    # bin/rails db:migrate
    # bin/rails db:seed # Optional
    ```

## How to Run

1.  **Start the Rails server:**
    ```bash
    bin/rails server
    ```
2.  **Access the application:**
    Open your web browser and navigate to `http://localhost:3000`.

## How to Use

*   Use the "Sign up" link to create a new user account. Remember the email used.
*   Use the "Sign in" link to log in.
*   Create a new trip using the "Create New Trip" button on the homepage.
*   Add participants to the trip, making sure to include the email addresses of other registered users if you want them to be able to view the trip and be selected as payers.
*   Navigate into a trip from the homepage.
*   Use "Add Expense" to add expenses, select the payer (must be a registered user who is also a participant), and choose who shared the cost.
*   View the trip details page to see expenses, totals paid by each participant, and the settlement plan.
*   Use the "Switch to EUR" button on the trip details page to toggle currency display (uses a fixed rate).

## Potential Future Extensions

*   Real-time currency conversion using an API.
*   More sophisticated expense splitting methods (e.g., by percentage, shares).
*   Notifications for users when added to trips or when settlements change.
*   Improved handling of non-user participants in calculations/display.
*   Reporting and visualization (e.g., spending per category).
*   Data seeding (`db/seeds.rb`) for easier testing/demo.

## Contributing

Contributions are welcome! Please feel free to fork the repository, implement new features or fixes, and submit pull requests.
