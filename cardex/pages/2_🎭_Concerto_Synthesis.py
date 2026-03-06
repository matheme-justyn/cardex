"""Concerto Synthesis Page - Generate synthesis documents from analysis cards.

This page allows users to:
1. Select source paradigm
2. Browse and select analysis cards
3. Choose concerto (output style)
4. Generate synthesis document
"""

import streamlit as st
from pathlib import Path
import sys
from datetime import datetime

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from cardex.paradigm import ParadigmLoader, ConcertoLoader
from cardex.database import CardexDatabase
from cardex.config import CardexConfig


def main():
    """Main function for Concerto Synthesis page."""

    # Initialize
    config = CardexConfig()
    paradigm_loader = ParadigmLoader()
    concerto_loader = ConcertoLoader()
    db = CardexDatabase()

    # Load i18n
    if "locale" not in st.session_state:
        st.session_state.locale = config.get("i18n.locale", "zh-TW")

    # Page config
    st.set_page_config(page_title="Concerto Synthesis - Cardex", page_icon="🎭", layout="wide")

    # Title
    st.title("🎭 Concerto Synthesis")
    st.caption("Compose your findings for the target audience")

    st.divider()

    # Step 1: Select Source Paradigm
    st.header("🎼 Step 1: Select Source Paradigm")

    paradigms = paradigm_loader.list_paradigms()

    if not paradigms:
        st.warning("⚠️ No paradigms found. Please create a paradigm first.")
        st.stop()

    # Pre-select paradigm if coming from Page 1
    default_index = 0
    if "selected_paradigm" in st.session_state:
        paradigm_id = st.session_state.selected_paradigm.get("id")
        for i, p in enumerate(paradigms):
            if p["id"] == paradigm_id:
                default_index = i
                break

    # Paradigm selector
    paradigm_options = [f"{p['name']} ({p['type']})" for p in paradigms]

    selected_index = st.selectbox(
        "Select paradigm",
        range(len(paradigm_options)),
        format_func=lambda i: paradigm_options[i],
        index=default_index,
        key="synthesis_paradigm_selector",
    )

    selected_paradigm = paradigms[selected_index]

    # Get analysis cards count
    analyses = db.get_analyses_by_paradigm(selected_paradigm["id"])

    col1, col2 = st.columns([2, 1])
    with col1:
        st.info(f"📊 Available Analysis Cards: {len(analyses)} cards")
    with col2:
        if analyses:
            latest = max([a["created_at"] for a in analyses])
            st.caption(f"Last analyzed: {latest[:10]}")

    st.divider()

    # Step 2: Select Analysis Cards
    st.header("📇 Step 2: Select Analysis Cards")

    if len(analyses) == 0:
        st.warning("⚠️ No analysis cards found for this paradigm.")
        st.info("Generate analysis cards first using the Paradigm Analysis page.")
        if st.button("← Go to Paradigm Analysis"):
            st.switch_page("pages/1_🎼_Paradigm_Analysis.py")
        st.stop()

    # Filters
    st.subheader("Filter Cards")

    col1, col2, col3 = st.columns(3)

    with col1:
        # Lens filter
        all_lenses = list(set([a["lens_name"] for a in analyses]))
        selected_lenses = st.multiselect(
            "Lenses", all_lenses, default=all_lenses, key="card_lens_filter"
        )

    with col2:
        # Date range filter
        date_range = st.selectbox(
            "Date Range",
            ["Last 7 days", "Last 30 days", "Last 3 months", "All time"],
            index=1,
            key="card_date_filter",
        )

    with col3:
        # Paper filter
        search_query = st.text_input(
            "Search Papers", placeholder="Filter by paper title...", key="card_search"
        )

    # Filter analyses
    filtered_analyses = [a for a in analyses if a["lens_name"] in selected_lenses]

    if search_query:
        filtered_analyses = [
            a for a in filtered_analyses if search_query.lower() in a["paper_id"].lower()
        ]

    st.caption(f"Showing {len(filtered_analyses)} of {len(analyses)} cards")

    # Card selection
    if "selected_cards" not in st.session_state:
        # If coming from Page 1, pre-select recently generated cards
        if st.session_state.get("generation_complete", False):
            st.session_state.selected_cards = [a["id"] for a in filtered_analyses[:5]]
        else:
            st.session_state.selected_cards = []

    # Select all checkbox
    select_all = st.checkbox(f"Select All ({len(filtered_analyses)} cards)", key="select_all_cards")

    if select_all:
        st.session_state.selected_cards = [a["id"] for a in filtered_analyses]

    # Card list
    for analysis in filtered_analyses[:10]:  # Show first 10
        card_id = analysis["id"]
        checked = card_id in st.session_state.selected_cards

        col1, col2 = st.columns([3, 1])

        with col1:
            if st.checkbox(
                f"[{analysis['paper_id']}] - {analysis['lens_name']}",
                value=checked,
                key=f"card_{card_id}",
            ):
                if card_id not in st.session_state.selected_cards:
                    st.session_state.selected_cards.append(card_id)
            else:
                if card_id in st.session_state.selected_cards:
                    st.session_state.selected_cards.remove(card_id)

            st.caption(
                f"🔬 {analysis['lens_name']} · 📅 {analysis['created_at'][:10]} · {analysis['word_count']} words"
            )

            # Show preview (first 100 chars)
            preview = (
                analysis["content"][:100] + "..."
                if len(analysis["content"]) > 100
                else analysis["content"]
            )
            st.caption(f'"{preview}"')

        with col2:
            with st.expander("Preview"):
                st.markdown(
                    analysis["content"][:500] + "..."
                    if len(analysis["content"]) > 500
                    else analysis["content"]
                )

    if len(filtered_analyses) > 10:
        st.caption(f"... and {len(filtered_analyses) - 10} more cards")

    selected_count = len(st.session_state.selected_cards)
    st.success(f"✅ Selected: {selected_count} cards")

    st.divider()

    # Step 3: Choose Concerto
    st.header("🎻 Step 3: Choose Concerto")

    concerti = concerto_loader.list_concerti()

    if not concerti:
        st.warning("⚠️ No concerti found.")
        st.info("Place your `.concerto` files in `~/.cardex/concerti/`")
        st.code(
            """
# Example: Use example concerto
cp concerti/example.concerto ~/.cardex/concerti/journal_submission.concerto
        """,
            language="bash",
        )
        st.stop()

    # Concerto selector
    concerto_options = [c["name"] for c in concerti]

    selected_concerto_index = st.selectbox(
        "Select concerto",
        range(len(concerto_options)),
        format_func=lambda i: concerto_options[i],
        key="concerto_selector",
    )

    selected_concerto = concerti[selected_concerto_index]
    concerto_config = concerto_loader.load_concerto(selected_concerto["file_path"])

    # Display concerto details
    with st.expander("🎭 Concerto Details", expanded=False):
        col1, col2, col3 = st.columns(3)
        with col1:
            st.metric("Type", selected_concerto["type"])
        with col2:
            st.metric("Audience", selected_concerto["audience"])
        with col3:
            length_info = selected_concerto.get("length", {})
            if isinstance(length_info, dict):
                target = length_info.get("target", "N/A")
                st.metric("Target Length", f"{target} words" if target != "N/A" else target)

        st.write(f"**Tone:** {selected_concerto['tone']}")

        if concerto_config and "orchestra" in concerto_config:
            orchestra = concerto_config["orchestra"]
            if "structure" in orchestra:
                st.write("**Structure:**")
                for item in orchestra["structure"]:
                    st.write(f"- {item}")

    st.divider()

    # Step 4: Synthesis Summary & Generate
    st.header("📊 Synthesis Summary")

    cards_count = selected_count
    estimated_length = (
        selected_concerto.get("length", {}).get("target", 8000)
        if isinstance(selected_concerto.get("length"), dict)
        else 8000
    )
    estimated_time = cards_count * 30 + 120  # 30s per card + 2min synthesis

    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric("Cards", cards_count)
    with col2:
        st.metric("Paradigm", selected_paradigm["name"])
    with col3:
        st.metric("Expected Length", f"~{estimated_length} words")
    with col4:
        minutes = estimated_time // 60
        seconds = estimated_time % 60
        st.metric("Estimated Time", f"~{minutes}m {seconds}s")

    # Output path
    output_filename = f"{selected_paradigm['name'].lower().replace(' ', '_')}_{selected_concerto['id']}_{datetime.now().strftime('%Y-%m')}.md"
    output_path = st.text_input(
        "Output Path", value=f"synthesis/{output_filename}", key="output_path"
    )

    st.caption(f"💡 Output will be saved to: `~/.cardex/{output_path}`")

    st.divider()

    # Generate button
    can_generate = cards_count > 0

    if st.button(
        "🎭 Generate Synthesis Document",
        type="primary",
        disabled=not can_generate,
        use_container_width=True,
    ):
        st.session_state.synthesis_started = True

    # Synthesis process (mock)
    if st.session_state.get("synthesis_started", False):
        with st.spinner("Synthesizing document..."):
            import time

            progress_bar = st.progress(0)
            status_text = st.empty()

            stages = [
                "Loading analysis cards",
                "Applying concerto template",
                "Organizing thematic sections",
                "Generating abstract and introduction",
                "Formatting bibliography",
            ]

            for i, stage in enumerate(stages):
                progress = (i + 1) / len(stages)
                progress_bar.progress(progress)
                status_text.text(f"Stage {i + 1}/{len(stages)}: {stage}...")
                time.sleep(1)

            st.session_state.synthesis_started = False
            st.session_state.synthesis_complete = True

        # Success message
        st.success("✅ Synthesis Complete!")

        st.info(f"""
**Output:** `~/.cardex/{output_path}`

**Statistics:**
- Total words: ~{estimated_length}
- Citations: {cards_count} cards synthesized
- Paradigm: {selected_paradigm["name"]}
- Concerto: {selected_concerto["name"]}
        """)

        col1, col2, col3 = st.columns(3)
        with col1:
            if st.button("📄 Open Document", use_container_width=True):
                st.info("Document viewing will be implemented in Phase 2")
        with col2:
            if st.button("📋 Copy Path", use_container_width=True):
                st.code(f"~/.cardex/{output_path}")
        with col3:
            if st.button("🔄 Regenerate", use_container_width=True):
                st.session_state.synthesis_complete = False
                st.rerun()

    # Footer
    st.divider()
    st.caption(
        "💡 Tip: Synthesis documents are saved as Markdown files and can be edited with any text editor."
    )


if __name__ == "__main__":
    main()
