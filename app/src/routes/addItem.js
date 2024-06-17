const { v4: uuid } = require('uuid');

module.exports = async (pool, req, res) => {
    const item = {
        id: uuid(),
        name: req.body.name,
        completed: false,
    };

    try {
        await pool.promise().query('INSERT INTO items SET ?', item);
        logger.debug(`Item [${item.id}] created`)
        res.send(item);
    } catch (error) {
        logger.error(`Error storing item: ${error.message}`);
        res.status(500).send('Error storing item');
    }
};
