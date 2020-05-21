const {Router} = require('express');
const router = Router();
const parser = require('../java');

router.post('/', (req, res) => {
    res.json(parser.parse(req.body['data']));
});

module.exports = router;