import { useEffect, useState } from 'react';
import { ethers } from 'ethers';

// Components
import Navigation from './components/Navigation';
import Search from './components/Search';
import Home from './components/Home';

// ABIs
import RealEstate from './abis/RealEstate.json'
import Escrow from './abis/Escrow.json'

// Config
import config from './config.json';

import React, { Component }  from 'react';

function App() {

  const [account, setAccount] = useState(null)

  const loadBlockchainData = async () => {
    // Pull connection from Metamask
    // Metamask injects something into our browser called window.ethereum
    // window.ethereum in this case is the connection to Hardhat blockchain that we have running in localhost
    // This is our connection to the Ethereum Blockchain that's injected by Metamask
    // Ether is the library that connects our project to the blockchain. By default our app is not gonna talk to blockchain on it's own that's why we need Ether.js for
    // In order to create a connection to the blockchain we can use something called Ethers provider. We do that like this
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    console.log('PROVIDER: ', provider);



    // If the account gets changed execute the code down below
    window.ethereum.on('accountsChanged', async () => {
      const accounts = await window.ethereum.request({method: 'eth_requestAccounts' });
      const account = ethers.utils.getAddress(accounts[0]);
      setAccount(account);
    })
  }

  useEffect(() => {
    loadBlockchainData();
  }, [])

  return (
    <div>

      <Navigation account={account} setAccount={setAccount}/>
      <div className='cards__section'>

        <h3>Welcome to Millow!</h3>

      </div>

    </div>
  );
}

export default App;
