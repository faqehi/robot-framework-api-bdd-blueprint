# 🎭 Restful-Booker BDD API Test Automation Framework

A production-grade, highly optimized API test automation framework built with Robot Framework targeting the Restful-Booker platform. This architecture transitions traditional scripting approaches into an engineering-first, parallel execution design, incorporating strict data contracts, cross-platform environment control wrappers, dynamic test data generation, and behavioral abstraction.

---

## 🏗️ Framework Architecture Overview

This project uses a layered **Separation of Concerns (SoC)** architecture. By splitting business-level test scripts from low-level network operations, the framework remains highly scalable, readable, and easy to maintain.

```text
  ┌──────────────────────────────────────────────────────────────────┐
  │  1. THE BUSINESS BEHAVIOR LAYER (tests/)                         │
  │     Declarative Gherkin scenarios focused strictly on behavior   │
  └──────────────────────────────┬───────────────────────────────────┘
                                 │ (Maps steps to keywords)
                                 ▼
  ┌────────────────────────────────────────────────────────────────┐
  │  2. THE TRANSLATION GLUE LAYER (src/api/resources/)            │
  │     Custom BDD step definitions, state tracking & assertions   │
  └──────────────────────────────┬─────────────────────────────────┘
                                 │ (Calls core client methods)
                                 ▼
  ┌────────────────────────────────────────────────────────────────┐
  │  3. THE CODE ENGINE SDK CLIENTS (src/api/clients/)             │
  │     Encapsulated requests.Session & persistent token handling  │
  └──────────────────────────────┬─────────────────────────────────┘
                                 │ (Hydrates payloads)
                                 ▼
  ┌────────────────────────────────────────────────────────────────┐
  │  4. STATELESS UTILITIES PLATFORM (src/utils/)                  │
  │     Faker-backed runtime data generators & helper functions    │
  └────────────────────────────────────────────────────────────────┘
```

### 📁 Directory Layout Blueprint

```text
├── src/
│   ├── api/
│   │   ├── clients/
│   │   │   └── BookingClient.py               # Low-level Python HTTP client & SDK verb abstractions
│   │   ├── config/
│   │   │   └── environments.py                # Multi-environment matrix routing configuration (Test, UAT, Prod)
│   │   ├── models/
│   │   │   └── booking_creation_schema.json   # JSON Schema validation contracts for payload assurance
│   │   └── resources/
│   │       ├── base_keywords.resource         # Decoupled BDD step definitions & reusable domain keywords
│   │       └── env_setup.resource             # Session initialization hooks & self-healing auth mechanics
│   └── utils/
│       └── DataGenerator.py                   # Dynamic data provisioning factory (Faker-backed payload engine)
├── tests/
│   └── restful_booker_bdd.robot               # Clean Gherkin test scenarios (Strictly business-acceptance-driven)
├── test-results/                              # Auto-generated HTML execution logs, visual run reports & metrics
├── requirements.txt                           # Version-pinned dependency manifest for deterministic environments
├── setup.sh                                   # One-click Unix platform bootstrapping & environment provisioning
└── run_tests.sh                               # Parameterized CI/CD-ready test execution orchestrator
```

---

## ✨ Features Included

*   **Dynamic Data Sanitization Matrix:** Eliminates brittle hardcoded data files by utilizing a custom `DataGenerator` mapping system powered by `Faker` to generate isolated inputs for parallel execution.
*   **Decoupled Environments Configuration:** Supports zero-friction configuration swapping between **Test**, **UAT**, and **Live** platforms through single terminal argument overrides.
*   **Strict Structural JSON Schema Matching:** Integrates automated schema compilation checking, ensuring that data structures or API parameter breaks are caught instantly before execution loops complete.

---

## 🚀 Getting Started

### 1. Prerequisite Environment Check
Ensure your computer has **Python 3.8+** installed locally and appended to your system variables path mapping.

### 2. Workspace Optimization (One-Click Setup)
Open your terminal inside the project root directory and trigger the workspace bootstrap scripts to install the clean, modern lean virtual dependency stack:

*   **On Windows Native Command Prompt (`cmd`):**
    ```cmd
    setup.cmd
    ```
*   **On macOS / Linux / Git Bash:**
    ```bash
    chmod +x setup.sh && ./setup.sh
    ```

---

## 🎭 Execution Execution Strategy

The execution scripts safely handle runtime virtual environment scopes and Python system module lookup paths (`PYTHONPATH=src`) under the hood.

### Running with Default Configurations
By default, triggering the execution wrapper without explicit arguments defaults execution loops straight to the **Test** sandbox environment:

*   **Windows Terminal:** `run_tests.cmd`
*   **UNIX / Git Bash Terminal:** `./run_tests.sh`

### Targeting Environments via Parameter CLI Arguments
Target specific cloud matrix configurations easily by appending the environment flag parameter:

```bash
# Execute suite against the UAT environment
./run_tests.sh uat

# Execute suite against Live Production gateways
./run_tests.sh live
```

### Filtering Executions Using Prioritization Tags
Filter target operations to run specific sub-collections utilizing built-in structural Robot Framework routing flags:

```bash
# Run only high-value Smoke regression blocks
set PYTHONPATH=src && robot --include Smoke --outputdir test-results/ tests/restful_booker_bdd.robot

# Run security assertion profiles exclusively
set PYTHONPATH=src && robot --include Security --outputdir test-results/ tests/restful_booker_bdd.robot
```

---

## 📊 Analytics & Reporting

Upon completing an execution run, full visual reporting dashboards are generated automatically inside the `test-results/` folder tree. Open either file in any web browser to drill down into metrics:

*   **`report.html`**: A high-level visual dashboard summarizing metrics, priorities tag metrics distribution (`P0`/`P1`), and absolute elapsed run times.
*   **`log.html`**: An interactive, itemized engineering log mapping detailed execution steps, complete with nested runtime response parameters, status codes, and payload structures for effortless debugging.
