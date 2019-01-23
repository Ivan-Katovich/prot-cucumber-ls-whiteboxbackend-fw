import { CurrencyDecimalDigitsEnum } from '../enums/currency-decimal-digits.enum';
import { ISOCurrencyEnum } from '../enums/iso-currency.enum';
import * as _ from 'lodash';

export function convert(
  value: number,
  fromCurrencyId: number,
  toCurencyId: number,
  direction,
  rates
): { value: number, isConverted: boolean } {

  if (!rates
    || !Object.keys(rates).length
    || fromCurrencyId === toCurencyId
  ) {
    return { value, isConverted: false };
  }

  let convertedValue: number = value;

  const directConversion = rates[fromCurrencyId][toCurencyId];

  if (!directConversion || directConversion[direction] === null) {

    const availableConversion = Object.keys(rates[fromCurrencyId]).find(key => rates[key][toCurencyId]);

    if (!availableConversion) {
      return { value, isConverted: false };
    }

    const fromRate = rates[fromCurrencyId][availableConversion];
    const toRate = rates[availableConversion][toCurencyId];

    if (fromRate[direction] === null || toRate[direction] === null) {
      return { value, isConverted: false };
    }

    convertedValue = value * fromRate[direction] * toRate[direction];
  } else {
    convertedValue = value * directConversion[direction];
  }

  return {
    value: isFinite(convertedValue)
      ? _.round(convertedValue, +CurrencyDecimalDigitsEnum[ISOCurrencyEnum[toCurencyId]])
      : null,
    isConverted: true
  };
}

export function convertRates(rates): { [currencyId: string]: { bid: number, offer: number }} {
  if (!rates) {
    return {};
  }

  const ratesObject = {};
  rates.forEach(rate => {
    ratesObject[rate.ToCurrencyId] = ratesObject[rate.ToCurrencyId] || {};
    ratesObject[rate.ToCurrencyId][rate.FromCurrencyId] = {
      sell: 1 / rate.Offer,
      buy: 1 / rate.Bid
    };

    ratesObject[rate.FromCurrencyId] = ratesObject[rate.FromCurrencyId] || {};
    ratesObject[rate.FromCurrencyId][rate.ToCurrencyId] = {
      sell: rate.Offer,
      buy: rate.Bid
    };
  });

  return ratesObject;
}
