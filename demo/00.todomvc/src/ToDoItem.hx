import doom.PropertiesComponent;
import doom.Html.*;
using thx.Strings;
import js.html.KeyboardEvent;

class ToDoItem extends PropertiesComponent<ItemController, ItemState> {
  override function render() {
    return LI([
        "class" => [
          "completed" => state.item.completed,
          "editing"   => state.editing,
        ],
        "dblclick" => handleDblClick
      ], [
      DIV(["class" => "view"], [
        INPUT([
          "class"   => "toggle",
          "type"    => "checkbox",
          "checked" => state.item.completed,
          "change"  => handleChecked
        ]),
        LABEL(state.item.label),
        BUTTON([
          "class" => "destroy",
          "click" => handleRemove
        ])
      ]),
      INPUT([
        "class" => "edit",
        "value" => state.item.label,
        "blur"  => handleBlur,
        "keyup" => handleKeydown,
      ])
    ]);
  }

  function handleChecked(el : js.html.InputElement) {
    state.item.completed = el.checked;
    prop.refresh();
  }

  function handleRemove() {
    prop.remove(state.item);
  }

  function handleDblClick() {
    state.editing = true;
    update(state);
    getInput().select();
  }

  function handleBlur() {
    if(!state.editing) return;
    state.editing = false;
    var value = getInputValueAndTrim();
    if(value.isEmpty()) {
      handleRemove();
    } else {
      state.item.label = value;
      prop.save();
      update(state);
    }
  }

  function handleKeydown(e : KeyboardEvent) {
    if(e.which != dots.Keys.ENTER)
      return;
    handleBlur();
  }

  function getInput() : js.html.InputElement
    return cast element.querySelector("input.edit");

  function getInputValueAndTrim() {
    var input = getInput();
    return input.value = input.value.trim();
  }
}

typedef ItemController = {
  public function remove(item : ToDoItemModel) : Void;
  public function refresh() : Void;
  public function save() : Void;
}

typedef ItemState = {
  item : ToDoItemModel,
  editing : Bool
}
