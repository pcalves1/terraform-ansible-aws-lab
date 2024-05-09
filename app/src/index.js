const express = require('express');
const app = express();
const db = require('./persistence/mysql');
const getItems = require('./routes/getItems');
const addItem = require('./routes/addItem');
const updateItem = require('./routes/updateItem');
const deleteItem = require('./routes/deleteItem');
const logger = require('../logger/logger');


app.use(express.json());
app.use(express.static(__dirname + '/static'));

app.get('/items', getItems);
app.post('/items', addItem);
app.put('/items/:id', updateItem);
app.delete('/items/:id', deleteItem);

const PORT = process.env.PORT || 3000;

const dbConfig = db.dbConfig()

if (!dbConfig) {
    throw new Error('dbConfig not set')
}

app.listen(PORT, () => logger.info(`Server listening on port ${PORT}`));