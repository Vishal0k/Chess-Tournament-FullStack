import React, { useEffect, useState } from 'react';
import { getPlayerByCountry } from '../Services/ChessAPIService'
import '../styling/PlayerCard.css';


const PlayerCards = () => {
    const [players, setPlayers] = useState([]);
    const [country, setCountry] = useState('');
    const [field, setField] = useState('');

    useEffect(() => {
        const fetchPlayers = async () => {
            const data = await getPlayerByCountry(country, field);
            if (data) {
                setPlayers(data);
                console.log(data);
            }
        };
        fetchPlayers();
    }, [country, field]);

    return (
        <>
        <div className="container">
            <form >
                <div>
                    <label >Country : </label>
                    <input
                        type="text"
                        value={country}
                        style={{marginBottom: '10px'}}
                        placeholder='Enter Country Name'
                        onChange={(e) => setCountry(e.target.value)}
                    />
                </div>
                <div>
                    <label>Field : </label>
                    <input
                        type="text"
                        value={field}
                        placeholder='Enter Field'
                        style={{marginBottom: '10px', marginLeft: '40px'}}
                        onChange={(e) => setField(e.target.value)}
                    />
                </div>
                <button style={{marginBottom: '10px'}} type="submit">Submit</button>
            </form>
            </div>


        <div className="player-cards">
            {players.map((player, index) => (
                <div key={index} className="card">
                    <h3>{player.firstName} {player.lastName}</h3>
                    <p>Player-ID : {player.playerID}</p>
                    <p>Country: {player.country}</p>
                    <p>Rating: {player.currentWorldRanking}</p>
                    <p>Match Played :{player.totalMatchesPlayed}</p>
                </div>
            ))}
        </div>
        </>
    );
};

export default PlayerCards ;