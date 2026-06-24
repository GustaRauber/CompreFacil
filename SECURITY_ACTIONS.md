Security remediation actions and commands

1. Remove build artifacts from git (run locally):

```bash
git rm -r --cached build/
git commit -m "chore: remove build artifacts from repository"
git push
```

2. Remove any accidentally committed secrets from git history (DEStructive):

- Use `git filter-repo` or `git filter-branch` or `BFG Repo-Cleaner` to remove secrets.
- After rewrite, rotate API keys in Google Cloud Console.

Example (BFG):

```bash
bfg --delete-files build
# or to remove a specific API key string
bfg --replace-text replacements.txt
```

3. Deploy Firestore rules and Cloud Functions:

```bash
# From project root
npm --version # ensure npm installed
cd functions
npm install
cd ..
firebase deploy --only firestore:rules,functions
```

4. Rotate Firebase API keys and enable App Check + API restrictions in Google Cloud Console.
