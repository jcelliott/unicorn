slidenumbers: true

# GraphQL and Absinthe

### Everything\* you need to know to create a GraphQL API with Elixir

#### Josh Elliott

---

# Outline

* GraphQL basics
* Using Absinthe
* Look at some code

---

# Participate

## Download GraphQL Playground:

### https://github.com/prismagraphql/graphql-playground

---

# A query language for your API

* A query language for APIs and a runtime for fulfilling those queries with your existing data.
* Provides a complete and understandable description of the data in your API
* Gives clients the power to ask for exactly what they need and nothing more
* Makes it easier to evolve APIs over time
* Enables powerful developer tools.

---

# GraphQL Query

``` [.highlight: 1, 7]
query {
  viewer {
    username
    id
	money
  }
}
```

* All queries are nested under the `query` object

^ Like a `GET` in a REST API

---

# GraphQL Query

``` [.highlight: 2, 6]
query {
  viewer {
    username
    id
	money
  }
}
```

* `viewer` represents the currently authenticated user

^ query must be specified all the way to scalar fields

---

# GraphQL Query

``` [.highlight: 3-5]
query {
  viewer {
    username
    id
	money
  }
}
```

* query must be specified all the way to scalar fields

---

# More complex query

``` [.highlight: 2]
query {
  users(sortBy: "money", limit: 3) {
    username
    id
    money
  }
}
```

* Can provide arguments to any field

---

# GraphQL Mutation

``` [.highlight: 1, 8]
mutation {
  createUser(username: "josh") {
    user {
      username
      id
    }
  }
}
```

* All mutations are nested under the `mutation` object

^ POST/PUT

---

# GraphQL Mutation

``` [.highlight: 2, 7]
mutation {
  createUser(username: "josh") {
    user {
      username
      id
    }
  }
}
```

* mutation name is just a field, we can also pass arguments

---

# GraphQL Mutation

``` [.highlight: 3-6]
mutation {
  createUser(username: "josh") {
    user {
      username
      id
    }
  }
}
```

* specify returned fields just like in queries

---

# GraphQL Interfaces

```
interface Character {
  id: ID!
  name: String!
}

type Human implements Character {
  id: ID!
  name: String!
  starships: [Starship]
}

type Droid implements Character {
  id: ID!
  name: String!
  primaryFunction: String
}
```

---

# GraphQL Interfaces

```
query HeroForEpisode($ep: Episode!) {
  hero(episode: $ep) {
    name
    ... on Droid {
      primaryFunction
    }
    ... on Human {
      starships {
		name
	  }
    }
  }
}
```

---

# Tooling / Libraries

* GraphiQL
* GraphQL Playground
* Relay
* Apollo

---

# Absinthe

* The GraphQL toolkit for Elixir
* an implementation of the GraphQL specification built to suit the language’s capabilities and idiomatic style
* Define your GraphQL with well-designed macros

---

# Absinthe Ecosystem

* absinthe
* absinthe_plug
* absinthe_ecto
* absinthe_phoenix
* [https://github.com/absinthe-graphql](https://github.com/absinthe-graphql)

---

# Let's look at some code

---

# Demo?

## [https://github.com/jcelliott/unicorn](https://github.com/jcelliott/unicorn)

## http://10.61.111.119:4000/api

## http://10.61.111.119:4000/api/graphiql

---

# Resources

* [https://graphql.org/](https://graphql.org/)
* [https://hexdocs.pm/absinthe/overview.html](https://hexdocs.pm/absinthe/overview.html)
* [https://www.howtographql.com/](https://www.howtographql.com/)
* [https://www.graphqlhub.com/](https://www.graphqlhub.com/)
* [https://developer.github.com/v4/](https://developer.github.com/v4/)

