import { DirectionTypeEnum } from '../enums/direction-type.enum';


const getDecimalUnits = (price: number): number => {
  return parseFloat(`0.${(`${price} `).split('.')[1]}`);
};

export function calculatePLFromPrice(
  orderPrice: number,
  tradePrice: number,
  pfd: number,
  betPer: number,
  quantity: number,
  qcf: number,
  trailingStopConversionFactor: number,
  direction: string,
  orderType: string
): number {
  const intOrderPrice = Math.trunc(orderPrice);
  const intTradePrice = Math.trunc(tradePrice);

  let pointsMultiplier = 1;
  let plMultiplier = 1;

  if (direction === DirectionTypeEnum.Buy) {
    if (orderType.indexOf('limit') !== -1) {
      plMultiplier = -1;
    } else {
      pointsMultiplier = -1;
    }
  } else {
    if (orderType.indexOf('limit') !== -1) {
      pointsMultiplier = -1;
      plMultiplier = -1;
    }
  }

  // tslint:disable-next-line:max-line-length
  const result = ((((orderPrice - intOrderPrice) / pfd * 100)
    + intOrderPrice - (((tradePrice - intTradePrice) / pfd * 100) + intTradePrice))
    / 100 * pfd / betPer / trailingStopConversionFactor)
    * (-quantity) / qcf * trailingStopConversionFactor;

  return result * pointsMultiplier * plMultiplier;
}

export function calculatePointsFromPrice(
  orderPrice: number,
  tradePrice: number,
  pfd: number,
  betPer: number,
  trailingStopConversionFactor: number,
  direction: string,
  orderType: string,
): number {
  const intOrderPrice = Math.trunc(orderPrice);
  const intTradePrice = Math.trunc(tradePrice);

  let multiplier = 1;

  if (orderType.indexOf('limit') !== -1) {
    if (direction === DirectionTypeEnum.Sell) {
      multiplier = -1;
    } else if (direction === DirectionTypeEnum.Buy) {
      multiplier = 1;
    }
  } else if (orderType.indexOf('stop') !== -1) {
    if (direction === DirectionTypeEnum.Sell) {
      multiplier = 1;
    } else if (direction === DirectionTypeEnum.Buy) {
      multiplier = -1;
    }
  }

  // tslint:disable-next-line:max-line-length
  return multiplier
    * (((orderPrice - intOrderPrice) / pfd * 100)
    + intOrderPrice - (((tradePrice - intTradePrice) / pfd * 100) + intTradePrice))
    / 100 * pfd / betPer / trailingStopConversionFactor;
}

export function calculatePriceFromPoints(
  currentPrice: number,
  pfd: number,
  points: number,
  betPer: number,
  trailingStopConversionFactor: number,
  orderType: string,
  direction: string
): number {
  let orderTypeMultiplier = 1;

  if (orderType.indexOf('limit') !== -1) {
    if (direction === DirectionTypeEnum.Sell) {
      orderTypeMultiplier = 1;
    } else if (direction === DirectionTypeEnum.Buy) {
      orderTypeMultiplier = -1;
    }
  } else if (orderType.indexOf('stop') !== -1) {
    if (direction === DirectionTypeEnum.Sell) {
      orderTypeMultiplier = -1;
    } else if (direction === DirectionTypeEnum.Buy) {
      orderTypeMultiplier = 1;
    }
  }

  const rightHandSide = (getDecimalUnits(currentPrice) * 100) / pfd;
  const pointsAsDecimal = orderTypeMultiplier * Math.round(points) * betPer * trailingStopConversionFactor * 100 / pfd;
  const differenceAsPercentageOfMajorUnit = rightHandSide - pointsAsDecimal;
  const newPriceWithMinorDecimalUnits = Math.trunc(currentPrice) + differenceAsPercentageOfMajorUnit;

  return (Math.trunc(newPriceWithMinorDecimalUnits)
    + (newPriceWithMinorDecimalUnits - Math.trunc(newPriceWithMinorDecimalUnits)) * pfd * 0.01);
}

export function calculatePointsFromPL(
  profitLoss: number,
  quantity: number,
  qcf: number,
  trailingStopConversionFactor: number,
  orderType: string,
  direction: string
): number {
  if (quantity === 0) {
    return null;
  }

  let multiplier = 1;
  let directionMultiplier = 1;

  if (direction === DirectionTypeEnum.Buy) {
    directionMultiplier = -1;
    if (orderType.indexOf('limit') !== -1) {
      multiplier = -1;
    }
  } else {
    if (orderType.indexOf('stop') !== -1) {
      multiplier = -1;
    }
  }

  return  directionMultiplier * multiplier * (profitLoss / quantity * qcf / trailingStopConversionFactor);
}

export function roundValue(priceValue: number, roundingPrecision: number): number {
  return Number(priceValue.toFixed(roundingPrecision));
}

export function getFloatingPart(floatingNumber: number): number {
  return floatingNumber - Math.trunc(floatingNumber);
}
