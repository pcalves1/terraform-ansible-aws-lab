const logger = require('../../logger/logger')
const dbOpts = require('./dbConfig')
const mysql = require("mysql2/promise")

let pool;
let isConnected = false;


async function connect() {
    try {
        let conn = mysql.createPool(dbOpts);
        pool = await conn.getConnection()
        isConnected = true;
        logger.info('Conexão com o banco de dados estabelecida');
    } catch (error) {
        logger.error(error)
        isConnected = false;
        setTimeout(connect, 5000);
    }
}

async function dbConfig() {

    await createDatabaseIfNotExists()
    await createTableIfNotExists()
}

async function createDatabaseIfNotExists() {

    try {
        if (!isConnected) {
            await connect()
        }
        await pool.query(`CREATE DATABASE IF NOT EXISTS todo_items`)
        logger.info(`Database todo_items created or already exists.`)
        pool.release()
    } catch (error) {
        logger.error('Error creating database:', error)
        return false
    }
}

async function createTableIfNotExists() {
    try {
        if (!isConnected) {
            await connect()
        }
        await pool.query('USE todo_items')
        await pool.query(
            `CREATE TABLE IF NOT EXISTS items (id varchar(36), name varchar(255), completed boolean) DEFAULT CHARSET utf8mb4`
        )
        logger.info(`Table items created or already exists`)
        pool.release()
    } catch (error) {
        logger.error(`Could not fetch the request. ${error}`)
        return false
    }
}

async function getItems() {
    try {
        if (!isConnected) {
            await connect()
        }
        const [rows] = await pool.query('SELECT * FROM items')
        logger.debug(`Items retrieved`)
        const response = rows.map(item => ({
            ...item,
            completed: item.completed === 1
        }))
        pool.release()
        return response
    } catch (error) {
        logger.error(`Could not fetch the request. ${error}`)
        setTimeout(connect, 5000);
    }
}

async function getItem(id) {
    try {
        if (!isConnected) {
            await connect()
        }
        const [rows] = await pool.query('SELECT * FROM items WHERE id=?', [id])
        logger.debug("Items retrieved")
        const response = rows.map(item => ({
            ...item,
            completed: item.completed === 1
        }))[0]
        pool.release()
        return response
    } catch (error) {
        logger.error(`Could not fetch the request. ${error}`)
        setTimeout(connect, 5000);
    }
}

async function storeItem(item) {
    try {
        if (!isConnected) {
            await connect()
        }
        await pool.query(
            'INSERT INTO items (id, name, completed) VALUES (?, ?, ?)',
            [item.id, item.name, item.completed ? 1 : 0]
        )
        pool.release()
        logger.debug(`Item [${item.id}] created`)
    } catch (error) {
        logger.error(`Could not fetch the request. ${error}`)
        setTimeout(connect, 5000);
    }
}

async function updateItem(id, item) {
    try {
        if (!isConnected) {
            await connect()
        }
        await pool.query(
            'UPDATE items SET name=?, completed=? WHERE id=?',
            [item.name, item.completed ? 1 : 0, id]
        )
        logger.debug(`Item strikethrough marked as [${item.completed}]`)
        pool.release()
    } catch (error) {
        logger.error(`Could not fetch the request. ${error}`)
        setTimeout(connect, 5000);
    }
}

async function removeItem(id) {
    try {
        if (!isConnected) {
            await connect()
        }
        await pool.query('DELETE FROM items WHERE id = ?', [id])
        logger.debug(`Item [${id}] removed`)
        pool.release()
    } catch (error) {
        logger.error(`Could not fetch the request. ${error}`)
        setTimeout(connect, 5000);
    }
}

module.exports = {
    dbConfig,
    getItems,
    getItem,
    storeItem,
    updateItem,
    removeItem,
}