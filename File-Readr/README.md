# File-Readr
File Reader is a command line tool that allows you to get some data from a file.

[![Build Status](https://travis-ci.org/marsal-silveira/File-Readr.svg?branch=master)](https://travis-ci.org/marsal-silveira/File-Readr)

## Requirements

- JDK 8+
- Maven

## Setup
 
### Cloning

1. On GitHub, navigate to the main page of the repository.

2. Under the repository name, click **Clone or download**.

3. In the Clone with HTTPs section, click under copy icon to copy the clone URL for the repository.

4. Open Terminal.

5. Change the current working directory to the location where you want the cloned directory to be made.

6. Type `git clone`, and then paste the URL you copied in Step 2.

```
$ git clone https://github.com/marsal-silveira/File-Readr.git
```

7. Press **Enter**. Your local clone will be created.

**or**

### Downloading

1. On GitHub, navigate to the main page of the repository.

2. Under the repository name, click **Clone or download**.

3. In the Clone with HTTPs section, click under `Download Zip` button to download it.

**or**

Download the [latest code version](https://github.com/marsal-silveira/File-Readr/archive/master.zip) and extract it into workspace.

## Usage

Open Terminal app (or equivalent) and navigate to `File-Readr` project directory.

### Run Tests

At `File-Readr` root folder run: 

```
$ mvn clean test
```

### Run Application

At `File-Readr` root folder run:

```
$ mvn clean package
```

This will generate `file-readr-1.0.0.jar` at `target` folder.

Check if jar file is there and run:

```
$ java -jar target/file-readr-1.0.0.jar
```

Note: To access the default file `resources/cidades.csv` this command must be executed at `File-Readr` root folder.
### Using IDE

This project can be imported as a `Maven Project` in any IDE that support this format.
     

## License

[File-Readr](https://github.com/marsal-silveira/File-Readr) are created by [Marsal Silveira](https://github.com/marsal-silveira) and released under a [MIT License](License).