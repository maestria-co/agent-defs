# Style Guide

> **Purpose:** Document UI and CSS conventions for projects with a frontend. Skip this file for backend-only or CLI projects. Update when new design patterns are established or a component library is adopted.

---

## Design System

**Component library:** [e.g., shadcn/ui, Material UI, custom]

**CSS approach:** [e.g., Tailwind CSS, CSS Modules, styled-components]

**Design tokens:** [e.g., CSS custom properties in `src/styles/tokens.css`, Tailwind config]

---

## Color Palette

[PLACEHOLDER — document the project's color tokens]

| Token                 | Value           | Usage                             |
| --------------------- | --------------- | --------------------------------- |
| `--color-primary`     | [e.g., #3B82F6] | Primary actions, links            |
| `--color-error`       | [e.g., #EF4444] | Error states, destructive actions |
| `--color-success`     | [e.g., #10B981] | Success feedback                  |
| `--color-neutral-50`  | [e.g., #F9FAFB] | Page backgrounds                  |
| `--color-neutral-900` | [e.g., #111827] | Primary text                      |

---

## Typography

[PLACEHOLDER — document font families, sizes, and weights]

| Level     | Font          | Size     | Weight | Usage             |
| --------- | ------------- | -------- | ------ | ----------------- |
| Heading 1 | [e.g., Inter] | 2rem     | 700    | Page titles       |
| Heading 2 | [e.g., Inter] | 1.5rem   | 600    | Section headers   |
| Body      | [e.g., Inter] | 1rem     | 400    | Default text      |
| Caption   | [e.g., Inter] | 0.875rem | 400    | Help text, labels |

---

## Spacing System

[PLACEHOLDER — document the spacing scale]

**Convention:** Use the framework's spacing scale (e.g., Tailwind's `p-4`, `gap-6`). Don't use arbitrary pixel values.

---

## Component Patterns

[PLACEHOLDER — document recurring UI patterns]

### Buttons

```
Primary: filled, used for main actions (one per section max)
Secondary: outlined, used for supporting actions
Destructive: red variant, always requires confirmation dialog
```

### Forms

```
Labels: above input, not placeholder text
Validation: inline below field, shown on blur or submit
Required fields: marked with * — never mark optional fields instead
```

### Layout

```
Max content width: [e.g., 1280px]
Page padding: [e.g., px-4 on mobile, px-8 on desktop]
Card spacing: [e.g., gap-6 between cards]
```

---

## Responsive Breakpoints

[PLACEHOLDER — document the breakpoints used]

| Name | Width  | Usage            |
| ---- | ------ | ---------------- |
| `sm` | 640px  | Mobile landscape |
| `md` | 768px  | Tablet           |
| `lg` | 1024px | Desktop          |
| `xl` | 1280px | Wide desktop     |

**Convention:** Mobile-first. Write base styles for mobile, add responsive overrides with min-width media queries.

---

## Accessibility

[PLACEHOLDER — document accessibility requirements]

- **Contrast:** All text meets WCAG AA (4.5:1 for body, 3:1 for large text)
- **Focus indicators:** Visible focus ring on all interactive elements
- **Screen reader:** All images have alt text; decorative images use `alt=""`
- **Keyboard navigation:** All interactive elements reachable via Tab
- **Aria labels:** Required on icon-only buttons and non-standard controls

---

## Never Do

- ❌ **Never use inline styles** — use CSS classes or utility classes
- ❌ **Never hardcode colors** — use design tokens / CSS variables
- ❌ **Never skip focus styles** — visibility is an accessibility requirement
- ❌ **Never nest more than 3 levels of Tailwind variants** — extract a component instead
