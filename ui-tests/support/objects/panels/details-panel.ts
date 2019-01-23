import { browser, element, by, ElementFinder } from 'protractor';
import { Panel } from './panel';


export class DetailsPanel extends Panel {
  private data = {
    rows: {
      root: by.css('.order-detail,.history-detail-row'),
      title: by.css('.order-detail__title'),
      value: by.css('.order-detail__value'),
      marketName: by.css('.order-detail__market-name,.history-detail-header')
    }
  };

  constructor(panelRoot: ElementFinder) {
    super(panelRoot);
    this.name = 'Details';
  }

  async getMarketName() {
    const el = await this.container.element(this.data.rows.marketName).waitReady(2000);

    return (await el.getText()).trim();
  }

  getRowsCount() {
    return this.container.all(this.data.rows.root).count();
  }

  getRow(nameOrNumber) {
    nameOrNumber = nameOrNumber.toLowerCase();
    const self = this;
    let row;
    if (parseInt(nameOrNumber)) {
      row = this.container.all(this.data.rows.root).get(nameOrNumber);
    } else {
      row = this.container.all(this.data.rows.root).filter((currentRow) => {
        return currentRow.getText()
          .then((text) => {
            return text.toLowerCase().trim().includes(nameOrNumber);
          });
      }).first();
    }

    return {

      async getHistoryValue() {
        let text = await row.getText();
        if (process.env.npm_config_browser.includes('safari')) {
          text = text.split('  ')[1].trim();
        } else {
          text = text.split('\n')[1].trim();
        }

        return text;
      },

      async getValue() {
        // await row.waitReady(2000);

        return (await row.element(self.data.rows.value).getText()).trim();
      },

      async clickOnValue() {
        await row.waitReady(2000);

        return row.element(self.data.rows.value).element(by.tagName('span')).click();
      }
    };
  }
}
