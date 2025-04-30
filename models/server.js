const express = require('express');
const http = require('http');
const { Server: SocketIOServer } = require('socket.io');
const bodyParser = require('body-parser');
const cors = require('cors');
const { db } = require('../db/db.js');

// Puedes importar modelos si ya tienes uno para 'registros' o 'alertas'

class Server {
    constructor() {
        this.app = express();
        this.server = http.createServer(this.app); // ← Importante
        this.io = new SocketIOServer(this.server, {
            cors: {
                origin: "*"
            }
        });

        this.port = process.env.PORT || 3003;
        this.paths = {
            home: '/',
            prueba: '/prueba',
        };

        this.connectDB();
        this.middlewares();
        this.routes();
        this.webSockets(); // ← Inicializar sockets
    }

    async connectDB() {
        try {
            await db.authenticate();
            console.log(' Database connected');
        } catch (error) {
            console.error(' Error connecting to database:', error);
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

    webSockets() {
        this.io.on('connection', (socket) => {
            console.log(' Cliente WebSocket conectado');

            socket.on('sensorData', async (data) => {
                console.log(' Datos recibidos desde Python:', data);

                // Desestructuramos datos recibidos
                const { estacion_id, ph, tds, temperatura, turbidez } = data;

                try {
                    // Lógica simple: guardar siempre que llegan datos
                    await db.query(`
                        INSERT INTO registros (estacion_id, ph, tds, temperatura, turbidez)
                        VALUES (?, ?, ?, ?, ?)`,
                        { replacements: [estacion_id, ph, tds, temperatura, turbidez] }
                    );

                    // Verificación de alerta (ejemplo con pH)
                    if (ph < 6.5 || ph > 8.5) {
                        await db.query(`
                            INSERT INTO alertas (estacion_id, tipo_alerta, valor, mensaje)
                            VALUES (?, ?, ?, ?)`,
                            { replacements: [estacion_id, 'pH', ph, ' pH fuera de rango'] }
                        );
                        console.log(' Alerta generada por pH');
                    }

                } catch (err) {
                    console.error(' Error al guardar datos:', err);
                }
            });

            socket.on('disconnect', () => {
                console.log(' Cliente desconectado');
            });
        });
    }

    listen() {
        this.server.listen(this.port, () => {
            console.log(` Servidor corriendo en puerto ${this.port}`);
        });
    }
}

module.exports = Server;
