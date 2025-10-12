import React from "react";
import 'css/pages/home.css'
import andrew_brown from 'images/andrew-brown.jpg'

export default function HomePage() {
  return (
    <>
        <div class="profile_picture">
          <img src={andrew_brown} />
        </div>
    </>
  )
}