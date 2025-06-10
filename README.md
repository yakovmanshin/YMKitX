# YMKitX

**YMKitX** is a collection of tools which make app development *just a little bit* quicker and easier by taking care of a few specific scenarios.

<details>
<summary>Why “X”</summary>

Back in the day (ca. 2019), I used to have the “YMKit” package for roughly the same purpose. Thanks to the evolution of Swift, those old symbols have mostly become redundant. YMKitX is a “reboot” of the concept—only now the package bundles end-to-end solutions for specific use cases.
</details>

## What’s Included
* **App Validation**: A simple but customizable anti-piracy solution based on app receipts. It may not defeat highly sophisticated tampering attempts, but it’s good enough.
* **Monitoring**: A flexible, modular mechanism for monitoring the app’s state at runtime: reporting errors, logging messages, and tracking user events. It offers customization options and drop-in support for any remote service (e.g. Firebase Analytics, Crashlytics, etc.).
* **Miscellaneous**: Experimental, incubating, or unstable features which don’t belong to any other product (yet).

## Key Features
* **Modular architecture**: Separate package products (libraries) let you import only the components you need.
* **Type safety and static dispatch** (wherever possible): Factory methods (e.g. [`makeAppValidator()`](https://github.com/yakovmanshin/YMKitX/blob/main/AppValidation/src/YMAppValidation.swift)) return opaque-type instances whose underlying types are checked by the compiler at build time.
* **Swift 6 concurrency**: Most components conform to `Sendable` and provide thread safety.
* **Stable, explicit errors** (“typed throws”): Error types such as [`AppReceiptValidatorError`](https://github.com/yakovmanshin/YMKitX/blob/main/AppReceiptValidation/src/public/AppReceiptValidatorError.swift) provide transparency and let you handle errors efficiently, with no type casting or other boilerplate.

## Usage Notes
* The majority of components in this package are covered with tests and supposed to be stable in both their API and behavior. I adhere to [semantic versioning](https://semver.org/) for their further evolution.
* However, it’s important to note that this package is, first and foremost, designed to meet demain of *my own* software projects, so it may not be suitable for every application imaginable.
* Nevertheless, this repo’s content is [open source](https://github.com/yakovmanshin/YMKitX/blob/main/LICENSE) (unless something else is stated in the specific file) so you can repurpose it in many ways.
