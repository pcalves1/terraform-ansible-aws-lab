const logger = require('../../logger/logger');
const { createTableIfNotExists } = require('../persistence/dbConfig');
module.exports = getItems = async (pool, req, res) => {
    try {
        const [items] = await pool.query('SELECT * FROM items');
        logger.debug(`Items retrieved`)
        res.send(items);
    } catch (error) {
        logger.error(`Error fetching items: `, error);
        if (error.errno == 1146) {
            logger.debug("Trying to create table")
            await createTableIfNotExists()
            const [items] = await pool.query('SELECT * FROM items');
            logger.debug(`Items retrieved`)
            res.send(items);
        }
        res.status(500).send('Error fetching items');
    }
};
