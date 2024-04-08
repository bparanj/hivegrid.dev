import { writeFile, chmod } from "fs/promises";
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";

// Access environment variables
const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;
const rorSecretKey = process.env.ROR_SECRET_KEY;
const region = process.env.AWS_REGION || "us-west-2"; // Use 'us-west-2' if AWS_REGION is not set

// Copy the value of ror_key_secret_name from the output of the terraform apply.
// Set ROR_SECRET_KEY environment variable to your value, something like this: "ror_key_secret-12345"
const secret_name = rorSecretKey;

// Configure the AWS Secrets Manager client
const client = new SecretsManagerClient({
  region: region,
  credentials: {
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey,
  },
});

async function getSecret() {
  try {
    const response = await client.send(
      new GetSecretValueCommand({
        SecretId: secret_name,
      }),
    );
    const secret = response.SecretString;

    // Save the secret to a file
    const filePath = "./rails-server.pem";
    await writeFile(filePath, secret);
    console.log("Secret saved to rails-server.pem");

    // Change file permissions to 400
    await chmod(filePath, 0o400);
    console.log("File permissions changed to 400");

    console.log("Permissions changed to 400 for rails-server.pem");
    console.log("You can now ssh into the server using the command:");
    console.log("ssh -i rails-server.pem -p 2222 ubuntu@your-ip-address");
  } catch (error) {
    console.error("Error:", error);
  }
}

getSecret();
