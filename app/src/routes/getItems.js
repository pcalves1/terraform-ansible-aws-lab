module.exports = async (pool, req, res) => {
    try {
        const [items] = await pool.promise().query('SELECT * FROM items');
        res.send(items);
    } catch (error) {
        console.error(`Error fetching items: ${error.message}`);
        res.status(500).send('Error fetching items');
    }
};
