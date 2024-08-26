import React from 'react';
import { Link } from 'react-router-dom';
import '../styling/Navbar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <div className="navbar-brand">
                <img
                    src="https://img.freepik.com/free-photo/assortment-chess-pieces-with-dramatic-scenery_23-2150829001.jpg"
                    alt="Chess Logo"
                    className="navbar-logo-image"
                />
                <Link to="/" className="navbar-logo">Chess-With-Vishal</Link>
            </div>
            <ul className="navbar-menu">
                <li><Link to="/" className="navbar-item button-link">Home</Link></li>
                <li><Link to="/add-match" className="navbar-item button-link" >Add Player </Link></li>
                <li><Link to="/player-by-country" className="navbar-item button-link" >View Player</Link></li>
                <li><Link to="/win-percentage" className="navbar-item button-link" >Win Percentage</Link></li>
                <li><Link to="/average-wins" className="navbar-item button-link" >Average Wins</Link></li>
            </ul>
        </nav>
    );
};

export default Navbar;
