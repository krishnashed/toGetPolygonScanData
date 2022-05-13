// migrations/2_deploy.js
const Akhil = artifacts.require("Akhil");

module.exports = async function (deployer) {
  await deployer.deploy(Akhil);
};
