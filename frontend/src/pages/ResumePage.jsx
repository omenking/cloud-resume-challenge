import React from "react";
import 'css/pages/resume.css'

import resumeData from 'data/resumeData'
import ResumeHeader from 'comps/resume/ResumeHeader'
import ResumeSection from 'comps/resume/ResumeSection'

export default function ResumePage() {
  

  return (
    <>
      <ResumeHeader person={resumeData.person}></ResumeHeader>
      <ResumeSection title='Education' handle='education' section={resumeData.sections.education} />
      <ResumeSection title='Experience' handle='experience' section={resumeData.sections.experience} />
      <ResumeSection title='Leadership & Activities' handle='leadership' section={resumeData.sections.leadership} />
      <ResumeSection title='Skills & Interests' handle='skills' section={resumeData.sections.skills_interests} />
      <div className="disclaimer">
        This is an example résumé for instructional content and is not intended to be accurate.
      </div>
    </>
  );
}