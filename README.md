# Acrobatics Class Management Project

## Description
This project aims to create a system to manage acrobatics classes, calculate monthly fees, track student payments, and handle promotions or class packages. It will be a functional MVP to optimize studio administration.

## Key Features
- **Student Management:** Register student details, contact information, and payment status.
- **Class Scheduling:** Enroll students in specific classes with schedules and capacity limits.
- **Monthly Fee Calculation:** Calculate the amount to pay based on the number of classes and active promotions.
- **Promotions:** Configure class packages with discounts (e.g., 8 classes for $X).
- **Payment History:** Record payment date, amount, and method.
- **Reports:** View outstanding balances, payment records, and basic attendance statistics.
- **Class Recovery:** Allow students to recover missed classes due to holidays or timely cancellations by viewing available classes with open spots and selecting the most convenient option.

## Suggested Technologies
- **Backend:** Go (for speed and efficiency).
- **Database:** PostgreSQL (robust relational structure).
- **API:** REST to connect with potential frontends.
- **Authentication:** JWT to secure sensitive endpoints.

## Project Structure (Clean Code Architecture)
```
├── cmd/                   # Application entry points
├── internal/
│   ├── domain/            # Entities and core business models
│   ├── usecase/           # Business logic and application rules
│   ├── repository/        # Database interactions
│   ├── handler/           # HTTP handlers and API endpoints
│   └── service/           # Services to handle complex operations
├── db/
│   └── migrations/        # SQL scripts to create and migrate tables
├── config/                # Application configuration files
├── .env                  # Environment variables
├── Dockerfile            # Container configuration
├── docker-compose.yml    # Service orchestration
└── main.go               # Application entry point
```
## DB relationship diagram
![image](https://github.com/user-attachments/assets/42cce94f-2cdb-42cf-aea4-3539b0c37265)

## Initial Setup
1. **Clone the repository:**
```sh
git clone <REPO_URL>
cd <project_name>
```

2. **Configure environment variables:**
Create a `.env` file with your database connection details and other secrets.

3. **Run the services:**
If using Docker:
```sh
docker-compose up --build
```

## Next Steps
- **Define models:** Create tables for students, classes, payments, and promotions.
- **Basic endpoints:** Implement CRUD operations for each entity.
- **Payment calculation logic:** Build the function to determine fees.
- **Class recovery logic:** Implement a feature to list available classes and allow students to book recovery slots.
- **Validations:** Ensure data consistency (e.g., prevent overbooking).

## Contribution
Contributions are welcome! Fork the repository or open an issue with suggestions or bug reports.



