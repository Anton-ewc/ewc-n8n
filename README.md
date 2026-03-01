# ewc-n8n

Docker-based setup for [n8n](https://n8n.io) — workflow automation. Run n8n in a container with persistent data and environment-based config.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- `.env` file for n8n configuration (see [Environment](#environment))

## Quick start

### Windows

1. Create a `.env` file in the project root (see [Environment](#environment)).
2. Run `run.bat`.
3. Choose **1** to build the image, then **2** to run the container.
4. Open n8n at **http://localhost:5678**.

### Linux / macOS

```bash
# Build
docker build -t n8n:tag1 .

# Run (uses .env from current directory)
docker run --env-file .env n8n:tag1
```

Or use the helper script:

```bash
./build_run.sh
```

## Project layout

| Path | Description |
|------|-------------|
| `Dockerfile` | Image based on `docker.n8n.io/n8nio/n8n:latest` |
| `run.bat` | Windows menu: Build, Run, Exit |
| `build_run.sh` | Build and run with `.env` |
| `.env` | Environment variables (not committed) |
| `n8n/` | Created at runtime; mounted as `/home/node/.n8n` for persistent workflows and credentials |

## Running on Windows (run.bat)

- **Build (1)** — Builds image `n8n:tag1`.
- **Run (2)** — Starts container named `n8n` with:
  - Port **5678** mapped to host
  - Volume **`./n8n`** → `/home/node/.n8n` (persistence)
  - Env loaded from **`.env`**

To stop: `docker stop n8n`. To start again: `docker start n8n` or use **Run (2)** in `run.bat` (after removing any existing `n8n` container if you changed options).

## Environment

Create a `.env` file in the project root. Example:

```env
# Optional: basic config
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http

# Optional: encryption for credentials (set your own key)
# N8N_ENCRYPTION_KEY=your-secret-key

# Add any other n8n env vars as needed
```

See [n8n environment variables](https://docs.n8n.io/hosting/environment-variables/) for full options.

## License

See [LICENSE](LICENSE) in the repository root.
