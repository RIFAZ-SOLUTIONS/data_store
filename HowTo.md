## Deploy to Firebase Hosting through GitHub Actions
1. Run: `npm init -y`  => This will create a package.json file
2. Run: `npm install` => This will create a package-lock.json
3. Run: `npm ci` => This will make sure you have activated continuous integration with a clean installation.
4. Edit the **package.json** file under `scripts` add "build"**:** "flutter build web" 
5. Edit the .yml files in .github/workflows and add this under *steps* at **run** section:
         `sudo snap install flutter --classic && npm ci && npm run build`