# RogersBankDownloader

[![CI Status](https://github.com/Nef10/RogersBankDownloader/workflows/CI/badge.svg?event=push)](https://github.com/Nef10/RogersBankDownloader/actions?query=workflow%3A%22CI%22) [![Documentation percentage](https://nef10.github.io/RogersBankDownloader/badge.svg)](https://nef10.github.io/RogersBankDownloader/) [![License: MIT](https://img.shields.io/github/license/Nef10/RogersBankDownloader)](https://github.com/Nef10/RogersBankDownloader/blob/main/LICENSE) [![Latest version](https://img.shields.io/github/v/release/Nef10/RogersBankDownloader?label=SemVer&sort=semver)](https://github.com/Nef10/RogersBankDownloader/releases) ![platforms supported: linux | macOS | iOS | watchOS | tvOS](https://img.shields.io/badge/platform-linux%20%7C%20macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS-blue) ![SPM compatible](https://img.shields.io/badge/SPM-compatible-blue)

## What

This is a small library to download transaction data for Rogers Bank Credit Cards. To authenticate it currently uses requires the `deviceId` and `deviceInfo` from a trusted device to skip the 2FA.

## How

1) Obtain a deviceId with the matching deviceInfo by logging into the website and having a look at the network tab in the developer tools
2) Call `User.load(username: "x", password: "x,", deviceId: "x%7C6d27c0a5956595089e7131a4ee9d7a5d", deviceInfo: "x")`
3) In the completion handler check that the login was successful: `if case let .success(user) = $0 {`
4) `user` now contains the logged in user, which contains the accounts - these already contain info about the current balance, last statement amount, among other information
5) If you want to download the transactions, e.g. call `user.accounts[0].downloadActivities(statementNumber: 0)` - if you have more than one account change the index accordingly - the `statementNumber` parameter indicates which statement period to download the transactions from, with 0 meaning the current period, 1 the last statement and so on.

Please also check out the complete documentation [here](https://nef10.github.io/RogersBankDownloader/).

## Usage

The library supports the Swift Package Manger, so simply add a dependency in your `Package.swift`:

```
.package(url: "https://github.com/Nef10/RogersBankDownloader.git", .exact(from: "0.0.3")),
```

Please note that following semantic versioning every release before version 1.0.0 might be breaking, so use `.exact` for now.

## Limitations

Please note that I developed this library for my own needs. As there is no offical API everything was reverse engineered and there may be a lot of bugs.

Pull requests to fix bugs are otherwise enhance the library are very welcome.

## Copyright

While my code is licensed under the [MIT License](https://github.com/Nef10/RogersBankDownloader/blob/main/LICENSE), the source repository may include names or other trademarks of Rogers, Rogers Bank or other entities; potential usage restrictions for these elements still apply and are not touched by the software license. Same applies for the API design. I am in no way affilliated with Rogers Bank other than beeing customer.
