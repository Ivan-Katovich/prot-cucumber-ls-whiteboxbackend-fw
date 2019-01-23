import { browser, element, by, ElementFinder } from 'protractor';


export class LoginPage {
  private data = {
    username: by.css('#login-username,[ng-model="loginData.username"]'),
    password: by.css('#login-password,#c-password'),
    submit: by.css('#login-submit,.button--webtrader')
  };

  get userNameField(): ElementFinder {
    return element(this.data.username);
  }

  get passwordField(): ElementFinder {
    return element(this.data.password);
  }

  get submitBtn(): ElementFinder {
    return element(this.data.submit);
  }

  async signIn(login: string, password: string): Promise<void> {
    await this.userNameField.waitReady(5000);
    await this.userNameField.sendKeys(login);
    await this.passwordField.sendKeys(password);
    await this.submitBtn.click();
  }
}
