import React from "react";
import 'css/pages/projects.css'
import projectsData from 'data/projectsData'
import { useParams } from "react-router-dom";
import { ChevronLeft } from 'lucide-react';
import { NavLink } from "react-router-dom";

export default function ProjectPage() {
  const { handle } = useParams();

  const project = projectsData.find(p => p.handle === handle);
  return (
    <>
      <NavLink className="bttn l-icon" to={`/projects`}>
        <ChevronLeft />
        Back to all projects
      </NavLink>
      <h1>{project.name}</h1>
      <p>{project.description}</p>
    </>
  )
}