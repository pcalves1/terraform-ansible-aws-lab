const express = require('express');
const db = require('./persistence/mysql');
const getItems = require('./routes/getItems');
const addItem = require('./routes/addItem');
const updateItem = require('./routes/updateItem');
const deleteItem = require('./routes/deleteItem');
const logger = require('../logger/logger');

const app = express();

app.use(express.json());
app.use(express.static(__dirname + '/static'));

app.get('/items', (req, res) => getItems(pool, req, res));
app.post('/items', (req, res) => addItem(pool, req, res));
app.put('/items/:id', (req, res) => updateItem(pool, req, res));
app.delete('/items/:id', (req, res) => deleteItem(pool, req, res));

const PORT = process.env.PORT || 4000;

db.dbConfig().then(() => {
    app.listen(PORT, () => logger.info(`Server listening on port ${PORT}`));
}).catch(err => {
    logger.error('Error setting up database:', err);
})
