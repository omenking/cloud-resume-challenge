import json, sys, markdown, yaml, re
from pathlib import Path

def render_items(folder):
  base = Path(__file__).resolve().parent.parent.parent
  input_dir = base / 'backend' / 'data' / folder
  output_path = base / 'frontend' / 'src' / 'data' / f"{folder}Data.json"

  markdown_files = list(input_dir.glob("*.md"))

  items = []
  for md_file in markdown_files:
      content = md_file.read_text(encoding='utf-8')

      # Extract front matter (between --- ---)
      match = re.match(r"---\n(.*?)\n---\n(.*)", content, re.DOTALL)
      if not match:
          print(f"⚠️  No front matter found in {md_file.name}, skipping.")
          continue

      front_matter, body = match.groups()
      metadata = yaml.safe_load(front_matter)
      metadata["body_html"] = markdown.markdown(body)
      items.append(metadata)

  with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(items, f, ensure_ascii=False, indent=2)