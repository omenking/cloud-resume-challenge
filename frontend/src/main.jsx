import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Routes, Route } from "react-router-dom";

import Layout from './Layout.jsx'
import HomePage from 'pages/HomePage'
import ResumePage from 'pages/ResumePage'
import ProjectsPage from 'pages/ProjectsPage'
import ProjectPage from 'pages/ProjectPage'
import PostPage from 'pages/PostPage'

createRoot(document.querySelector('main')).render(
  <BrowserRouter>
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<HomePage />} />
        <Route path="/blog/:date/:handle" element={<PostPage />} />
        <Route path="/resume" element={<ResumePage />} />
        <Route path="/projects" element={<ProjectsPage />} />
        <Route path="/projects/:handle" element={<ProjectPage />} />
      </Route>
    </Routes>
  </BrowserRouter>
)
