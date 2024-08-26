import React from 'react'
import PlayerCards from './PlayerCard.js';

const ViewItem = () => {
  return (
    <>
    <h1 style={{ fontSize: '3rem', textAlign: 'center', color: 'black' }}>Player By Country</h1>
    <PlayerCards />
  </>
  )
}

export default ViewItem;