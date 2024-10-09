# Chess API

Ruby on Rails API for managing and playing Chess, backed by the [`chess-engine` gem](https://github.com/kevintsander/chess-engine.git).

## Features

- User authentication and management
- Create, read, update, and delete chess games
- Real-time game updates using WebSockets

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/rails-chess-api.git
   ```
2. Navigate to the project directory:
   ```sh
   cd rails-chess-api
   ```
3. Install dependencies:
   ```sh
   bundle install
   ```

### Database Setup

To configure the application to connect to your Microsoft SQL database, update the `.env.development` file with your database settings. Set the following variables:

#### Example Configuration

```shell
CHESS_SQL_DB_NAME="your_database_name"  # The name of your SQL database
CHESS_SQL_HOST="your_sql_host"          # The hostname or IP address of your SQL server
CHESS_SQL_PORT="your_sql_port"          # The port number on which your SQL server is listening (default is 1433)
CHESS_SQL_USERNAME="your_sql_username"  # The username for your SQL database
CHESS_SQL_PASSWORD="your_sql_password"  # The password for your SQL database
CHESS_SQL_AZURE="false"                 # Set to "true" if using Azure SQL Database, otherwise "false"
```

For more information on how to use `.env` files, you can reference the [dotenv documentation](https://github.com/bkeepers/dotenv).

If a user desires to use a different database, database settings can be customized further via the `config/database.yml` file. Additional modifications may be required in migrations and application code to accommodate different providers.

#### Deploy the database:

```sh
rails db:prepare
```

## Usage

1. Start the Rails server:
   ```sh
   rails server
   ```
2. Access the API at `http://localhost:3000`

## Running with Docker

You can also run the application using Docker. Update or override the `.env.development-docker` file with the desired settings, then follow these steps:

### Using Dockerfile

1. Build the Docker image:

   ```sh
   docker build -t chess-api .
   ```

2. Run the Docker container:
   ```sh
   docker run -p 3000:3000 chess-api
   ```
3. Access the API at `http://localhost:3000`

### Using Docker Compose

1. Run Docker Compose:

   ```sh
   docker-compose up
   ```

2. Access the API at `http://localhost:3000`

## API

### Games

- **Create**

  - **URL**: `POST /games`
  - **Description**: Initializes and starts a new game, saves it to the database, broadcasts the game state, and returns the game ID.
  - **Body**:
    ```json
    {
      "player1_id": "integer",
      "player2_id": "integer"
    }
    ```

- **Update**

  - **URL**: `PUT /games/:id`
  - **Description**: Updates the state of an existing game, performs a game action or promotes a unit, saves the updated game state, and broadcasts the game state.
  - **Body**:
    ```json
    {
      "unit_location": "string", // ex a4, b6, etc
      "move_location": "string", // "
      "promote_unit_type": "string" // when a pawn has reached an end square, provide unit type (Q, B, R, K)
    }
    ```

- **Show**
  - **URL**: `GET /games/:id`
  - **Description**: Retrieves and returns the game state, which includes possible actions for current player.
  - **Response**:
  ```json
  {
    "id": "EXAMPLE-GUID-1234-5678-ABCD-EFGH",
    "turn": 1,
    "current_color": "white",
    "player1": {
      "id": 1234,
      "nickname": "ChessMaster"
    },
    "player2": {
      "id": 5678,
      "nickname": "GrandmasterFlash"
    },
    "units": [
      { "color": "white", "type": "King", "location": "e1" },
      { "color": "white", "type": "Queen", "location": "d1" },
      // ... other units
      { "color": "black", "type": "Pawn", "location": "h7" }
    ],
    "allowed_actions": [
      {
        "type": "Move",
        "moves": [{ "from_location": "b1", "to_location": "c3" }]
      },
      {
        "type": "Move",
        "moves": [{ "from_location": "b1", "to_location": "a3" }]
      },
      // ... other allowed actions
      {
        "type": "Move",
        "moves": [{ "from_location": "h2", "to_location": "h4" }]
      }
    ],
    "status": "playing"
  }
  ```

### Users

#### Authorization

Authentication and authorization mechanisms are implemented using the [Devise gem](https://github.com/heartcombo/devise) paired with the [Devise Token Auth gem](https://github.com/lynndylanhurley/devise_token_auth).

#### User Confirmations

User confirmations are on, but emails will not be delivered by default. Get the URL from the logs or manually update the database.

#### Game State

#### Update

- **URL**: `PUT /games/:game_id/player1` / `PUT /games/:game_id/player2`
- **Description**: Sets the player in the specified slot to a user ID.
- **Body**:
  ```json
  {
    "user_id": "integer"
  }
  ```

## License

This project is licensed under the MIT License.
