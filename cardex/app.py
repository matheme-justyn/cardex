"""Streamlit web UI for Cardex Phase 0.

Browse and search PDF library with i18n and theme support.
"""

from datetime import datetime
from pathlib import Path
from typing import Dict, Any

import pandas as pd
import streamlit as st
import toml

from cardex.config import CardexConfig
from cardex.scanner import PDFScanner


class I18n:
    """Simple i18n handler for Streamlit UI."""

    def __init__(self, locale: str = "en-US"):
        """Initialize i18n with specified locale.

        Args:
            locale: BCP 47 language tag (e.g., "en-US", "zh-TW")
        """
        self.locale = locale
        self.translations = self._load_translations(locale)
        self.fallback = self._load_translations("en-US") if locale != "en-US" else {}

    def _load_translations(self, locale: str) -> Dict[str, Any]:
        """Load translations from i18n/locales/{locale}/app.toml.

        Args:
            locale: Language code

        Returns:
            Translation dictionary
        """
        # Get project root (parent of cardex package)
        project_root = Path(__file__).parent.parent
        translation_file = project_root / "i18n" / "locales" / locale / "app.toml"

        if translation_file.exists():
            return toml.load(translation_file)
        return {}

    def t(self, key: str, **kwargs) -> str:
        """Get translated string by dot-separated key.

        Args:
            key: Dot-separated translation key (e.g., "page.title")
            **kwargs: Variables to format into the string

        Returns:
            Translated and formatted string

        Example:
            >>> i18n.t("search.showing", count=5, total=10)
            "Showing 5 of 10 files"
        """
        keys = key.split(".")
        value = self.translations

        # Try to get from current locale
        for k in keys:
            if isinstance(value, dict) and k in value:
                value = value[k]
            else:
                # Fallback to English
                value = self.fallback
                for k in keys:
                    if isinstance(value, dict) and k in value:
                        value = value[k]
                    else:
                        return key  # Return key itself if not found

        # Format with variables if provided
        if isinstance(value, str) and kwargs:
            return value.format(**kwargs)
        return value


def apply_theme(theme: str):
    """Apply theme using comprehensive CSS overrides.

    Args:
        theme: "light", "dark", or "auto"

    Note:
        Streamlit's theme system requires server restart or configuration.
        For runtime theme switching, we use CSS overrides.
    """
    if theme == "light":
        # Apply light theme CSS with comprehensive coverage
        st.markdown(
            """
            <style>
            /* Light mode - Force all text to be dark */
            * {
                color: #262730 !important;
            }
            
            :root,
            [data-testid="stAppViewContainer"],
            .main {
                background-color: #ffffff !important;
            }
            
            [data-testid="stSidebar"] {
                background-color: #f0f2f6 !important;
            }
            
            [data-testid="stHeader"] {
                background-color: rgba(255, 255, 255, 0.95) !important;
            }
            
            /* Input widgets */
            .stTextInput input,
            .stSelectbox select,
            .stTextArea textarea,
            .stNumberInput input {
                background-color: #ffffff !important;
                color: #262730 !important;
                border-color: #d3d3d3 !important;
            }
            
            /* Selectbox dropdown menu */
            .stSelectbox div[data-baseweb="select"] {
                background-color: #ffffff !important;
            }
            
            .stSelectbox div[data-baseweb="select"] > div {
                background-color: #ffffff !important;
                color: #262730 !important;
            }
            
            /* Dropdown options */
            [role="listbox"],
            [role="option"] {
                background-color: #ffffff !important;
                color: #262730 !important;
            }
            
            [role="option"]:hover {
                background-color: #e8eaed !important;
                color: #262730 !important;
            }
            
            /* Dropdown menu container */
            ul[role="listbox"] {
                background-color: #ffffff !important;
            }
            
            ul[role="listbox"] li {
                background-color: #ffffff !important;
                color: #262730 !important;
            }
            
            ul[role="listbox"] li:hover {
                background-color: #e8eaed !important;
            }
            
            /* Buttons */
            .stButton button {
                background-color: #ffffff !important;
                color: #262730 !important;
                border-color: #d3d3d3 !important;
            }
            
            .stButton button:hover {
                background-color: #f0f2f6 !important;
                border-color: #a0a0a0 !important;
            }
            
            /* DataFrames and Tables */
            .stDataFrame,
            [data-testid="stDataFrame"],
            .dataframe {
                background-color: #ffffff !important;
                color: #262730 !important;
            }
            
            .stDataFrame table,
            .stDataFrame th,
            .stDataFrame td {
                color: #262730 !important;
                background-color: #ffffff !important;
            }
            
            /* Metrics and Stats */
            .stMetric,
            [data-testid="stMetricValue"],
            [data-testid="stMetricLabel"] {
                color: #262730 !important;
            }
            
            /* Text elements */
            h1, h2, h3, h4, h5, h6, p, span, div, label {
                color: #262730 !important;
            }
            
            /* Captions and small text */
            .stCaption, small {
                color: #666666 !important;
            }
            
            /* Code blocks */
            code, pre {
                background-color: #f0f2f6 !important;
                color: #262730 !important;
            }
            
            /* Expander */
            .streamlit-expanderHeader {
                background-color: #f0f2f6 !important;
                color: #262730 !important;
            }
            </style>
            """,
            unsafe_allow_html=True,
        )
    elif theme == "dark":
        # Apply dark theme CSS
        st.markdown(
            """
            <style>
            /* Dark mode overrides */
            :root {
                --background-color: #0e1117;
                --secondary-background-color: #262730;
                --text-color: #fafafa;
            }
            
            [data-testid="stAppViewContainer"] {
                background-color: var(--background-color);
                color: var(--text-color);
            }
            
            [data-testid="stSidebar"] {
                background-color: var(--secondary-background-color);
            }
            
            [data-testid="stHeader"] {
                background-color: rgba(14, 17, 23, 0.95);
            }
            
            /* Widget overrides */
            .stTextInput input, .stSelectbox select {
                background-color: #1e1e1e;
                color: #fafafa;
            }
            
            .stDataFrame {
                background-color: #0e1117;
            }
            </style>
            """,
            unsafe_allow_html=True,
        )
    elif theme == "auto":
        # Use system preference via CSS media query
        st.markdown(
            """
            <style>
            /* Auto mode - follows system preference */
            @media (prefers-color-scheme: light) {
                * {
                    color: #262730 !important;
                }
                
                :root,
                [data-testid="stAppViewContainer"],
                .main {
                    background-color: #ffffff !important;
                }
                
                [data-testid="stSidebar"] {
                    background-color: #f0f2f6 !important;
                }
                
                .stTextInput input, .stSelectbox select {
                    background-color: #ffffff !important;
                    color: #262730 !important;
                }
                
                /* Selectbox dropdown for light mode in auto */
                [role="listbox"],
                [role="option"] {
                    background-color: #ffffff !important;
                    color: #262730 !important;
                }
                
                [role="option"]:hover {
                    background-color: #e8eaed !important;
                    color: #262730 !important;
                }
                
                ul[role="listbox"] {
                    background-color: #ffffff !important;
                }
                
                ul[role="listbox"] li {
                    background-color: #ffffff !important;
                    color: #262730 !important;
                }
                
                ul[role="listbox"] li:hover {
                    background-color: #e8eaed !important;
                }
                
                .stDataFrame,
                .stDataFrame table,
                .stDataFrame th,
                .stDataFrame td {
                    background-color: #ffffff !important;
                    color: #262730 !important;
            }
            
            @media (prefers-color-scheme: dark) {
                :root {
                    --background-color: #0e1117;
                    --secondary-background-color: #262730;
                    --text-color: #fafafa;
                }
                
                [data-testid="stAppViewContainer"] {
                    background-color: var(--background-color);
                    color: var(--text-color);
                }
                
                [data-testid="stSidebar"] {
                    background-color: var(--secondary-background-color);
                }
                
                .stTextInput input, .stSelectbox select {
                    background-color: #1e1e1e;
                    color: #fafafa;
                }
            }
            </style>
            """,
            unsafe_allow_html=True,
        )

def format_file_size(size_bytes: int) -> str:
    """Format file size in human-readable format.

    Args:
        size_bytes: File size in bytes

    Returns:
        Formatted string (e.g., "1.23 MB")
    """
    if size_bytes < 1024:
        return f"{size_bytes} B"
    elif size_bytes < 1024 * 1024:
        return f"{size_bytes / 1024:.2f} KB"
    else:
        return f"{size_bytes / (1024 * 1024):.2f} MB"


def format_datetime(dt: datetime) -> str:
    """Format datetime in readable format.

    Args:
        dt: Datetime object

    Returns:
        Formatted string (e.g., "2024-03-03 10:30")
    """
    return dt.strftime("%Y-%m-%d %H:%M")


def main():
    """Main Streamlit app with i18n and theme support."""
    # Load config
    config = CardexConfig()

    # Initialize session state from config
    if "locale" not in st.session_state:
        st.session_state.locale = config.get("i18n.locale", "zh-TW")
    if "theme" not in st.session_state:
        st.session_state.theme = config.get("theme.mode", "light")
    i18n = I18n(st.session_state.locale)

    # Set page config
    st.set_page_config(
        page_title=i18n.t("page.title"),
        page_icon="📇",
        layout="wide",
    )

    # Apply theme
    apply_theme(st.session_state.theme)

    st.title(i18n.t("page.title"))
    st.caption(i18n.t("page.subtitle"))

    # Check config exists
    if not config.config_path.exists():
        st.error(i18n.t("errors.config_not_found"))
        st.code("cardex init", language="bash")
        st.stop()

    # Prioritize default_path from config, fallback to library_root
    default_path = config.get("library.default_path")
    if default_path:
        library_root = Path(default_path).expanduser()
    else:
        library_root = config.library_root

    # Check library exists
    if not library_root.exists():
        st.error(i18n.t("errors.library_not_found", path=library_root))
        st.info(i18n.t("errors.run_init"))
        st.stop()

    # Sidebar: Settings, language selector, and theme selector
    with st.sidebar:
        st.header(i18n.t("sidebar.settings_header"))

        # Language selector
        languages = {
            "en-US": "English (US)",
            "zh-TW": "繁體中文（台灣）",
        }
        selected_lang = st.selectbox(
            i18n.t("sidebar.language_label"),
            options=list(languages.keys()),
            format_func=lambda x: languages[x],
            index=list(languages.keys()).index(st.session_state.locale),
            key="language_selector",
        )

        # Update locale if changed
        if selected_lang != st.session_state.locale:
            st.session_state.locale = selected_lang
            st.rerun()

        # Theme selector
        themes = {
            "light": i18n.t("theme.light"),
            "dark": i18n.t("theme.dark"),
            "auto": i18n.t("theme.auto"),
        }
        selected_theme = st.selectbox(
            i18n.t("sidebar.theme_label"),
            options=list(themes.keys()),
            format_func=lambda x: themes[x],
            index=list(themes.keys()).index(st.session_state.theme),
            key="theme_selector",
        )

        # Update theme if changed
        if selected_theme != st.session_state.theme:
            st.session_state.theme = selected_theme
            st.rerun()

        st.divider()

        # Save preferences button
        if st.button(i18n.t("sidebar.save_preferences_button") if i18n.t("sidebar.save_preferences_button") != "sidebar.save_preferences_button" else "💾 儲存偏好設定", use_container_width=True):
            config.set("i18n.locale", st.session_state.locale)
            config.set("theme.mode", st.session_state.theme)
            config.save()
            st.success(i18n.t("messages.preferences_saved") if i18n.t("messages.preferences_saved") != "messages.preferences_saved" else "✅ 偏好設定已儲存")

        # Library path configuration - simple and safe
        st.subheader(i18n.t("sidebar.library_config_header") if i18n.t("sidebar.library_config_header") != "sidebar.library_config_header" else "📁 圖書館設定")
        
        # Current library path display
        st.caption(f"📍 {i18n.t('sidebar.current_library') if i18n.t('sidebar.current_library') != 'sidebar.current_library' else '當前圖書館'}: {library_root}")
        
        # Path input
        new_library_path = st.text_input(
            i18n.t("sidebar.path_input_label") if i18n.t("sidebar.path_input_label") != "sidebar.path_input_label" else "📂 輸入新路徑",
            value=str(library_root),
            help=i18n.t("sidebar.path_input_help") if i18n.t("sidebar.path_input_help") != "sidebar.path_input_help" else "輸入完整路徑，支援 ~ 符號。例如：~/Documents/papers",
            key="library_path_input",
        )
        
        # Quick paths - smaller buttons with custom CSS
        st.markdown("""<style>
        div[data-testid="column"] button {
            font-size: 0.85rem !important;
            padding: 0.25rem 0.5rem !important;
            white-space: nowrap !important;
        }
        </style>""", unsafe_allow_html=True)
        
        st.caption("🔗 " + (i18n.t("sidebar.quick_paths") if i18n.t("sidebar.quick_paths") != "sidebar.quick_paths" else "快速選擇"))
        col1, col2, col3, col4 = st.columns(4)
        
        from pathlib import Path as PathLib
        import platform
        
        # Column 1: Default path (priority)
        with col1:
            default_lib = config.get("library.default_path")
            if default_lib:
                default_path = PathLib(default_lib).expanduser()
                if st.button("⭐", use_container_width=True, help=i18n.t("sidebar.default") if i18n.t("sidebar.default") != "sidebar.default" else f"預設: {default_path.name}"):
                    try:
                        if default_path.exists():
                            config.set("library.root_path", str(default_path))
                            config.save()
                            st.session_state.update_success = str(default_path)
                            st.cache_data.clear()
                            st.rerun()
                        else:
                            st.session_state.update_error = "❌ 路徑不存在"
                    except Exception as e:
                        st.session_state.update_error = f"❌ {str(e)}"
        
        # Column 2: Desktop (OS-aware)
        with col2:
            # Determine desktop path based on OS
            system = platform.system()
            if system == "Darwin":  # macOS
                desktop_path = PathLib.home() / "Desktop"
            elif system == "Windows":
                desktop_path = PathLib.home() / "Desktop"
            else:  # Linux and others
                desktop_path = PathLib.home() / "Desktop"
            
            if st.button("🖥️", use_container_width=True, help=i18n.t("sidebar.desktop") if i18n.t("sidebar.desktop") != "sidebar.desktop" else "桌面"):
                try:
                    if desktop_path.exists():
                        config.set("library.root_path", str(desktop_path))
                        config.save()
                        st.session_state.update_success = str(desktop_path)
                        st.cache_data.clear()
                        st.rerun()
                    else:
                        st.session_state.update_error = "❌ 路徑不存在"
                except Exception as e:
                    st.session_state.update_error = f"❌ {str(e)}"
        
        # Column 3: Documents
        with col3:
            if st.button("📝", use_container_width=True, help=i18n.t("sidebar.documents") if i18n.t("sidebar.documents") != "sidebar.documents" else "文件"):
                try:
                    docs_path = PathLib.home() / "Documents"
                    if docs_path.exists():
                        config.set("library.root_path", str(docs_path))
                        config.save()
                        st.session_state.update_success = str(docs_path)
                        st.cache_data.clear()
                        st.rerun()
                    else:
                        st.session_state.update_error = "❌ 路徑不存在"
                except Exception as e:
                    st.session_state.update_error = f"❌ {str(e)}"
        
        # Column 4: Downloads
        with col4:
            if st.button("📥", use_container_width=True, help=i18n.t("sidebar.downloads") if i18n.t("sidebar.downloads") != "sidebar.downloads" else "下載"):
                try:
                    downloads_path = PathLib.home() / "Downloads"
                    if downloads_path.exists():
                        config.set("library.root_path", str(downloads_path))
                        config.save()
                        st.session_state.update_success = str(downloads_path)
                        st.cache_data.clear()
                        st.rerun()
                    else:
                        st.session_state.update_error = "❌ 路徑不存在"
                except Exception as e:
                    st.session_state.update_error = f"❌ {str(e)}"
        
        # Display update messages
        if "update_success" in st.session_state:
            st.success(f"✅ {st.session_state.update_success}")
            del st.session_state.update_success
        if "update_error" in st.session_state:
            st.error(st.session_state.update_error)
            del st.session_state.update_error
        # Update button
        if st.button("✅ " + (i18n.t("sidebar.update_path") if i18n.t("sidebar.update_path") != "sidebar.update_path" else "更新路徑"), use_container_width=True, type="primary"):
            new_path = PathLib(new_library_path).expanduser()
            
            if new_path.exists() and new_path.is_dir():
                config.set("library.root_path", str(new_path))
                config.save()
                st.success(i18n.t("messages.library_updated") if i18n.t("messages.library_updated") != "messages.library_updated" else f"✅ 圖書館路徑已更新！")
                st.cache_data.clear()
                st.rerun()
            elif not new_path.exists():
                st.error(i18n.t("errors.path_not_exist") if i18n.t("errors.path_not_exist") != "errors.path_not_exist" else f"❌ 路徑不存在：{new_path}")
            else:
                st.error(i18n.t("errors.not_directory") if i18n.t("errors.not_directory") != "errors.not_directory" else f"❌ 不是資料夾：{new_path}")
        
        st.text(f"{i18n.t('sidebar.recursive_label')}: {config.recursive_scan}")
        st.divider()

        if st.button(i18n.t("sidebar.refresh_button"), use_container_width=True):
            st.cache_data.clear()
            st.rerun()
        st.divider()

        st.caption(f"{i18n.t('sidebar.config_label')}: {config.config_path}")

    # Main content: Tabs for Library and Tutorial
    tab1, tab2 = st.tabs([i18n.t("tabs.library"), i18n.t("tabs.tutorial")])
    
    # Tab 1: Library (PDF list)
    with tab1:
        with st.spinner(i18n.t("messages.scanning")):
            pdf_list = scan_library(library_root, config.recursive_scan)
        
        if not pdf_list:
            st.warning(i18n.t("errors.no_pdfs"))
            st.info(i18n.t("errors.place_pdfs", path=library_root))
        else:
            # Statistics
            stats = get_stats(pdf_list)
            col1, col2, col3, col4 = st.columns(4)
            
            with col1:
                st.metric(i18n.t("stats.total_pdfs"), stats["total_count"])
            with col2:
                st.metric(i18n.t("stats.readable"), stats["readable_count"])
            with col3:
                st.metric(i18n.t("stats.unreadable"), stats["unreadable_count"])
            with col4:
                st.metric(i18n.t("stats.total_size"), f"{stats['total_size_mb']:.1f} MB")
            
            st.divider()
            
            # Search/Filter
            search_query = st.text_input(i18n.t("search.label"), placeholder=i18n.t("search.placeholder"))
            
            # Filter PDF list
            filtered_list = pdf_list
            if search_query:
                filtered_list = [pdf for pdf in pdf_list if search_query.lower() in pdf.filename.lower()]
            
            st.caption(i18n.t("search.showing", count=len(filtered_list), total=len(pdf_list)))
            
            # Convert to DataFrame for display
            df_data = []
            for pdf in filtered_list:
                status = (
                    i18n.t("table.status_readable")
                    if pdf.is_readable
                    else i18n.t("table.status_unreadable")
                )
                df_data.append(
                    {
                        i18n.t("table.status"): status,
                        i18n.t("table.filename"): pdf.filename,
                        i18n.t("table.size"): format_file_size(pdf.size_bytes),
                        i18n.t("table.pages"): pdf.page_count if pdf.page_count else "N/A",
                        i18n.t("table.modified"): format_datetime(pdf.modified_time),
                        i18n.t("table.path"): str(pdf.path.relative_to(library_root)) if pdf.path.is_relative_to(library_root) else str(pdf.path),
                    }
                )
            
            df = pd.DataFrame(df_data)
            
            # Display table
            st.dataframe(
                df,
                use_container_width=True,
                hide_index=True,
                column_config={
                    i18n.t("table.status"): st.column_config.TextColumn(width="small"),
                    i18n.t("table.filename"): st.column_config.TextColumn(width="medium"),
                    i18n.t("table.size"): st.column_config.TextColumn(width="small"),
                    i18n.t("table.pages"): st.column_config.TextColumn(width="small"),
                    i18n.t("table.modified"): st.column_config.TextColumn(width="medium"),
                    i18n.t("table.path"): st.column_config.TextColumn(width="large"),
                },
            )
            
            # Show errors if any
            errors = [pdf for pdf in filtered_list if not pdf.is_readable]
            if errors:
                with st.expander(i18n.t("messages.unreadable_files", count=len(errors)), expanded=False):
                    for pdf in errors:
                        st.text(f"❌ {pdf.filename}")
                        if pdf.error:
                            st.caption(f"   {i18n.t('messages.error_label')}: {pdf.error}")
    
    # Tab 2: Tutorial
    with tab2:
        render_tutorial(i18n)


def render_tutorial(i18n):
    """Render the tutorial page with i18n support."""
    st.title(i18n.t("tutorial.title"))
    
    # Welcome section
    st.header(i18n.t("tutorial.welcome"))
    st.write(i18n.t("tutorial.welcome_desc"))
    
    st.divider()
    
    # Quick Start
    st.header(i18n.t("tutorial.quick_start.title"))
    
    col1, col2, col3 = st.columns(3)
    with col1:
        st.subheader(i18n.t("tutorial.quick_start.step1_title"))
        st.write(i18n.t("tutorial.quick_start.step1_desc"))
    
    with col2:
        st.subheader(i18n.t("tutorial.quick_start.step2_title"))
        st.write(i18n.t("tutorial.quick_start.step2_desc"))
    
    with col3:
        st.subheader(i18n.t("tutorial.quick_start.step3_title"))
        st.write(i18n.t("tutorial.quick_start.step3_desc"))
    
    st.divider()
    
    # Features
    st.header(i18n.t("tutorial.features.title"))
    
    st.subheader(i18n.t("tutorial.features.library_title"))
    st.markdown(i18n.t("tutorial.features.library_desc"))
    
    st.subheader(i18n.t("tutorial.features.search_title"))
    st.write(i18n.t("tutorial.features.search_desc"))
    
    st.subheader(i18n.t("tutorial.features.stats_title"))
    st.write(i18n.t("tutorial.features.stats_desc"))
    
    st.divider()
    
    # Quick Buttons
    st.header(i18n.t("tutorial.quick_buttons.title"))
    
    col1, col2 = st.columns(2)
    with col1:
        st.markdown(f"**{i18n.t('tutorial.quick_buttons.default_title')}**")
        st.write(i18n.t("tutorial.quick_buttons.default_desc"))
        
        st.markdown(f"**{i18n.t('tutorial.quick_buttons.documents_title')}**")
        st.write(i18n.t("tutorial.quick_buttons.documents_desc"))
    
    with col2:
        st.markdown(f"**{i18n.t('tutorial.quick_buttons.desktop_title')}**")
        st.write(i18n.t("tutorial.quick_buttons.desktop_desc"))
        
        st.markdown(f"**{i18n.t('tutorial.quick_buttons.downloads_title')}**")
        st.write(i18n.t("tutorial.quick_buttons.downloads_desc"))
    
    st.divider()
    
    # Tips
    st.header(i18n.t("tutorial.tips.title"))
    
    # Tip 1: Let AI configure
    with st.expander(i18n.t("tutorial.tips.tip1_title"), expanded=True):
        st.write(i18n.t("tutorial.tips.tip1_desc"))
        st.code(i18n.t("tutorial.tips.tip1_prompt"), language="text")
    
    # Tip 2: Organize PDFs
    with st.expander(i18n.t("tutorial.tips.tip2_title")):
        st.write(i18n.t("tutorial.tips.tip2_desc"))
        st.code(i18n.t("tutorial.tips.tip2_prompt"), language="text")
    
    # Tip 3: Quick customization
    with st.expander(i18n.t("tutorial.tips.tip3_title")):
        st.write(i18n.t("tutorial.tips.tip3_desc"))
    
    st.divider()
    
    # Coming Soon
    st.header(i18n.t("tutorial.coming_soon.title"))
    st.markdown(i18n.t("tutorial.coming_soon.phase1"))
    st.markdown(i18n.t("tutorial.coming_soon.phase2"))
    st.markdown(i18n.t("tutorial.coming_soon.phase3"))
    
    st.divider()
    
    # Feedback
    st.header(i18n.t("tutorial.feedback.title"))
    st.write(i18n.t("tutorial.feedback.desc"))
    st.link_button(
        i18n.t("tutorial.feedback.link_text"),
        "https://github.com/matheme-justyn/cardex/issues",
        use_container_width=False
    )


@st.cache_data(ttl=60)
def scan_library(library_root: Path, recursive: bool):
    """Scan library for PDFs (cached for 60 seconds).

    Args:
        library_root: Root directory to scan
        recursive: Scan subdirectories

    Returns:
        List of PDFInfo objects
    """
    scanner = PDFScanner(library_root, recursive=recursive)
    return scanner.scan()


def get_stats(pdf_list):
    """Calculate statistics from PDF list.

    Args:
        pdf_list: List of PDFInfo objects

    Returns:
        Statistics dictionary
    """
    scanner = PDFScanner(Path.home(), recursive=False)  # Dummy instance for stats
    return scanner.get_stats(pdf_list)


if __name__ == "__main__":
    main()
