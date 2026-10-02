# Загрузка в GitHub

## Вариант 1 — через сайт GitHub

1. Создай новый пустой репозиторий, например `kursovoi_bd_muminov`.
2. Распакуй архив проекта.
3. Нажми **Add file → Upload files**.
4. Перетащи содержимое папки проекта целиком.
5. Нажми **Commit changes**.

## Вариант 2 — через Git

В PowerShell в папке проекта:

```powershell
git init
git add .
git commit -m "Initial rental car coursework repository"
git branch -M main
git remote add origin https://github.com/<YOUR_LOGIN>/kursovoi_bd_muminov.git
git push -u origin main
```

`<YOUR_LOGIN>` замени на свой логин GitHub.
