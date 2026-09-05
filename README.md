# docker-exercises-project

A Spring Boot + Gradle application containerized and deployed via a Jenkins CI/CD pipeline, backed by MySQL and phpMyAdmin, with images pushed to both a private Nexus registry and Docker Hub.

## DevOps Skills Applied

### CI/CD & Pipeline Engineering
- Wrote a multi-stage Jenkins declarative pipeline (checkout → build/test → image build → registry push)
- Diagnosed and fixed pipeline failures by reading Jenkins console output and stack traces methodically, tracing root causes top-down and bottom-up
- Restructured the pipeline to eliminate an architectural redundancy — removed duplicate Gradle execution across two environments with mismatched JDK versions — rather than patching around the symptom
- Used Jenkins Credentials (`withCredentials`, `usernamePassword`) to inject secrets securely instead of hardcoding them
- Proved pipeline portability by swapping a single credential reference to retarget the entire deployment destination (Nexus → Docker Hub) with no other changes required

### Containerization
- Wrote a multi-stage Dockerfile (separate build stage vs. slim runtime stage) to avoid shipping build tools and source code in the production image
- Applied Docker layer-caching strategy — splitting dependency-resolution copies from source-code copies — to speed up rebuilds
- Debugged image tagging, `COPY --from=`, working directories, and `CMD`/`ENTRYPOINT` semantics
- Diagnosed and fixed a cross-architecture performance issue (ARM64 emulation via QEMU vs. native x86_64) — a real, non-obvious infrastructure problem

### Orchestration
- Wrote a Docker Compose file wiring three services (app, MySQL, phpMyAdmin) with correct networking, environment variables, named volumes, and `depends_on`
- Understood and applied Compose's service-name-based DNS resolution as the modern replacement for manual `--link`/`localhost` configuration

### Artifact & Registry Management
- Pushed images to Docker Hub (public registry)
- Stood up a private Nexus registry from scratch: Docker-hosted repository format, port separation between the web UI and registry traffic, Docker Bearer Token Realm authentication, and insecure-registry trust configuration
- Understood the practical distinction between public and private registry workflows

### Linux / Systems Administration
- Diagnosed and repaired a Docker socket permission issue (`docker.sock` group ownership, root vs. non-root exec, `usermod`, `chmod`)
- Distinguished Docker-outside-of-Docker vs. Docker-in-Docker architectures and verified which one was actually in play rather than assuming
- Diagnosed disk space exhaustion (`df -h`, `docker system df`, build cache pruning) as the root cause of an unrelated-looking startup failure

### Build Tooling
- Debugged Maven (`mvn test` / `package`) and Gradle (`gradle test` / `build`) toolchains, including JDK version mismatches between environments
- Added the Gradle Wrapper (`gradlew`) to make builds environment-independent instead of relying on locally or globally installed tools

### Version Control
- Diagnosed and resolved a GitHub Personal Access Token scope/permission issue blocking pushes

### Debugging Methodology
- Consistently traced exceptions to their true root cause rather than stopping at the topmost symptom (e.g. following a Spring stack trace down to `ConnectException`, or recognizing `docker.sock` permissions as the real blocker behind an apparent insecure-registry problem)
- Verified assumptions with commands (`docker ps`, `id`, `ls -la`) instead of guessing
- Caught and self-corrected syntax errors (YAML indentation, JSON structure, Dockerfile path logic) methodically


