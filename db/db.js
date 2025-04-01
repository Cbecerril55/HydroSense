const { Sequelize } = require('sequelize');

const db = new Sequelize('aquaGuardDB', process.env.DBUSER, process.env.DBPASSWORD, {
    host: 'localhost',
    dialect: 'mysql',
    logging: false,
});

module.exports = {
    db,
};