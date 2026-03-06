"""Paradigm Analysis Page - Generate analysis cards from papers.

This page allows users to:
1. Select a paradigm (research perspective)
2. Select papers (folder or individual files)
3. Configure analysis lenses
4. Generate analysis cards (paper × lens combinations)
"""

import streamlit as st
from pathlib import Path
import sys

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from cardex.paradigm import ParadigmLoader
from cardex.database import CardexDatabase
from cardex.config import CardexConfig


def main():
    """Main function for Paradigm Analysis page."""

    # Initialize
    config = CardexConfig()
    paradigm_loader = ParadigmLoader()
    db = CardexDatabase()

    # Load i18n
    if "locale" not in st.session_state:
        st.session_state.locale = config.get("i18n.locale", "zh-TW")

    # Page config
    st.set_page_config(page_title="Paradigm Analysis - Cardex", page_icon="🎼", layout="wide")

    # Title
    st.title("🎼 Paradigm Analysis")
    st.caption("Analyze your papers through a research paradigm")

    st.divider()

    # Step 1: Select Paradigm
    st.header("📋 Step 1: Select Paradigm")

    paradigms = paradigm_loader.list_paradigms()

    if not paradigms:
        st.warning("⚠️ No paradigms found. Please create a paradigm first.")
        st.info("Place your `.paradigm` files in `~/.cardex/paradigms/`")
        st.code(
            """
# Example: Create your first paradigm
cp paradigms/example.paradigm ~/.cardex/paradigms/my_research.paradigm
# Then edit it with your research topic
        """,
            language="bash",
        )
        st.stop()

    # Paradigm selector
    paradigm_options = [f"{p['name']} ({p['type']})" for p in paradigms]

    selected_index = st.selectbox(
        "Select a paradigm",
        range(len(paradigm_options)),
        format_func=lambda i: paradigm_options[i],
        key="paradigm_selector",
    )

    selected_paradigm = paradigms[selected_index]
    paradigm_config = paradigm_loader.load_paradigm(selected_paradigm["file_path"])

    # Store in session state
    st.session_state.selected_paradigm = selected_paradigm
    st.session_state.paradigm_config = paradigm_config

    # Display paradigm details
    with st.expander("📖 Paradigm Details", expanded=False):
        col1, col2, col3 = st.columns(3)
        with col1:
            st.metric("Type", selected_paradigm["type"].title())
        with col2:
            st.metric("Core Questions", len(selected_paradigm.get("core_questions", [])))
        with col3:
            st.metric("Lenses", len(selected_paradigm.get("lenses", [])))

        if selected_paradigm.get("theoretical_frameworks"):
            st.write("**Theoretical Frameworks:**")
            for fw in selected_paradigm["theoretical_frameworks"]:
                st.write(f"- {fw}")

        if selected_paradigm.get("core_questions"):
            st.write("**Core Questions:**")
            for q in selected_paradigm["core_questions"]:
                st.write(f"- {q}")

    st.divider()

    # Step 2: Select Papers
    st.header("📁 Step 2: Select Papers")

    st.info(
        "⚠️ **Note**: Paper selection will be fully implemented in the next phase. "
        "Currently showing UI mockup only."
    )

    # Selection mode
    selection_mode = st.radio(
        "Selection Mode",
        ["Individual Files", "Entire Folder"],
        horizontal=True,
        key="selection_mode",
    )

    if selection_mode == "Entire Folder":
        st.text_input(
            "Folder Path", placeholder="e.g., ~/Documents/papers/1_國際法", key="folder_path"
        )
        st.caption("💡 All PDF files in this folder will be analyzed")

        # Mock paper count
        selected_papers_count = st.slider("Papers in folder (mock)", 0, 50, 10)
        st.session_state.selected_papers = list(range(selected_papers_count))
    else:
        st.text_input(
            "🔍 Search papers",
            placeholder="Search by title, author, or keywords...",
            key="paper_search",
        )

        # Mock paper list
        st.caption("Select papers to analyze:")
        mock_papers = [
            "[O'Connell 2022] Privacy Rights During Armed Conflict",
            "[Blank 2022] Data as Property Under IHL",
            "[West 2022] Precautionary Principle in Cyberwarfare",
        ]

        selected_papers = st.multiselect(
            "Papers", mock_papers, default=mock_papers[:2], key="selected_papers_list"
        )
        st.session_state.selected_papers = selected_papers

    selected_count = len(st.session_state.get("selected_papers", []))
    st.success(f"✅ Selected: {selected_count} papers")

    st.divider()

    # Step 3: Configure Lenses
    st.header("🔬 Step 3: Configure Analysis Lenses")

    if not paradigm_config or "lenses" not in paradigm_config:
        st.warning("This paradigm has no lenses defined.")
        st.stop()

    # Lens selection
    st.caption("Select which analytical lenses to apply:")

    if "selected_lenses" not in st.session_state:
        # Default: all lenses selected
        st.session_state.selected_lenses = [lens["name"] for lens in paradigm_config["lenses"]]

    for lens in paradigm_config["lenses"]:
        lens_name = lens.get("name")
        lens_desc = lens.get("output_structure", "").split("\n")[0]  # First line as description

        checked = lens_name in st.session_state.selected_lenses

        if st.checkbox(lens_name, value=checked, key=f"lens_{lens_name}"):
            if lens_name not in st.session_state.selected_lenses:
                st.session_state.selected_lenses.append(lens_name)
        else:
            if lens_name in st.session_state.selected_lenses:
                st.session_state.selected_lenses.remove(lens_name)

        if lens_desc:
            st.caption(f"  ↳ {lens_desc[:100]}...")

    st.divider()

    # Step 4: Analysis Summary & Generate
    st.header("📊 Analysis Summary")

    papers_count = selected_count
    lenses_count = len(st.session_state.get("selected_lenses", []))
    expected_cards = papers_count * lenses_count
    estimated_time = expected_cards * 45  # 45 seconds per card

    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric("Papers", papers_count)
    with col2:
        st.metric("Lenses", lenses_count)
    with col3:
        st.metric("Expected Cards", expected_cards)
    with col4:
        minutes = estimated_time // 60
        seconds = estimated_time % 60
        st.metric("Estimated Time", f"~{minutes}m {seconds}s")

    st.divider()

    # Generate button
    can_generate = papers_count > 0 and lenses_count > 0

    if st.button(
        "🎼 Generate Analysis Cards",
        type="primary",
        disabled=not can_generate,
        use_container_width=True,
    ):
        st.session_state.generation_started = True

    # Generation process (mock)
    if st.session_state.get("generation_started", False):
        with st.spinner("Analyzing papers..."):
            import time

            progress_bar = st.progress(0)
            status_text = st.empty()

            # Mock generation
            for i in range(expected_cards):
                progress = (i + 1) / expected_cards
                progress_bar.progress(progress)
                status_text.text(f"Processing card {i + 1} of {expected_cards}...")
                time.sleep(0.5)  # Mock processing time

            st.session_state.generation_started = False
            st.session_state.generation_complete = True

        # Success message
        st.success("✅ Analysis Complete!")

        st.info(f"""
**Results Summary:**
- {papers_count} papers analyzed
- {lenses_count} lenses applied
- {expected_cards} cards saved to `~/.cardex/analyses/`
        """)

        col1, col2 = st.columns(2)
        with col1:
            if st.button("📄 View Generated Cards", use_container_width=True):
                st.info("Card viewing will be implemented in Phase 2")
        with col2:
            if st.button("🎭 Continue to Synthesis →", type="primary", use_container_width=True):
                st.switch_page("pages/2_🎭_Concerto_Synthesis.py")

    # Footer
    st.divider()
    st.caption(
        "💡 Tip: Analysis cards are saved to `~/.cardex/analyses/` and can be reviewed in the Synthesis page."
    )


if __name__ == "__main__":
    main()
