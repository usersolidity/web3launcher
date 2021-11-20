import logo from './logo.svg';
import './App.css';
import * as React from 'react';
import ReactFullpage from '@fullpage/react-fullpage';

import Glider from 'react-glider';
import './glider-js/glider.min.css';
<style>
@import url('https://fonts.googleapis.com/css2?family=Lato:ital@1&family=Lexend+Deca&family=M+PLUS+1:wght@100&family=Mochiy+Pop+P+One&family=Montserrat:wght@100;700&family=Nunito:wght@600&family=Open+Sans&family=Outfit:wght@500&family=Ubuntu:ital,wght@1,700&display=swap');
</style>

function App() {
  return (
      <ReactFullpage
      //fullpage options
      licenseKey = {'YOUR_KEY_HERE'}
      scrollingSpeed = {1000} /* Options here */

      render={({ state, fullpageApi }) => {
        return (
          <ReactFullpage.Wrapper>
            <div className="section firstpage">
              <p className="hackName firstpagetext">FIGURA</p>
              <p className="hackDescription firstpagetext">DECENTRALIZED GAME STORE</p>
              <button className="firstpagebutton" onClick={() => fullpageApi.moveSectionDown()}>
                Learn More
              </button>
            </div>
            <div className="section ">
              <p>Section 2</p>
            </div>
          </ReactFullpage.Wrapper>
        );
      }}
    />
  );
}

export default App;