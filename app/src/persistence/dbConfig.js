const logger = require('../../logger/logger')
const dbOpts = require('./dbOpts')
const mysql = require("mysql2/promise")

let pool;
let isConnected = false;

async function connect() {
    if (!isConnected) {
        logger.debug("Database connection is not established. Trying to connect...")
    }
    try {
        let conn = mysql.createPool(dbOpts);
        pool = await conn.getConnection()
        isConnected = true;
        logger.info('Database connection established');
        return pool;
    } catch (error) {
        logger.error("Database conecction error: " + error)
        isConnected = false;
        setTimeout(await connect(), 5000);
    }
}

async function dbSetup() {

    await createDatabaseIfNotExists()
    await createTableIfNotExists()
}

async function createDatabaseIfNotExists() {

    try {
        logger.debug('Checking if the database is connected');
        if (!isConnected) {
            await connect()
            logger.debug('Database connection established')
        }
        await pool.query(`CREATE DATABASE IF NOT EXISTS todo_items`)
        logger.info(`Database todo_items created or already exists.`)
    } catch (error) {
        logger.error('Error creating database:', error)
        return false
    }
}

async function createTableIfNotExists() {
    let pool;
    try {
        if (!isConnected) {
            pool = await connect()
        }
        await pool.query('USE todo_items')
        await pool.query(
            `CREATE TABLE IF NOT EXISTS items (id varchar(36), name varchar(255), completed boolean) DEFAULT CHARSET utf8mb4`
        )
        logger.info(`Table items created or already exists`)
    } catch (error) {
        logger.error(`Could not create table. ${error}`)
        return false
    }
}

module.exports = {
    dbSetup,
    createTableIfNotExists,
    connect
}
