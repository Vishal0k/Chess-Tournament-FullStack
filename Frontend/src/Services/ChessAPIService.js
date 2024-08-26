import axios from 'axios'
const url = 'http://localhost:5082/api/Chess';


async function getPlayerByCountry(country, column) {
    let data = null;
    try {
        let response = await axios.get(`${url}/GetPlayerByCountry`, {
            params: {
                country: country,
                column: column
            }
        });
        if (response.status === 200) {
            data = await response.data;
        }
    } catch (error) {
        console.error(error);
        return null;
    }
    return data;
}

const addMatch = async (match) => {
    let data = null;
    try {
        let response = await axios.post(`${url}/AddMatch`, match);
        if (response.status === 200 && response.data !== null) {
            data = await response.data;
        }
    }
    catch (error) {
        console.error(error);
        return JSON.stringify(error);
    }
    return data;
}

async function GetPlayerWinPercentage() {
    let data = null;
    try {
        let response = await axios.get(`${url}/GetPlayerWinPercentage`);
        if (response.status === 200) {
            data = await response.data;
        }
    } catch (error) {
        console.error(error);
        return null;
    }
    return data;
}

async function GetPlayerWinPercentageByAverageOfWins() {
    let data = null;
    try {
        let response = await axios.get(`${url}/GetPlayerWinPercentageByAverageOfWins`);
        if (response.status === 200) {
            data = await response.data;
        }
    } catch (error) {
        console.error(error);
        return null;
    }
    return data;
}

export { getPlayerByCountry, addMatch, GetPlayerWinPercentage, GetPlayerWinPercentageByAverageOfWins };