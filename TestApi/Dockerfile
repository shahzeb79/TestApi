FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish --no-restore -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
EXPOSE 80
EXPOSE 443
COPY --from=build-env /app/out .

ENV NGINX=http://nginx:80

ENTRYPOINT ["./TestApi"]