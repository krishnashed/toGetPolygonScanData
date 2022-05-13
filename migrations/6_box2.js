// migrations/2_deploy.js
const Box2 = artifacts.require("Box2");

module.exports = async function (deployer) {
  await deployer.deploy(Box2);
};
