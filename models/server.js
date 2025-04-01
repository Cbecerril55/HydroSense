const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const { db } = require('../db/db.js');

class Server {
    constructor() {
        this.app = express();
        this.port = process.env.PORT || 3003;
        this.paths = {
            home: '/',
            prueba: '/prueba'
        };
        this.connectDB();
        this.middlewares();
        this.routes();
    }

    async connectDB() {
        try {
            await db.authenticate();
            console.log('Database connected');
        }
        catch (error) {
            console.error('Error connecting to database:', error);
            throw new Error('Error initializing database');
        }
    }

    middlewares() {
        this.app.use(cors());
        this.app.use(express.json());
        this.app.use(bodyParser.json());
        this.app.use(bodyParser.urlencoded({ extended: false }));
    }

    routes() {
        this.app.use(this.paths.home, require('../routes/home'));
        this.app.use(this.paths.prueba, require('../routes/prueba'));
    }

    listen() {
        this.app.listen(this.port, () => {
            console.log(`Server running on port ${this.port}`);
        });
    }
}

module.exports = Server;