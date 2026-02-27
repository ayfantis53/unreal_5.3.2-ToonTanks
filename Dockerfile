# Perform the build in an Unreal Engine container image that includes the Engine Tools and Pixel Streaming for Linux
FROM --platform=${BUILDPLATFORM:-linux/amd64} ghcr.io/epicgames/unreal-engine:dev-5.1 AS builder

# Copy UE4 project (assumes `.uproject` in this directory)
COPY --chown=ue4:ue4 . /tmp/project
WORKDIR /tmp/project


RUN /home/ue4/UnrealEngine/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun \
    -clientconfig=Development -serverconfig=Development \
    -project=/tmp/project/PixelStreamingDemo.uproject \
    -utf8output -nodebuginfo -allmaps -noP4 -cook -build -stage -prereqs -pak -archive \
    -archivedirectory=/tmp/project/dist \
    -platform=Linux \
    -Target=PixelStreamingDemo -nocompile -nocompileeditor


# Copy the packaged files into a container image that includes CUDA but doesn't include any Unreal Engine components
FROM --platform=${BUILDPLATFORM:-linux/amd64} ghcr.io/epicgames/unreal-engine:runtime-pixel-streaming
WORKDIR /tmp/project
COPY --from=builder --chown=ue4:ue4 /tmp/project/dist/Linux ./

# Establish ENV
ENV RES_X=1920 \
    RES_Y=1080 \
    SIGNAL_URL=ws://127.0.0.1:8888

# Start pixel streaming
CMD ["/bin/bash", "-c", "./PixelStreamingDemo.sh -PixelStreamingURL=${SIGNAL_URL} -RenderOffscreen -Unattended -ForceRes -ResX=${RES_X} -ResY=${RES_Y} -AllowPixelStreamingCommands ${EXTRA_ARGS}" ]