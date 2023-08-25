# NodeJS

Basic of using NodeJS. To make sure everyone will always be able to run the app.

## Project Initialization

1. Create a directory
2. Get inside the directory
3. Create `index.js`
4. `npm init -y` - Remember to do this as it helps everyone, even you!
5. Install needed dependencies `npm i <package name>` or `npm i <package name> --save-dev` for development dependencies
6. At `package.json` under `scripts` add

    ```text
    "start": "node index.js"
    ```

    Example:

    ```text
    ...
    "scripts": {
        ...
        "test": "echo \"Error: no test specified\" && exit 1",
        "start": "node index.js"
        ...
    },
    ...
    ```

7. Test the script `npm start`

> **Note:**
>
> DON'T FORGET `,` after each entry

## Dependencies

### Install guide

#### Standard Dependencies

```bash
npm i <package_name>
```

#### Dev Dependencies

```bash
npm i <package_name> --save-dev
```
