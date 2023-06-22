const express = require('express');
const Web3 = require('web3');

const app = express();
const web3 = new Web3('http://localhost:8545'); 
app.post('/activate-validator', async (req, res) => {
}
)

app.listen(3000, () => {
  console.log('REST API server started on port 3000');
});
