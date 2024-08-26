import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './components/Home';
import ViewItem from './components/ViewItem';
import './App.css';
import AddMatchForm from './components/AddItem';
import WinPercentage from './components/WinPercentage';
import AverageWins from './components/AverageOfWins';

const App = () => {
    return (
        <div>
        <Router>
            <div className="App">
                <Navbar />
                <main>
                    <Routes>
                        <Route path="/" element={<Home />} />
                        <Route path="/add-match" element={<AddMatchForm />} />
                        <Route path="/player-by-country" element={<ViewItem />} />
                        <Route path='/win-percentage' element={<WinPercentage />} />
                        <Route path='/average-wins' element={<AverageWins />} />
                    </Routes>
                </main>
            </div>
        </Router>
        </div>
    );
};

export default App;
