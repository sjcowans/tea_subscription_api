
# Tea Subscription Service API

This is a Ruby on Rails API for a Tea Subscription Service. Customers can manage their tea subscriptions.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have Ruby, Rails and Postgres installed in your system. Here's the main technologies used in this project:

- Ruby version: 3.1.3
- Rails version: 7.0.6
- Postgres version: 1.5.3

### Installing

First, you need to clone the project:

```bash
git clone https://github.com/sjcowans/tea_subscription_api.git
```

Then, install the dependencies:

```bash
bundle install
```

Set up the database:

```bash
rails db:create
rails db:migrate
rails db:seed
```

### Running

To start the local server:

```bash
rails server
```

## Running the Tests

You can run the tests with:

```bash
bundle exec rspec
```

## API Endpoints

**Create a Subscription**
- `POST /customers/:id/teas/:id/subscriptions`
- Required parameters: `customer_id`, `tea_id`
- Optional parameters: `frequency` (default to "Monthly")

Example Request:

```bash
    POST /customers/1/teas/1/subscriptions
```

Example Response:

```bash
{
  "id": 1,
  "subscription": {
                    "id": 2,
                    "title": "Green Tea",
                    "price": 50,
                    "status": "Active",
                    "frequency": "Monthly"
                  }
}
```

**List all Subscriptions for a Customer**
- `GET /customers/:id/subscriptions`
- Required parameters: `customer_id`

Example Request:

```bash
GET /customers/1/subscriptions
```

Example Response:

```bash
[
    {
        "id": 1,
        "title": "Green Tea",
        "price": 50,
        "status": "Active",
        "frequency": "Monthly",
        "customer_id": 1,
        "created_at": "2023-07-28T03:17:26.929Z",
        "updated_at": "2023-07-28T03:17:26.929Z"
    },
    {
        "id": 2,
        "title": "Chai Tea",
        "price": 50,
        "status": "Active",
        "frequency": "Weekly",
        "customer_id": 1,
        "created_at": "2023-07-28T04:42:44.950Z",
        "updated_at": "2023-07-28T04:42:44.950Z"
    }
    {
        "id": 3,
        "title": "Black Tea",
        "price": 100,
        "status": "Inactive",
        "frequency": "Weekly",
        "customer_id": 1,
        "created_at": "2023-07-28T04:42:44.950Z",
        "updated_at": "2023-07-28T04:42:44.950Z"
    }
]
```

**Update a Subscription**
- `PATCH /customers/:id/subscriptions/:id`
- Required parameters: `customer_id`, `subscription_id`
- Optional parameters: `title`, `price`, `status`, `frequency`

Expample Request:

```bash
PATCH /customers/1/subscriptions/2?status=Inactive
```

Example Response:

```bash
{
    "id": 1,
    "subscription": {
        "id": 2,
        "title": "Green Tea",
        "price": 50,
        "status": "Inactive",
        "frequency": "Monthly"
    }
}
```

## Built With

* [Ruby on Rails](https://rubyonrails.org/) - The web framework used
* [PostgreSQL](https://www.postgresql.org/) - Database
* [RSpec](https://rspec.info/) - Testing framework
