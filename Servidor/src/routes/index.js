const {Router} = require('express');
const router = Router();

router.get('/', (req, res) => {
    res.json({"j":"juan"});
});

module.exports = router;