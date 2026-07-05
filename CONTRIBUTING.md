# 🤝 Contributing to This Project

First off, thank you for checking out this project! Whether you're here to fix a bug, improve documentation, or add a new test scenario, contributions are welcome.

As this repository serves as a reference blueprint for clean test automation architecture, please follow these guidelines to keep the codebase tidy and maintainable.

---

## 🛠️ Development Workflow

1. **Fork the Repository:** Create your own copy of this project on GitHub.
2. **Clone Locally:** Clone your fork to your computer and run the bootstrap script:
   * **Windows:** `setup.cmd`
   * **macOS/Linux:** `./setup.sh`
3. **Create a Feature Branch:** Keep your changes isolated (`git checkout -b feature/your-feature-name`).
4. **Write Tests & Keywords:** Adhere strictly to the **Separation of Concerns (SoC)** guidelines below.
5. **Verify the Run:** Ensure all tests pass locally before committing:
   * `run_tests.cmd` or `./run_tests.sh`

---

## 📐 Code Architecture Guidelines

To keep the repository clean and maintainable, please follow our 3-layer architecture design principles:

*   **The Test Layer (`.robot`):** Must contain *only* high-level, business-readable Gherkin BDD syntax (`Given`, `When`, `Then`). No low-level technical logic should ever be written here.
*   **The Step Layer (`.resource`):** Where Gherkin phrases are mapped to technical actions and structural data assertions.
*   **The Client SDK Layer (`.py`):** All raw HTTP requests (`GET`, `POST`, `PUT`, etc.) must be abstracted into custom Python libraries inside the `src/` directory.

### Spacing Convention
Robot Framework relies heavily on whitespace. Always ensure there are **at least two spaces or a tab** separating your keywords from their arguments.

---

## 🚀 Submitting Your Changes

1. **Commit Clearly:** Write clean, descriptive commit messages (e.g., `feat: add partial patch update bdd scenario`).
2. **Push and Pull:** Push your changes to your fork and submit a **Pull Request (PR)** against the main branch.
3. **Review:** Ensure your PR cleanly describes what was changed or added.

Thanks again for contributing!