﻿# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY DragonPlume.Api/*.csproj ./DragonPlume.Api/
RUN dotnet restore

# copy everything else and build app
COPY DragonPlume.Api/. ./DragonPlume.Api/
WORKDIR /source/DragonPlume.Api
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "DragonPlume.Api.dll"]