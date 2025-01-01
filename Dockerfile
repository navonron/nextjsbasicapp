# Base image for building the application
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy only the package files to leverage Docker's caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Next.js application
RUN npm run build

# Base image for running the application
FROM node:18 AS runner

# Set NODE_ENV to production
ENV NODE_ENV=production

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Install only production dependencies
RUN npm install --omit=dev

# Expose the application port
EXPOSE 3000

# Command to run the Next.js application
CMD ["npm", "start"]
