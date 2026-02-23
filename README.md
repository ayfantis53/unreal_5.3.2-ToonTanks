## TOON TANKS 5.3.2 (LINUX)

- Tank game built in cpp (No Blueprints)


-----------------------------------------------------------------------------------------------------------------
## Game Initialization
### 1. Dependencies
#### Unreal Engine Binaries (need a github account)
- Navigate to Unreal Github **[https://github.com/EpicGames/UnrealEngine/tree/5.3.2-release]**
- Clone specific repo
    ```bash
    git clone git@github.com:EpicGames/UnrealEngine.git
    ```
#### Set **[$UNREAL_PATH]** env var
- in **`~/.basrc`** set path to wherever your binaries are located on your computer.
- export **$UNREAL_PATH=<path-to-your-binaries>**
#### Build binaries
```bash
./Setup.sh
./GenerateProjectFiles.sh
Engine/Build/BatchFiles/RunUAT.sh BuildGraph -target="Make Installed Build Linux" -script="Engine/Build
```
### 2. Generate necessary files
- Link Engine to project (Makefile and etc)
    ```bash
    ./run.sh -g ||  ./run.sh --generate
    ```

### 3. Unreal Editor
- Enable Shader Model 6 (SM6)
    * **Project Settings -> Platforms -> Linux -> Targeted RHIs**
- Animation Blueprints have to be found as classes and their paths have to have a **"_C"** at the end of the reference.


-----------------------------------------------------------------------------------------------------------------
## Running Game
### Compiling and Running Editor
```bash
# Compile Unreal cpp code
./run.sh -c ||  ./run.sh --compile
# Run Compiled Unreal cpp code in editor
./run.sh -e ||  ./run.sh --editor
```
### Packaging (Development, Shipping,Debug)
```bash
./run.sh -p <BuildType> ||  ./run.sh --package <BuildType>
    # Examples:
        ./run.sh -p Development 
        ./run.sh --package Shipping    
        ./run.sh --package Debug
```  
### Running packaged game
```bash 
# Run packaged game
./run.sh -r     ||  ./run.sh --run
# Package a game and Run packaged game
./run.sh -b     ||  ./run.sh --build
```
### Cleanup (Binaries, Intermediate, Saved, Build) or all .core crash files
```bash 
./run.sh -x     ||  ./run.sh --clean
./run.sh -x all ||  ./run.sh --clean all
```


-----------------------------------------------------------------------------------------------------------------
## Testing
### 1. Running Unit tests
#### Single or Groups of tests
```bash 
./run.sh -u <TestName>      ||      ./run.sh --unit-test<TestName>
# Examples:
./run.sh -u Pawns  
./run.sh -u Pawns.BasePawn
./run.sh -u Pawns.BasePawn.SpawnActor
```
#### All tests
```bash 
./run.sh -u                 ||      ./run.sh --unit-test
```
### 2. Running Functional tests
#### Individual tests
- **Single tests Headless**
    ```bash 
    ./run.sh -f <TestName>              ||      ./run.sh --func-test <TestName>
    # Examples:
    ./run.sh -f TT_functional_test_player
        # Single tests Editor
        ./run.sh -f <TestName> EDITOR   ||      ./run.sh --func-test <TestName> EDITOR
        # Examples:
        ./run.sh -f TT_functional_test_tank EDITOR
    ```
- **Every test**
    ```bash 
    # All tests Headless
    ./run.sh -f             ||      ./run.sh -func
    # All tests Editor
    ./run.sh -f EDITOR      ||      ./run.sh -func EDITOR
    ```
