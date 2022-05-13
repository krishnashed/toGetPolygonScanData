// migrations/2_deploy.js
const Box3 = artifacts.require("Box3");

module.exports = async function (deployer) {
  await deployer.deploy(Box3);
};
