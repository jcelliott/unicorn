# Unicorn

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# Example queries:

### Get top three users

```graphql
query {
  users(sortBy: "money", limit: 3) {
    id
    username
    money
    revenueRate
  }
}
```

### Create a new user

```graphql
mutation {
  createUser(username: "somebody") {
    user {
      username
      id
    }
  }
}
```

### Add "auth" in header:

    {"CurrentUserId": "cced5bf9-a2cf-49a3-9278-ffce7a7db27a"}

### Get the current user

```graphql
query {
  viewer {
    username
    money
    revenueRate
    expenseRate
  }
}
```

### List available purchases

```graphql
query {
  purchases {
    type
    name
    cost
    codeRate
    revenueRate
    expenseRate
  }
}
```

### Hire an employee

```graphql
mutation {
  purchase(purchase: {type: "employee", name: "dev_intern"}) {
    user {
      username
    	employees {
     	 hacker
    	}
    }
  }
}
```

### Release your product on the world

```graphql
mutation {
  release {
    user {
      username
      revenueRate
      money
    }
  }
}
```
