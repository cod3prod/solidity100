const { Web3 } = require("web3");
require("dotenv").config();
const web3 = new Web3(process.env.PROVIDER);
const { pools, ERC20_ABI } = require("./data");

// 가격 계산 함수
async function getPriceFromPool(pool) {
  const [weth, usdt] = pool.tokenPair;
  const wethContract = new web3.eth.Contract(ERC20_ABI, weth);
  const usdtContract = new web3.eth.Contract(ERC20_ABI, usdt);

  try {
    const balanceOfWETH = await wethContract.methods
      .balanceOf(pool.address)
      .call();
    const balanceOfUSDT = await usdtContract.methods
      .balanceOf(pool.address)
      .call();

    const decimalsWETH = await wethContract.methods.decimals().call();
    const decimalsUSDT = await usdtContract.methods.decimals().call();

    const adjustedBalanceOfWETH =
      BigInt(balanceOfWETH) / BigInt(10) ** BigInt(decimalsWETH);
    const adjustedBalanceOfUSDT =
      BigInt(balanceOfUSDT) / BigInt(10) ** BigInt(decimalsUSDT);

    // ETH 가격 계산
    const price = Number(adjustedBalanceOfUSDT) / Number(adjustedBalanceOfWETH);
    console.log(`${pool.name}: 1 WETH = ${price.toFixed(2)} USDT`);
    return price;
  } catch (error) {
    console.error(`Error fetching price from ${pool.name}:`, error.message);
    return null;
  }
}

async function calculateETHPrice() {
  const prices = [];

  for (const pool of pools) {
    const price = await getPriceFromPool(pool);
    if (price) prices.push(price);
  }

  if (prices.length > 0) {
    const averagePrice =
      prices.reduce((acc, price) => acc + price, 0) / prices.length;
    console.log(`\nAverage ETH Price: ${averagePrice.toFixed(2)} USDT`);
  } else {
    console.log("Failed to fetch prices from all pools.");
  }
}

calculateETHPrice();
