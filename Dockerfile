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
# Use a pre-built Unreal Engine 5 development image.
# This stage uses a large image with all necessary build tools (compilers, Unreal Engine source).
FROM ghcr.io/epicgames/unreal-engine:dev-5.3 AS builder

# Set environment variables for project name, paths, and build directory.
ENV UE_PROJECT_NAME="ToonTanks"
ENV UNREAL_PATH="/home/ue4/UnrealEngine"

# Switch to root user to handle file permissions and installations.
USER root

# Set the working directory for subsequent instructions.
WORKDIR /$UE_PROJECT_NAME

# Copy project files from the local machine into the container.
COPY . .

# Adjust file permissions to allow the 'ue4' user to access project and engine files.
RUN chown 1000 -R /$UE_PROJECT_NAME && \
    chown 1000 -R /home/ue4/UnrealEngine && \
    chown -R ue4:ue4 /home/ue4/UnrealEngine/Engine/Build

# Remove Windows-style line endings from a script if present.
# Generate Linux-specific project files.
# Cook and build the project for Linux.
RUN sed -i -e 's/\r$//' ./run.sh  \
    && $UNREAL_PATH/Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh -project=/$UE_PROJECT_NAME/$UE_PROJECT_NAME.uproject \
    && $UNREAL_PATH/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun -project=/$UE_PROJECT_NAME/$UE_PROJECT_NAME.uproject


# # ============================================
# # Stage 2: Runtime
# # ============================================
# # Use a lighter runtime image for the final, smaller container image.
# # This image only contains the necessary shared libraries and engine binaries to run the packaged game, not build it.
# FROM ghcr.io/epicgames/unreal-engine:dev-slim-5.7

# ENV UE_PROJECT_NAME

# # Set the working directory for the runtime container.
# WORKDIR /$UE_PROJECT_NAME

# # Copy the packaged files from the builder stage's archive directory to the current stage's working directory.
# COPY --from=builder /tmp/dist/LinuxServer ./

# # Define the command to run when the container starts.
# # It executes the project's start-up script with specific command-line arguments:
# # -log: Enables logging to standard output.
# # -Port=7777: Sets the network port for the server.
# CMD ["./$UE_PROJECT_NAME.sh", "-log", "-Port=7777"]
