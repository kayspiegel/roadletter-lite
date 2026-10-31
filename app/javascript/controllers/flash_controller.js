import { Controller } from "@hotwired/stimulus"

// Removes a flash message when its dismiss button is clicked.
export default class extends Controller {
  dismiss() {
    this.element.remove()
  }
}
