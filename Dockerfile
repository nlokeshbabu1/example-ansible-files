# Use the official Python base image with version 3.9
FROM python:3.9


# Set the working directory within the container
WORKDIR /app


# Copy the requirements file to the container
COPY requirements.txt .


# Install the dependencies
RUN pip install -r requirements.txt


# Copy the application code to the container
COPY . .


# Set the command to run the application
CMD ["python", "app.py"]
