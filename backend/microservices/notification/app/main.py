"""Notification microservice - entry point.

Run:  uvicorn app.main:app --reload --port 8084
  or: python -m app.main
"""
import os
from contextlib import asynccontextmanager

from fastapi import FastAPI

import py_eureka_client.eureka_client as eureka_client

from app.routers import notification

PORT = int(os.getenv("PORT", "8084"))
EUREKA_SERVER = os.getenv("EUREKA_SERVER", "http://localhost:8761/eureka")


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Register in Eureka and start the 30s heartbeats.
    # The async variants are required here: the sync init()/stop() call
    # get_event_loop().run_until_complete(), which raises "Cannot run the event
    # loop while another loop is running" inside the ASGI server's own loop.
    await eureka_client.init_async(
        eureka_server=EUREKA_SERVER,
        app_name="NOTIFICATION",
        instance_port=PORT,
        # Without this the client auto-detects the interface IP, which can
        # register the instance as unreachable (169.254.x.x).
        instance_ip="127.0.0.1",
        status_page_url=f"http://localhost:{PORT}/api/notifications/hello",
        health_check_url=f"http://localhost:{PORT}/api/notifications/hello",
    )
    print(f"registered in Eureka as NOTIFICATION on port {PORT}")
    yield
    await eureka_client.stop_async()


app = FastAPI(
    title="Notification Microservice API",
    version="1.0.0",
    description=(
        "Notification microservice (Python / FastAPI, no database). "
        "Only the hello endpoint is implemented; the notification logic is to be developed by students."
    ),
    contact={"name": "Badia Abouhdid"},
    servers=[{"url": f"http://localhost:{PORT}", "description": "Local"}],
    # Same URLs as the other microservices of the project
    docs_url="/swagger-ui",       # Swagger UI
    openapi_url="/v3/api-docs",   # OpenAPI JSON
    redoc_url="/redoc",           # alternative documentation
    lifespan=lifespan,
)

app.include_router(notification.router)

# TODO (students): if you add other routers, include them here.


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("app.main:app", host="0.0.0.0", port=PORT, reload=True)
