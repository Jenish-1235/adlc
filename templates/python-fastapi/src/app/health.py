from typing import Literal

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(tags=["health"])


class Health(BaseModel):
    status: Literal["ok"]


@router.get("/healthz")
async def healthz() -> Health:
    return Health(status="ok")
