import React from "react";
import 'css/pages/projects.css'
import projectsData from 'data/projectsData'
import ProjectItem from 'comps/ProjectItem'

export default function ProjectsPage() {
  return (
    <>
      <div class="projects">
        {projectsData.map((project) => (
          <ProjectItem key={project.handle} project={project} />
        ))}
      </div>
    </>
  )
}