from pathlib import Path
from typing import List

from fastapi import Depends, FastAPI, HTTPException
from fastapi.exceptions import RequestValidationError
from pydantic import BaseModel, Field, ValidationError, field_validator


TXT_DIRECTORY = Path("txt_files")

app = FastAPI(title="TXT Search API")


class SearchQueryParams(BaseModel):
    palabra: str = Field(..., min_length=1, max_length=100)

    @field_validator("palabra")
    @classmethod
    def validate_palabra(cls, value: str) -> str:
        clean_value = value.strip()
        if not clean_value:
            raise ValueError("La palabra no puede estar vacia.")
        if " " in clean_value:
            raise ValueError("La palabra no puede contener espacios.")
        return clean_value


class SearchResponse(BaseModel):
    palabra: str
    archivos: List[str]
    found: bool


def get_query_params(palabra: str) -> SearchQueryParams:
    try:
        return SearchQueryParams(palabra=palabra)
    except ValidationError as exc:
        # Convert pydantic model validation into FastAPI 422 response
        raise RequestValidationError(exc.errors()) from exc


@app.get("/", response_model=SearchResponse)
def search_word(params: SearchQueryParams = Depends(get_query_params)) -> SearchResponse:
    if not TXT_DIRECTORY.exists() or not TXT_DIRECTORY.is_dir():
        raise HTTPException(
            status_code=500,
            detail="El directorio de archivos TXT no existe o no es valido.",
        )

    matched_files: List[str] = []

    for txt_file in TXT_DIRECTORY.glob("*.txt"):
        content = txt_file.read_text(encoding="utf-8", errors="ignore")
        if params.palabra.lower() in content.lower():
            matched_files.append(txt_file.name)

    found_flag = matched_files.length > 0
    return SearchResponse(palabra=params.palabra, archivos=matched_files, found=found_flag)
