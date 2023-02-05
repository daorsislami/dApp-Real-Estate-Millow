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

  const [provider, setProvider] = useState(null);
  const [escrow, setEscrow] = useState(null);
  const [account, setAccount] = useState(null);

  const [homes, setHomes] = useState(null);

  const loadBlockchainData = async () => {
    // Pull connection from Metamask
    // Metamask injects something into our browser called window.ethereum
    // window.ethereum in this case is the connection to Hardhat blockchain that we have running in localhost
    // This is our connection to the Ethereum Blockchain that's injected by Metamask
    // Ether is the library that connects our project to the blockchain. By default our app is not gonna talk to blockchain on it's own that's why we need Ether.js for
    // In order to create a connection to the blockchain we can use something called Ethers provider. We do that like this
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    console.log('PROVIDER: ', provider);
    setProvider(provider);

    // Connect to the blockchain to get to our smart contracts and load them up to our app
    // Different blockchain network, have different ID's, our local blockchain has an ID of 31337
    const network = await provider.getNetwork();

    // Get realEstate as a Javascript version of contract we can call function 
    const realEstate = new ethers.Contract(config[network.chainId].realEstate.address, RealEstate, provider)

    // Get total supply of homes
    const totalSupply = await realEstate.totalSupply();
    const homes = []

    for (var i = 1; i <= totalSupply; i++) {
      const uri = await realEstate.tokenURI(i);
      const response = await fetch(uri);
      const metadata = await response.json();
      homes.push(metadata);
    }

    setHomes(homes);
    console.log('homes val: ', homes);

    // Get escrow as a Javascript version of contract we can call function 
    const escrow = new ethers.Contract(config[network.chainId].escrow.address, Escrow, provider)
    setEscrow(escrow);

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
      <Search />
      <div className='cards__section'>

        <h3>Homes For You</h3>

        <hr />

        <div className='cards'>
          {homes ? homes.map((home, index) => (

            <div className='card' key={index}>
              <div className='card__image'>
                <img src={home.image} alt='Home'/>
              </div>
              <div className='card__info'>
                <h4>{home.attributes[0].value} ETH</h4>
                <p>
                  <strong>{home.attributes[2].value}</strong> bds |
                  <strong>{home.attributes[3].value}</strong> bath |
                  <strong>{home.attributes[4].value}</strong> sqft 
                </p>
                <p>
                  {home.address}
                </p>
              </div>
            </div>

          )) : ''}

          
          
        </div>

      </div>

    </div>
  );
}

export default App;
