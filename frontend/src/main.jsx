import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Routes, Route } from "react-router";
import 'css/style.css'
import Layout from './Layout.jsx'
import ResumePage from 'pages/ResumePage'

createRoot(document.querySelector('main')).render(
  <BrowserRouter>
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<ResumePage />} />
      </Route>
    </Routes>
  </BrowserRouter>
)
