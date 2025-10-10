import React from "react";

export default function ResumePage() {
  return (
    <>
      <section className="header">
        <h1>Andrew Brown</h1>
        <p>
          710 Winnipeg St, Schreiber, ON P0T 2S0, Canada
          &bull;
          <a href="mailto:andrew@exampro.co">andrew@exampro.co</a>
          &bull;
          +1 807-222-2323
        </p>
      </section>

      <section className="education">
        <h2>Education</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Confederation College</h3>
                <p>Ontario College Advanced Diploma (3 years)</p>
              </div>
              <div className="details">
                <div className="location">Thunder Bay, ON</div>
                <div className="duration">2007</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="experience">
        <h2>Experience</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>ExamPro Training Inc &mdash; CEO and Co-founder</h3>
                <p>Free cloud learning study courses platform</p>
              </div>
              <div className="details">
                <div className="location">Schreiber, ON</div>
                <div className="duration">2018-2025</div>
              </div>
            </div>
            <ul>
              <li>Built a custom multi-tenant learning management system, deployed to AWS</li>
              <li>Created over 40 courses and 1000+ hours of educational content</li>
            </ul>
          </div>
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Monsterbox Productions &mdash; Owner</h3>
                <p>Ruby on Rails web-development firm</p>
              </div>
              <div className="details">
                <div className="location">Toronto, ON</div>
                <div className="duration">2009-2018</div>
              </div>
            </div>
            <ul>
              <li>Built 50+ web-applications for various tech startups</li>
            </ul>
          </div>
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>PC Medic &mdash; IT Technician</h3>
                <p>Computer Repair</p>
              </div>
              <div className="details">
                <div className="location">Thunder Bay, ON</div>
                <div className="duration">2003-2009</div>
              </div>
            </div>
            <ul>
              <li>Hardware repairs, troubleshooting common computer issues</li>
              <li>Onsite training and computer repair</li>
            </ul>
          </div>
        </div>
      </section>

      <section className="leadership">
        <h2>Leadership &amp; Activities</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>Cloud Resume Challenge Bootcamp</h3>
                <p>I maintain the community project Cloud Resume Challenge</p>
              </div>
              <div className="details">
                <div className="location">Online</div>
                <div className="duration">2025 May &mdash; Present</div>
              </div>
            </div>
            <ul>
              <li>Update eBooks</li>
              <li>Created new video course</li>
              <li>Created companion cloud essentials course</li>
            </ul>
          </div>
        </div>
      </section>

      <section className="skills">
        <h2>Skills &amp; Interests</h2>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>ExamPro Cloud Essentials</h3>
                <p>Cloud Fundamentals and multi-cloud knowledge</p>
              </div>
              <div className="details">
                <div className="code">Japan/Toronto</div>
                <div className="duration">Valid Till: 2025-2028</div>
              </div>
            </div>
          </div>
        </div>
        <div className="items">
          <div className="item">
            <div className="item_heading">
              <div className="info">
                <h3>JLPT Certification</h3>
                <p>I'm currently studying Japanese aiming to pass the JLPT N4 in 2025-2026</p>
              </div>
              <div className="details">
                <div className="location">Japan/Toronto</div>
                <div className="duration">2025 May &mdash; Present</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <div className="disclaimer">
        This is an example résumé for instructional content and is not intended to be accurate.
      </div>
    </>
  );
}