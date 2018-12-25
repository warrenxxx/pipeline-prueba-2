FROM stefanscherer/node-windows
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

FROM microsoft/iis
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45

COPY --from=node /usr/src/app/dist/ngprueba c:/GuidGenerator

COPY GuidGenerator GuidGenerator
RUN Remove-WebSite -Name 'Default Web Site'
RUN New-Website -Name 'guidgenerator' -Port 80 \
    -PhysicalPath 'c:\GuidGenerator' -ApplicationPool '.NET v4.5'
EXPOSE 80

CMD ["ping", "-t", "localhost"]
