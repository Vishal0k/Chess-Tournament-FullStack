import React, { useEffect, useState } from "react";
import { GetPlayerWinPercentageByAverageOfWins } from "../Services/ChessAPIService";
import '../styling/WinPercentage.css'

const AverageWins = () => {
    const [players, setPlayers] = useState([]);

    useEffect(() => {
        const fetchPlayers = async () => {
            const data = await GetPlayerWinPercentageByAverageOfWins();
            if (data) {
                setPlayers(data);
                // console.log(data);
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
                    <p>win Percentage: {Math.round(player.winPercentage)} %</p>
                </div>
            ))}
        </div>
        </>
    );
};

export default AverageWins ;