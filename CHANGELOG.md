# CHANGELOG
This file documents major changes in every release of the project. The project follows [Semantic Versioning](https://semver.org/). There is a section for each release - which lists major changes made in the release.

**0.1.0-alpha.1**  2024-05-10 Abhishek Mishra  <abhishekmishra3@gmail.com>

- This is the second alpha release of **litpd**.
- **litpd** now supports code fragment blocks which can be reused in code file 
  blocks. 
  - Every reusable code fragment block is identified by a `code_id`.
  - A `code_id` is an alphanumeric identifier.
  - The code from a `code_id` fragment can be included in another `code_id` or
    `code_file` fragment by referring to it in the following form `@<CODE_ID@>`,
    where `CODE_ID` is the value of the `code_id` attribute of the code block.
  - Example usage of `code_id` is given in the tests.
- The program also creates labels for `code_id` and `code_file` code blocks,
  showing the associated `id` or `file. Again there are some examples in the
  tests.

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
