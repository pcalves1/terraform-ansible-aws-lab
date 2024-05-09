const db = require('../persistence/mysql');

module.exports = async (req, res) => {
    const items = await db.getItems();
    res.send(items);
};
