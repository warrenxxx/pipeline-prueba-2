FROM stefanscherer/node-windows as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

FROM microsoft/iis
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45


COPY --from=builder /usr/src/app app
RUN ls
RUN cd app; ls

RUN Remove-WebSgite -Name 'Default Web Site'
RUN New-Website -Name 'guidgenerator' -Port 80 -PhysicalPath 'c:\app\dist\ngprueba' -ApplicationPool '.NET v4.5'
EXPOSE 80

CMD ["ping", "-t", "localhost"]
