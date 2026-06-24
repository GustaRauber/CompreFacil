Security checklist and next steps

- [ ] Deploy `firestore.rules` to project (`firebase deploy --only firestore:rules`).
- [ ] Deploy Cloud Function `deleteUserData` (`firebase deploy --only functions`).
- [ ] Run `git rm -r --cached build/` and push commit.
- [ ] Rotate Firebase API keys and apply restrictions (Android package name + SHA-1, iOS bundle id).
- [ ] Enable Firebase App Check and configure provider (Play Integrity / DeviceCheck / reCAPTCHA).
- [ ] Remove unused dependencies (`shared_preferences`, `hive`) or audit their use.
- [ ] Implement email verification and password reset flows in UI.
- [ ] Implement account deletion flow in UI calling `AuthService.deleteAccount()` and confirm user intent.
- [ ] Integrate Crashlytics and error reporting; ensure logs don't contain PII.
- [ ] Add monitoring and alerts for anomalous behavior (sudden spike in reads/writes).
- [ ] Add privacy policy and user data deletion process to the app and product docs.
