# Project Generator

A scaffolding tool to create new Makefile or Qt projects from templates.

## Features

- **Makefile Projects**: Complex Makefile with debug/release modes, automatic dependency tracking
- **Qt Projects**: Full Qt application template with MainWindow, menus, statusbar

## Directory Structure

```
project-generator/
├── scripts/
│   └── newproject.sh          # Main script
├── templates/
│   ├── makefile/              # Makefile project template
│   │   ├── src/
│   │   ├── include/
│   │   └── Makefile
│   └── qt/                    # Qt project template
│       ├── src/
│       ├── include/
│       └── @PROJECT_NAME@.pro
└── README.md
```

## Usage

### Create a Makefile project:
```bash
./scripts/newproject.sh myapp makefile
cd myapp
make
./myapp
```

### Create a Qt project:
```bash
./scripts/newproject.sh myapp qt
cd myapp
qmake @PROJECT_NAME@.pro
make
./@PROJECT_NAME@
```

## Makefile Project Features

- Automatic dependency tracking
- Debug/Release modes
- Clean build structure
- Colorful output
- Built-in help

## Qt Project Features

- Standard Qt application structure
- MainWindow with menu bar
- Status bar
- Signal/slot connections
- Example actions

## Adding Custom Templates

1. Create a new directory under `templates/`
2. Use `@PROJECT_NAME@` as placeholder for project name
3. Run the script with your template name

## Requirements

- **Makefile projects**: g++ with C++17 support
- **Qt projects**: Qt5 or Qt6 with qmake
