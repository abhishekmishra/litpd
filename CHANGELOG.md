# CHANGELOG
This file documents major changes in every release of the project. The project follows [Semantic Versioning](https://semver.org/). There is a section for each release - which lists major changes made in the release.

**0.1.0-alpha.0**  2024-03-31 Abhishek Mishra  <abhishekmishra3@gmail.com>

- This is the first alpha release of **litpd**.
- **litpd** is a utility to write *literate programs* using **pandoc**.
  - One writes a program in **pandoc** markdown.
  - The code blocks in the markdown are extracted using a lua filter, and placed
    in their appropriate files during document generation.
  - Since pandoc can also generate the document in a publish-able format during
    generation, we have generated both literate program in a readable article
    form, and a runnable source-code form.
  - For more see `litpd.md` which is this program written as a **literate**
    **program**. 
