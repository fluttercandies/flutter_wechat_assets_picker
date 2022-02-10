# Contribute custom implementations

This folder allows people to contribute their delegates, use case, or even a brand-new picker.

To add your works, make sure you follow this instruction.

## Ensure that your picker is worth to contribute

People usually have their own apps to build, and the thing like the picker is not always the same between apps.
However, some patterns can be consumed using arguments and fields override, without creating a new picker/delegate.
Please think twice before you confirmed it should be pushed as a new implementation example.

## Contribute steps

1. Fork this project.
2. Create a new branch named `custom-{write-your-implementation-name}`.
3. Create a new picker dart file named `{your_implementation_name}_asset_picker.dart` in the `pickers` folder.
4. Brought all your implementations into the file you've just created.
5. Add a `CustomPickMethod` at the `custom_picker_page.dart` file in `pickMethods`
   in order to build an entrance to your picker.
6. Submit your PR with proper explanations with how your picker works.
