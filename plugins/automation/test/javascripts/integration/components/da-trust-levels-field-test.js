import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { module, test } from "qunit";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import selectKit from "discourse/tests/helpers/select-kit-helper";
import fabricators from "discourse/plugins/automation/discourse/lib/fabricators";

module("Integration | Component | da-trust-levels-field", function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    this.automation = fabricators.automation();
  });

  test("set value", async function (assert) {
    this.field = fabricators.field({
      component: "trust-levels",
    });

    await render(
      hbs`<AutomationField @automation={{this.automation}} @field={{this.field}} />`
    );

    await selectKit().expand();
    await selectKit().selectRowByValue(1);
    await selectKit().selectRowByValue(2);

    assert.deepEqual(this.field.metadata.value, [1, 2]);
  });
});
