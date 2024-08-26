import React, { useEffect, useState } from "react";
import { GetPlayerWinPercentage } from "../Services/ChessAPIService";
import '../styling/WinPercentage.css'

const WinPercentage = () => {
    const [players, setPlayers] = useState([]);

    useEffect(() => {
        const fetchPlayers = async () => {
            const data = await GetPlayerWinPercentage();
            if (data) {
                setPlayers(data);
                console.log(data);
            }
            else {
                console.error('Failed to fetch players');
                return null;
            }
        };
        fetchPlayers();
    }, []);

    return (
        <>
        <div className="player-cards">
            {players.map((player, index) => (
                <div key={index} className="card">
                    <h3>{player.fullName} </h3>
                    <p>total Matches Won : {player.totalMatchesWon}</p>
                    <p>win Percentage: {player.winPercentage}</p>
                </div>
            ))}
        </div>
        </>
    );
};

export default WinPercentage ;