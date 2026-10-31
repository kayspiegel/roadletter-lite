import { Controller } from "@hotwired/stimulus"

// Closes the account menu on a click or tap outside it, and on Escape.
export default class extends Controller {
  static targets = [ "trigger" ]

  closeOnOutsideClick(event) {
    if (this.element.open && !this.element.contains(event.target)) {
      this.element.open = false
    }
  }

  closeOnEscape() {
    if (this.element.open) {
      this.element.open = false
      this.triggerTarget.focus()
    }
  }
}
