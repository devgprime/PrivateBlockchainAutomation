const express = require('express');
const Web3 = require('web3');
const bodyParser = require('body-parser');

const app = express();
const web3 = new Web3('http://localhost:8545');

// Replace with your contract's ABI and address
const contractABI = [ /* Your contract's ABI */ ];
const contractAddress = '0xYourContractAddress';
const validatorContract = new web3.eth.Contract(contractABI, contractAddress);

app.use(bodyParser.json());

app.post('/activate-validator', async (req, res) => {
  try {
    const { validatorId, account, privateKey } = req.body;

    if (!validatorId || !account || !privateKey) {
      return res.status(400).json({ error: 'Validator ID, account, and private key are required' });
    }

    // Encode the transaction data
    const txData = validatorContract.methods.activateValidator(validatorId).encodeABI();

    // Create the transaction object
    const tx = {
      from: account,
      to: contractAddress,
      gas: 2000000,
      data: txData,
    };

    // Sign the transaction
    const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);

    // Send the transaction
    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

    res.status(200).json({ message: 'Validator activated', receipt });
  } catch (error) {
    console.error('Error activating validator:', error);
    res.status(500).json({ error: 'Failed to activate validator' });
  }
});

app.listen(3000, () => {
  console.log('REST API server started on port 3000');
});
