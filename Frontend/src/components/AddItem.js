import React, { useState } from 'react';
import { addMatch } from '../Services/ChessAPIService';
import '../styling/AddMatchForm.css'; 

const AddMatchForm = () => {
    const [formData, setFormData] = useState({
        player1Id: '',
        player2Id: '',
        matchDate: '',
        matchLevel: '',
        winnerId: ''
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value
        });
    };

    const handleSubmit = async (e) => {
        try {
            const result = await addMatch(formData);
            alert('Match added successfully!');
            
            console.log(result);
        } catch (error) {
            console.error(error);
            alert('Failed to add match. Please try again.');
        }
    };

    return (
        <form className="add-match-form" onSubmit={handleSubmit}>
            <div className="form-row">
                <div className="form-group">
                    <label>Player 1 ID:</label>
                    <input
                        type="number"
                        name="player1Id"
                        required
                        value={formData.player1Id}
                        placeholder='Enter Player 1 Id'
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Player 2 ID:</label>
                    <input
                        type="number"
                        name="player2Id"
                        required
                        value={formData.player2Id}
                        placeholder='Enter Player 2 Id'
                        onChange={handleChange}
                    />
                </div>
            </div>
            <div className="form-group">
                <label>Match Date:</label>
                <input
                    type="date"
                    name="matchDate"
                    required
                    value={formData.matchDate}
                    onChange={handleChange}
                />
            </div>
            <div className="form-group">
                <label>Match Level:</label>
                <input
                    type="text"
                    name="matchLevel"
                    required
                    value={formData.matchLevel}
                    placeholder='Enter Match Level'
                    onChange={handleChange}
                />
            </div>
            <div className="form-group">
                <label>Winner ID:</label>
                <input
                    type="number"
                    name="winnerId"
                    required
                    value={formData.winnerId}
                    placeholder='Enter Winner Id'
                    onChange={handleChange}
                />
            </div>
            <button type="submit">Submit</button>
        </form>
    );
};

export default AddMatchForm;