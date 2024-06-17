const logger = require('../../logger/logger');
module.exports = async (pool, req, res) => {
    const id = req.params.id
    try {
        await pool.promise().query('DELETE FROM items WHERE id = ?', [req.params.id]);
        logger.debug(`Item [${id}] removed`)
        res.sendStatus(200);
    } catch (error) {
        logger.error(`Error deleting item: ${error.message}`);
        res.status(500).send('Error deleting item');
    }
};
