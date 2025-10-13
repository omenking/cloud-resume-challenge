import React from "react";
import 'css/pages/projects.css'
import projectsData from 'data/projectsData.json'
import ProjectItem from 'comps/ProjectItem'

export default function ProjectsPage() {
  return (
    <>
            <h1 className='fancy'>Andrew Brown's Projects</h1>
      <div class="projects">
        {projectsData.map((project) => (
          <ProjectItem key={project.handle} project={project} />
        ))}
      </div>
    </>
  )
}