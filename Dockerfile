# Step 1: Use Node.js official base image
FROM node:16

# Step 2: Set working directory inside container
WORKDIR /app

# Step 3: Copy package.json files first
COPY package*.json ./

# Step 4: Install dependencies
RUN npm install

# Step 5: Copy the rest of your source code
COPY . .

# Step 6: Expose the port Express uses
EXPOSE 8080

# Step 7: Run your app
CMD ["npm", "start"]
