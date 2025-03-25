


main2/
├ docker/
│   ├ php-fpm/
│   │   └ Dockerfile
│   └ nginx/
│       └ Dockerfile
├ src/         (← Laravelプロジェクトルート)
│   ├ app/
│   │   ├ Http/
│   │   │   └ Controllers/
│   │   ├ Models/
│   │   └ Services/
│   │       └ Sudoku/
│   │           ├ SudokuGenerator.php
│   │           ├ SudokuSolver.php
│   │           ├ SudokuValidator.php
│   │           └ SudokuRepository.php
│   ├ config/
│   ├ database/
│   ├ public/
│   ├ resources/
│   │   └ views/
│   │       └ sudoku/
│   └ tests/
├ .env
└ docker-compose.yml
