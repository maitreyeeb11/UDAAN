const { Client } = require('pg');

// PostgreSQL client configuration
const client = new Client({
    user: 'postgres',  // Your PostgreSQL username
    host: 'localhost',
    database: 'udaan',  // The name of your database
    password: '1028',  // Your PostgreSQL password
    port: 5432,
});

// Connect to the PostgreSQL database
client.connect()
    .then(() => console.log('Connected to the database'))
    .catch(err => console.error('Error connecting to the database:', err));

module.exports = client;