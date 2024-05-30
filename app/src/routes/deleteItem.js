module.exports = async (pool, req, res) => {
    try {
        await pool.promise().query('DELETE FROM items WHERE id = ?', [req.params.id]);
        res.sendStatus(200);
    } catch (error) {
        console.error(`Error deleting item: ${error.message}`);
        res.status(500).send('Error deleting item');
    }
};
