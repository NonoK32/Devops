from pathlib import Path
import sys

from fastapi.testclient import TestClient

# Ensure the project root is importable in CI environments.
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import main


client = TestClient(main.app)


def test_search_word_returns_matching_files(tmp_path: Path, monkeypatch) -> None:
    (tmp_path / "uno.txt").write_text("Hola mundo", encoding="utf-8")
    (tmp_path / "dos.txt").write_text("python es util", encoding="utf-8")
    (tmp_path / "tres.txt").write_text("Aprendiendo PyThOn", encoding="utf-8")
    monkeypatch.setattr(main, "TXT_DIRECTORY", tmp_path)

    response = client.get("/", params={"palabra": "python"})

    assert response.status_code == 200
    assert response.json() == {
        "palabra": "python",
        "archivos": ["dos.txt", "tres.txt"],
        "found": True,
    }


def test_search_word_returns_empty_list_when_no_matches(tmp_path: Path, monkeypatch) -> None:
    (tmp_path / "uno.txt").write_text("Hola mundo", encoding="utf-8")
    monkeypatch.setattr(main, "TXT_DIRECTORY", tmp_path)

    response = client.get("/", params={"palabra": "java"})

    assert response.status_code == 200
    assert response.json() == {"palabra": "java", "archivos": [], "found": False}


def test_search_word_returns_500_if_directory_does_not_exist(monkeypatch) -> None:
    monkeypatch.setattr(main, "TXT_DIRECTORY", Path("directorio_que_no_existe"))

    response = client.get("/", params={"palabra": "python"})

    assert response.status_code == 500
    assert response.json()["detail"] == "El directorio de archivos TXT no existe o no es valido."


def test_query_validation_rejects_word_with_spaces() -> None:
    response = client.get("/", params={"palabra": "hola mundo"})

    assert response.status_code == 422
    assert "La palabra no puede contener espacios." in str(response.json())


def test_query_validation_trims_whitespace(tmp_path: Path, monkeypatch) -> None:
    (tmp_path / "uno.txt").write_text("python", encoding="utf-8")
    monkeypatch.setattr(main, "TXT_DIRECTORY", tmp_path)

    response = client.get("/", params={"palabra": " python "})

    assert response.status_code == 200
    assert response.json()["palabra"] == "python"
    assert response.json()["found"] is True
