const express = require('express');
const app = express();
const morgan = require('morgan');
const cors = require('cors');


const config = {
    application: {
        cor: {
            server: [
                {
                    origin: "localhost:3005", 
                    credentials: true
                }
            ]
        }
    }
};

app.set('json spaces', 2);
app.set('port', 3005)
app.use(morgan('dev'));
app.use(cors(config.application.cor.server));
app.use(express.urlencoded({extended: false}));
app.use(express.json());


//routes
app.use(require('./routes/index'));



app.listen(app.get('port'), ()=>{
    console.log(`Server on port ${3005}`);
});
