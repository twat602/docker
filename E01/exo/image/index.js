const path = require('path');
const express = require('express');

const port = process.env.PORT || 3000;

const app = express();

app.set('view engine', 'ejs');
app.set('views', './app/views');

app.use(express.static(path.join(__dirname, './assets')));

app.get('/', (req, res) => {
    res.send('<p>Hello from dockerized Express debug !!<p>');
});

app.listen(port, (_) => {
    console.log(`http://localhost:${port}`);
});
