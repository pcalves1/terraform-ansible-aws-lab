module.exports = async (pool, req, res) => {
    try {
        await pool.promise().query('UPDATE items SET ? WHERE id = ?', [
            { name: req.body.name, completed: req.body.completed },
            req.params.id,
        ]);
        const [items] = await pool.promise().query('SELECT * FROM items WHERE id = ?', [req.params.id]);
        res.send(items[0]);
    } catch (error) {
        console.error(`Error updating item: ${error.message}`);
        res.status(500).send('Error updating item');
    }
};
