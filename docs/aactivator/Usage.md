## [aactivator.py](../../scripts/aactivator.py)

### Usage
The aactivator.py script simplifies the activation and deactivation of environments in an interactive shell. Follow these steps to use it in your project:

### Example Usage
Create an activation script (.activate.sh) in your project, which activates your environment. For example, in a Python project:

```bash
ln -vs venv/bin/activate .activate.sh
```

2. Create a deactivation script (.deactivate.sh) in your project, which deactivates your environment. For example:

```bash
echo deactivate > .deactivate.sh
```
3. In your Python project, if an environment is already active, it will not be re-activated. If a different project is activated, the previous project will be deactivated beforehand.

4. Run the following command in your shell to initialize aactivator:
```bash
eval "$(aactivator init)"
```
Now, whenever you navigate to your project directory, aactivator will ask before automatically sourcing environments. It will remember your preference for each project.


