const {Router} = require('express');
const router = Router();
const parser = require('../java');

router.post('/parser', (req, res) => {
    var ast = parser.parse(req.body.data);
    var respuesta = JSON.stringify(ast, null, 2);
    res.send(respuesta);
});

module.exports = router;