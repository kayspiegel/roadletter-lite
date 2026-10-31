# Inline SVG icons from Lucide (https://lucide.dev, ISC licence), so no icon
# font or script loads from another host.
module IconHelper
  ICONS = {
    "circle-alert" => '<circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/>',
    "circle-check" => '<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>',
    "log-out" => '<path d="m16 17 5-5-5-5"/><path d="M21 12H9"/><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>',
    "x" => '<path d="M18 6 6 18"/><path d="m6 6 12 12"/>'
  }.transform_values(&:html_safe).freeze

  def icon_tag(name, **options)
    tag.svg ICONS.fetch(name), viewBox: "0 0 24 24", fill: "none", stroke: "currentColor",
      "stroke-width": 2, "stroke-linecap": "round", "stroke-linejoin": "round", aria: { hidden: true }, **options
  end
end
