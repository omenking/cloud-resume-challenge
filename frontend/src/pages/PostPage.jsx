import React from "react";
import 'css/pages/post.css'
import blogData from 'data/blogData.json'
import { useParams } from "react-router-dom";
import { ChevronLeft } from 'lucide-react';
import { NavLink } from "react-router-dom";

export default function PostPage() {
  const { handle, date } = useParams();

  const post = blogData.find(p => p.handle === handle);
  return (
    <>
      <NavLink className="bttn l-icon" to={`/`}>
        <ChevronLeft />
        Back to Home Page
      </NavLink>
      <h1 className='fancy'>{post.name}</h1>
      <div className="date">{post.date}</div>
      <div className="markdown" dangerouslySetInnerHTML={{ __html: post.body_html }} />
    </>
  )
}