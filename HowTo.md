## Deploy to Firebase Hosting through GitHub Actions
1. Run: `npm init -y`  => This will create a package.json file
2. Run: `npm install` => This will create a package-lock.json
3. Run: `npm ci` => This will make sure you have activated continuous integration with a clean installation.
4. Edit the **package.json** file under `scripts` add "build"**:** "flutter build web" 
5. Edit the .yml files in .github/workflows and add this under *steps* at **run** section:
         `sudo snap install flutter --classic && npm ci && npm run build`

## Activate SignIn with Google One Tap without firebase
1. Follow the example from https://github.com/flutter/packages/blob/main/packages/google_sign_in/google_sign_in/example/lib/main.dart and add the `stub.dart` and `web.dart` files with the same structure as the one shown in data_store repository.
2. Get your Google API Client ID by following these instructions here: https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid#one-tap
3. Add the OAuth client ID to the clientId option in GoogleSignIn class.

## Activate SignIn with Google One Tap without firebase
1. Follow the example from https://github.com/flutter/packages/blob/main/packages/google_sign_in/google_sign_in/example/lib/main.dart and add the `stub.dart` and `web.dart` files with the same structure as the one shown in data_store repository.
2. Get your API Client ID from the Web client ID
3. Go to Google APIs page and choose your project, then edit the OAuth URIs to include the portal you want to use in your local host.
4. Add that portal to build configuration in your IDE.