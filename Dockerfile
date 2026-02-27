############################################################################################
#
#   _   _                      _       _____             _              ____  
#  | | | |_ __  _ __ ___  __ _| |     | ____|_ __   __ _(_)_ __   ___  | ___| 
#  | | | | '_ \| '__/ _ \/ _` | |_____|  _| | '_ \ / _` | | '_ \ / _ \ |___ \ 
#  | |_| | | | | | |  __/ (_| | |_____| |___| | | | (_| | | | | |  __/  ___) |
#   \___/|_| |_|_|  \___|\__,_|_|     |_____|_| |_|\__, |_|_| |_|\___| |____/ 
#                                                 |___/                                               
#
# UNREAL-ENGINE 5
#
# https://github.com/ayfantis53/unreal_5.3.2-ToonTanks/edit/master/Dockerfile

############################################################################################
# Unreal Engine 5 Building Layer
# This is a MINIMAL RUNTIME image to build Unreal Engine 5 game
# For building environment to run ToonTanks app
############################################################################################

# ============================================
# Stage 1: Builder
# ============================================
# Use Epic Games' official development image to build the project.
# This stage uses a large image with all necessary build tools (compilers, Unreal Engine source).
FROM ghcr.io/epicgames/unreal-engine:dev-5.4 AS builder

# Set the working directory inside the container. All subsequent commands in this stage will run from here.
WORKDIR /app

# Copy the local project files into the container's working directory.
COPY . .

# Run the Unreal Automation Tool (UAT) script to build, cook, and package the project.
# -project: Specifies the path to the .uproject file.
# -server: Indicates a dedicated server build.
# -nocompileeditor: Skips compiling editor-only code.
# -platform=Linux: Targets the Linux platform.
# -build: Compiles the source code.
# -cook: Converts assets into a format the engine can use.
# -pak: Packages cooked assets into a single .pak file.
# -archive: Collects the final output files into a specified directory.
# -archivedirectory: Specifies the destination for the archived files.
RUN /home/ue4/UnrealEngine/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun \
	-project=./ToonTanks.uproject \
	-server \
    -nocompileeditor \
    -platform=Linux \
    -build \
    -cook \
    -pak \
    -archive \
    -archivedirectory=/tmp/dist


# ============================================
# Stage 2: Runtime
# ============================================
# Use a lighter runtime image for the final, smaller container image.
# This image only contains the necessary shared libraries and engine binaries to run the packaged game, not build it.
FROM ghcr.io/epicgames/unreal-engine:runtime-5.4

# Set the working directory for the runtime container.
WORKDIR /app

# Copy the packaged files from the builder stage's archive directory to the current stage's working directory.
COPY --from=builder /tmp/dist/LinuxServer ./

# Define the command to run when the container starts.
# It executes the project's start-up script with specific command-line arguments:
# -log: Enables logging to standard output.
# -Port=7777: Sets the network port for the server.
CMD ["./ToonTanks.sh", "-log", "-Port=7777"]
