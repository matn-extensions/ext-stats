module matn.extension.stats;

import std.algorithm : max, min;
import std.conv : to;
import matn.ui.grid.cell : Color;
import matn.extension.base;

/// Document Statistics & Word Count Extension
class WordCountExtension : Extension
{
    this()
    {
        super(ExtensionManifest(
            "matn.stats",
            "Document Statistics",
            "1.0.0",
            "Matn Core",
            "Document word count, character count, and estimated reading time",
            true
        ));
        this._enabled = true;
    }

    override protected void onActivate()
    {
        if (_context)
        {
            _context.registerSetting("EDITOR", "Document Statistics", "Word count and reading time in status bar", {
                _enabled = !_enabled;
            });
        }
    }

    /// Calculate document statistics string from lines
    string getStatsString(const(dchar[][]) lines)
    {
        if (!_enabled || lines.length == 0) return "";

        size_t wordCount = 0;
        size_t charCount = 0;

        foreach (line; lines)
        {
            charCount += line.length;
            bool inWord = false;
            foreach (c; line)
            {
                if (c != ' ' && c != '\t' && c != '\r' && c != '\n')
                {
                    if (!inWord)
                    {
                        inWord = true;
                        wordCount++;
                    }
                }
                else
                {
                    inWord = false;
                }
            }
        }

        // Approx 200 words per minute reading speed
        int readMinutes = max(1, cast(int)((wordCount + 199) / 200));

        return to!string(wordCount) ~ " words, " ~ to!string(readMinutes) ~ "m read";
    }
}
