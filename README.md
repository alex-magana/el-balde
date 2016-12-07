[![CircleCI](https://circleci.com/gh/andela-amagana/el-balde.svg?&style=shield&circle-token=ed0c53a7780b59e1b50d0844241487a93a5d6219)](https://circleci.com/gh/andela-amagana/el-balde) [![Test Coverage](https://codeclimate.com/github/andela-amagana/el-balde/badges/coverage.svg)](https://codeclimate.com/github/andela-amagana/el-balde/coverage) [![Code Climate](https://codeclimate.com/github/andela-amagana/el-balde/badges/gpa.svg)](https://codeclimate.com/github/andela-amagana/el-balde)

# El-balde

El-balde is an API for bucket list design.
It exposes an API allowing
consumers to create and manage bucket lists.
This API provides endpoints for the following operations.

Documentation - https://elbalde.herokuapp.com/

Endpoints - https://elbalde.herokuapp.com/api/v1

Source code - https://github.com/andela-amagana/el-balde

## API Features

  1. User authentication with JSON Web Tokens
       [JWT](http://jwt.io)
       [Introduction to JWT](https://www.sitepoint.com/introduction-to-using-jwt-in-rails/)
  2. Create a new bucket list
  3. List all the created bucket lists
  4. Get single bucket list
  5. Update this bucket list
  6. Delete this single bucket list
  7. Create a new item in bucket list
  8. List all the created items in a bucket list
  9. Get a single item in a bucket list
  10. Update a bucket list item
  11. Delete an item in a bucket list
  12. Paginate requests with parameters page and limit e.g. `/bucketlists?page=2&limit=5`
  13. Search bucket lists by name with parameter q e.g. `/bucketlists?q=chall`

### System Dependencies

  1. Ruby [RVM](http://rvm.io/) or [Homebrew](https://www.ruby-lang.org/en/documentation/installation/#homebrew) 
  2. [PostgreSQL](http://www.postgresql.org/download/macosx/)
  3. [Bundler](http://bundler.io/)
  4. [Ruby on Rails](http://guides.rubyonrails.org/getting_started.html#installing-rails)
  5. [RSpec](http://rspec.info/)

## Getting Started

    1. git clone https://github.com/andela-amagana/el-balde.git

    2. cd el-balde

    3. bundle install

    4. rake db:migrate

    5. rake db:seed

    6. rails server

## Tests
    1. cd el-balde
    2. rspec

## API Endpoints

All endpoints except POST `/users` and POST `/auth/login` require an authentication token for `Authorization`, failure to which the API will return the error.

    {
      "error": "Invalid request."
    }

An `Authorization` token takes the format below.

    {
      "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJleHAiOjE0ODExMDE2NDYsImlzcyI6ImVsLWJhbGRlIiwiYXVkIjoiY2xpZW50In0.7U7NMCR8ea2Pv6ykozMNRwRHlLT6aFhPXpebOI8rTzw",
      "message": "Login successful."
    }

| EndPoint                                  |   Functionality                                                 |
| ----------------------------------------- | ---------------------------------------------------------------:|
| POST /users                               | Register a user                                                 |
| GET /users/:id                            | View a single user                                              |
| PUT /users/:id                            | Update a user                                                   |
| DELETE /users/:id                         | Delete a user                                                   |
| POST /auth/login                          | Logs a user in                                                  |
| GET /auth/logout                          | Logs a user out                                                 |
| POST /bucketlists/                        | Create a new bucket list                                        |
| GET /bucketlists/                         | List all the created bucket lists                               |
| GET /bucketlists?page=2&limit=3           | List 3 bucket lists from page 2                                 |
| GET /bucketlists?q=chall                  | Search for bucket lists containing string `chall` in their name |
| GET /bucketlists/:id                      | Get single bucket list                                          |
| PUT /bucketlists/:id                      | Update this bucketlist                                          |
| DELETE /bucketlists/:id                   | Delete this single bucket list                                  |
| POST /bucketlists/:id/items/              | Create a new item in bucket list                                |
| GET /bucketlists/:id/items                | List all the created items in a bucket list                     |
| GET /bucketlists/:id/items?page=2&limit=3 | List 3 bucket list items from page 2                            |
| GET /bucketlists/:id/items/:item_id       | Get a single item in a bucket list                              |
| PUT /bucketlists/:id/items/:item_id       | Update a bucket list item                                       |
| DELETE /bucketlists/:id/items/:item_id    | Delete an item in a bucket list                                 |



## Request & Response Example

Request GET /bucketlists/1/items?page=1&limit=2

     http://elbalde.herokuapp.com/api/v1/bucketlists/1/items?page=1&limit=2
     Authorization: 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJleHAiOjE0ODExMDE2NDYsImlzcyI6ImVsLWJhbGRlIiwiYXVkIjoiY2xpZW50In0.7U7NMCR8ea2Pv6ykozMNRwRHlLT6aFhPXpebOI8rTzw'

Response (application/json)
     
     [
        {
            "id": 1,
            "name": "North pole",
            "date_created": "2016-11-30  9:53:16",
            "date_modified": "2016-11-30 10:03:56",
            "done": true
        },
        {
            "id": 2,
            "name": "South pole",
            "date_created": "2016-11-30  9:53:25",
            "date_modified": "2016-11-30  9:53:25",
            "done": false
        }
    ]

## Limitations

  1. JWT tokens are invalidated by reference to persisted generated tokens.
  2. COR is not supported.
  3. Rate limiting is not supported.
