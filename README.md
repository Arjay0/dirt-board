# Dirt Watch (the shared page)

One web page that grades each riding area DUST / PRIME / MUD / SNOW for
today and the next six days, with the forecast temperature, chance of rain
and wind under each day. It shows CLOSED when a rider or the agency's own
status page says so. Built 2026-11-13 from the brain's `dirtwatch.py`.

Live: https://arjay0.github.io/dirt-board/
Report form: https://forms.gle/L8JPDRRZmeyDKZnUA

A day with a 50% or higher chance of rain is never graded DUST (drizzle on
dry ground rides like prime). Clear Creek is never shown as closed.

There is no server. Every time someone opens the page, their browser reads
the rain history and the forecast and does the math. Ride reports and
closure reports come from a Google Form; the page reads the form's answer
sheet.

Preview with sample reports: open `index.html?demo`.

## 1. Make the Google Form (about 5 minutes)

Create a form called "Dirt Watch ride report" with these six questions.
The question titles matter: the page finds its columns by these words.

| # | Title | Type | Required | Choices / help text |
|---|---|---|---|---|
| 1 | Where | Dropdown | yes | Carnegie, Hollister Hills, Metcalf, Stonyford, Penny Pines, Foresthill, Downieville, Pozo, Clear Creek, Jawbone (spelled exactly like this) |
| 2 | How was the dirt? | Multiple choice | yes | Prime (tacky, hero dirt) / Dust (dry and loose) / Mud (too wet) / Snow / Closed (signs, event, gate) |
| 3 | Date | Date | yes | Help: "The day you rode, or the first day it is closed." |
| 4 | Closed through | Date | no | Help: "Only for a closure with a known end, like an event weekend." |
| 5 | Your name | Short answer | no | |
| 6 | Notes | Short answer | no | |

In the form's Settings: do NOT collect email addresses, and do not require
sign-in.

## 2. Publish the answers

1. In the form: Responses > Link to Sheets (creates the answer sheet).
2. In that sheet: Share > General access > "Anyone with the link",
   role Viewer. Copy the link and change its ending from `/edit...` to
   `/export?format=csv`.
3. In the form: Send > the link icon. Copy that link too.

## 3. Put the two links in the page

Near the top of the script in `index.html`:

    const FORM_URL = "";        // the form link
    const SHEET_CSV_URL = "";   // the sheet's CSV export link

Both are filled in on the live page. With either one blank, the page shows
grades only (no report button, no reports).

## 4. Host it

GitHub Pages: push this folder to a public repo, then in the repo's
Settings > Pages choose "Deploy from a branch", branch `main`, folder `/`.
The address is `https://<user>.github.io/<repo>/`.

## Closures and events (status.json)

`status.json` in this repo is rewritten about once an hour by Roger's home
server (the brain's `dirt_publish.py`, through a deploy key that can only
write to this repo). It carries, per area: closure and event notes (from
the agencies' own status pages, a twice-weekly web search, and Roger's own
reports), the days to show as CLOSED, and the tuned grade edges. The page
shows when it was last checked and says so when it is more than 30 hours
old. Do not edit the file by hand; it is overwritten.

## How reports are used

- Dust / Prime / Mud reports from the last 120 days move that area's
  grade edges (same rule as the brain).
- A Closed report flags the area CLOSED from its date through "Closed
  through", or for 14 days if that is blank. A later ride report for the
  same area ends it early. A closure may be dated in the future (an event
  next weekend); ride reports may not.
- Anything the page does not recognise (unknown area, unknown answer, bad
  date) is ignored. Names and notes are shown as plain text, cut to 30 and
  160 characters.
- Everything in the answer sheet is public: anyone with the link can read it.

## Adding an area

Add a line to `AREAS` in `index.html` (name, lat, lon, soil, top elevation,
forecast grid) and the same name to the form's dropdown. The forecast grid
comes from `https://api.weather.gov/points/<lat>,<lon>` (the end of
`forecastGridData`). Keep the brain's `domains/dirtbike/dirt-watch.yaml` in
step so the Telegram board matches.

## Checking it

`./shot.sh` (or `./shot.sh '?demo'`) loads the page in headless Chrome with
live data, prints every area's grades, and saves `phone.png`.
