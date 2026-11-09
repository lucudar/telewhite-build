# telewhite-build

Сборка [Telewhite](https://github.com/lucudar/tdesktop) (форк Telegram Desktop) для Windows x64 через GitHub Actions.

В самом `lucudar/tdesktop` GitHub Actions сейчас не запускаются, поэтому сборка идёт здесь: workflow скачивает код из `lucudar/tdesktop` и собирает его тем же сценарием, что и `win.yml` форка (Release).

## Как собрать

- **Автоматически:** поменяй первую строку `build-ref.txt` (ветка, тег или коммит `lucudar/tdesktop`) и закоммить.
- **Вручную:** Actions → «Build Telewhite.» → Run workflow, поле `ref` (пусто — берётся из `build-ref.txt`).

## Где взять exe

Actions → нужный прогон → Artifacts → `Telewhite x64 <коммит>`. Архив хранится 7 дней.

Первая сборка холодная, около 5–5,5 часа (лимит GitHub — 6 часов). Потом библиотеки берутся из кэша, и сборка заметно быстрее. Свои ключи API: Secrets `TDESKTOP_API_ID` и `TDESKTOP_API_HASH` в этом репозитории, иначе используются тестовые.

## Установка и обновление

Откройте PowerShell (Пуск → «PowerShell») и выполните:

```powershell
irm https://raw.githubusercontent.com/lucudar/telewhite-build/main/install.ps1 | iex
```

Скрипт скачивает последнюю удачную сборку (релиз `latest`), ставит её в
`%LOCALAPPDATA%\Programs\Telewhite`, снимает пометку «скачано из интернета»,
создаёт ярлык «Telewhite» на рабочем столе и запускает клиент. Для обновления
выполните ту же команду ещё раз — запущенный Telewhite закроется и обновится.
