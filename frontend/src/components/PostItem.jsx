import React from "react";
import { NavLink } from "react-router-dom";

export default function ProjectItem(props) {
  const post = props.post;
  return (
    <NavLink className='post_item' to={`/blog/${post.date}/${post.handle}`}>
      <span className='name'>{post.name}</span>
      <span className='date'>{post.date}</span>
    </NavLink>
  );
}