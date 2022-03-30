# Template action for running matlab scripts

This action runs an example matlab script.

## Using the template

Setting up a new matlab script action includes:

* Copying the entire template into the new repository
* Modify [matlab script](script/)
  * Add everything necessary for your matlab script
  * Keep the `main.m` file as the entrypoint to your script
* Modify [options](src/options.ts)
  * Define the options in the [action definition](action.yml)
  * Set all necessary options in the `Options` interface
  * Define the parameter conversion from github actions to actual value types - `create` function
* Modify [tests](src/script.unit.test.ts)
  * Test the proper parameter string representation and setup

### Credits

Original idea and GitHub Actions by: https://github.com/matlab-actions/run-command

## Issues

The runners for github actions don't have an internet connection which causes a problem with running `npm`/`yarn` commands.

## Using the example action

```yaml
jobs:
  example:
    name: example
    runs-on: self-hosted
    steps:
      - uses: MBSD-SDK/JavaScript-Action-Template@v0
        with:
            example_string: "example"
            example_num: "10"
```


