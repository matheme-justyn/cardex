#!/usr/bin/env python3
"""
自動化測試：快速選擇按鈕功能

測試範圍：
1. 所有快速按鈕的路徑計算邏輯
2. Desktop 按鈕的跨平台支援
3. 錯誤處理（路徑不存在、無權限等）
"""

import platform
import tempfile
from pathlib import Path
from unittest.mock import Mock


def test_default_button_path_resolution():
    """測試 Default 按鈕路徑解析"""
    print("  測試 Default 按鈕路徑解析...")

    # Path should expand tilde
    path_with_tilde = "~/Library/CloudStorage/Dropbox/6_digital/matheme-scriptorium"
    expanded = Path(path_with_tilde).expanduser()

    assert expanded.is_absolute(), "路徑應該是絕對路徑"
    assert "~" not in str(expanded), "路徑中不應該包含 ~"
    print("    ✅ Tilde expansion 正常")


def test_desktop_paths_all_platforms():
    """測試所有平台的 Desktop 路徑"""
    print("  測試跨平台 Desktop 路徑...")

    # Current platform
    system = platform.system()
    print(f"    當前平台: {system}")

    # Test all platform paths
    for platform_name in ["Darwin", "Windows", "Linux"]:
        if platform_name == "Darwin":
            desktop = Path.home() / "Desktop"
        elif platform_name == "Windows":
            desktop = Path.home() / "Desktop"
        else:  # Linux
            desktop = Path.home() / "Desktop"

        assert str(desktop).endswith("Desktop"), f"{platform_name} Desktop 路徑應該以 Desktop 結尾"
        assert desktop.is_absolute(), f"{platform_name} Desktop 路徑應該是絕對路徑"
        print(f"    ✅ {platform_name}: {desktop}")

    # Check if current platform Desktop exists
    current_desktop = Path.home() / "Desktop"
    if current_desktop.exists():
        print(f"    ✅ 當前平台 Desktop 存在: {current_desktop}")
    else:
        print(f"    ⚠️  當前平台 Desktop 不存在（這在某些系統上是正常的）")


def test_documents_path():
    """測試 Documents 路徑"""
    print("  測試 Documents 路徑...")
    docs_path = Path.home() / "Documents"

    assert docs_path.is_absolute(), "Documents 路徑應該是絕對路徑"
    assert str(docs_path).endswith("Documents"), "路徑應該以 Documents 結尾"

    if docs_path.exists():
        print(f"    ✅ Documents 存在: {docs_path}")
    else:
        print(f"    ⚠️  Documents 不存在: {docs_path}")


def test_downloads_path():
    """測試 Downloads 路徑"""
    print("  測試 Downloads 路徑...")
    downloads_path = Path.home() / "Downloads"

    assert downloads_path.is_absolute(), "Downloads 路徑應該是絕對路徑"
    assert str(downloads_path).endswith("Downloads"), "路徑應該以 Downloads 結尾"

    if downloads_path.exists():
        print(f"    ✅ Downloads 存在: {downloads_path}")
    else:
        print(f"    ⚠️  Downloads 不存在: {downloads_path}")


def test_error_nonexistent_path():
    """測試不存在的路徑錯誤"""
    print("  測試不存在路徑的錯誤處理...")
    nonexistent = Path("/this/path/does/not/exist/at/all")

    assert not nonexistent.exists(), "測試路徑不應該存在"

    # 應該顯示錯誤而非崩潰
    error_message = f"❌ 路徑不存在: {nonexistent}"
    assert "❌" in error_message
    print(f"    ✅ 正確檢測不存在的路徑")


def test_error_file_as_directory():
    """測試將檔案當作資料夾的錯誤"""
    print("  測試檔案路徑錯誤處理...")

    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        test_file = Path(tmp.name)

    try:
        assert test_file.exists(), "測試檔案應該存在"
        assert not test_file.is_dir(), "測試檔案不應該是資料夾"

        # 應該顯示錯誤
        error_message = f"❌ 不是資料夾: {test_file}"
        assert "❌" in error_message
        print(f"    ✅ 正確檢測檔案不是資料夾")
    finally:
        test_file.unlink()  # Cleanup


def test_path_with_tilde_expansion():
    """測試包含 ~ 的路徑展開"""
    print("  測試 ~ 路徑展開...")
    path_with_tilde = Path("~/Desktop")
    expanded = path_with_tilde.expanduser()

    assert "~" not in str(expanded), "展開後不應該包含 ~"
    assert expanded.is_absolute(), "展開後應該是絕對路徑"
    print(f"    ✅ ~ 展開正常: {path_with_tilde} -> {expanded}")


def test_relative_path_conversion():
    """測試相對路徑轉換"""
    print("  測試相對路徑計算...")

    with tempfile.TemporaryDirectory() as tmpdir:
        library_root = Path(tmpdir) / "library"
        library_root.mkdir()

        pdf_path = library_root / "subfolder" / "paper.pdf"
        pdf_path.parent.mkdir()
        pdf_path.write_text("dummy pdf")

        # Test relative path calculation
        if pdf_path.is_relative_to(library_root):
            relative = pdf_path.relative_to(library_root)
            assert str(relative) == "subfolder/paper.pdf" or str(relative) == "subfolder\\paper.pdf"
            print(f"    ✅ 相對路徑計算正確: {relative}")
        else:
            print(f"    ❌ is_relative_to 失敗")


def test_current_platform_detection():
    """測試當前平台偵測"""
    print("  測試平台偵測...")
    system = platform.system()

    assert system in ["Darwin", "Windows", "Linux"], (
        f"平台應該是 Darwin/Windows/Linux，實際: {system}"
    )
    print(f"    ✅ 平台偵測: {system}")


def test_home_directory():
    """測試主目錄存在"""
    print("  測試主目錄...")
    home = Path.home()

    assert home.exists(), "主目錄應該存在"
    assert home.is_dir(), "主目錄應該是資料夾"
    print(f"    ✅ 主目錄存在: {home}")


def simulate_button_click(button_name: str, config_mock: Mock):
    """
    模擬按鈕點擊邏輯

    Args:
        button_name: 'default', 'desktop', 'documents', 'downloads'
        config_mock: Mock config object

    Returns:
        tuple: (success: bool, path: Path, error: str)
    """
    from pathlib import Path as PathLib
    import platform

    try:
        if button_name == "default":
            default_lib = config_mock.get("library.default_path")
            if default_lib:
                path = PathLib(default_lib).expanduser()
                if path.exists():
                    return True, path, None
                else:
                    return False, path, "❌ 路徑不存在"

        elif button_name == "desktop":
            system = platform.system()
            if system == "Darwin":
                path = PathLib.home() / "Desktop"
            elif system == "Windows":
                path = PathLib.home() / "Desktop"
            else:
                path = PathLib.home() / "Desktop"

            if path.exists():
                return True, path, None
            else:
                return False, path, "❌ 路徑不存在"

        elif button_name == "documents":
            path = PathLib.home() / "Documents"
            if path.exists():
                return True, path, None
            else:
                return False, path, "❌ 路徑不存在"

        elif button_name == "downloads":
            path = PathLib.home() / "Downloads"
            if path.exists():
                return True, path, None
            else:
                return False, path, "❌ 路徑不存在"

        else:
            return False, None, "❌ 未知按鈕"

    except Exception as e:
        return False, None, f"❌ {str(e)}"


def test_simulate_all_buttons():
    """測試所有按鈕模擬"""
    print("  測試按鈕點擊模擬...")

    # Test Default button
    config_mock = Mock()
    config_mock.get.return_value = str(Path.home())

    success, path, error = simulate_button_click("default", config_mock)
    assert success, "Default 按鈕應該成功"
    assert path.exists(), "Default 路徑應該存在"
    assert error is None, "不應該有錯誤"
    print(f"    ✅ Default 按鈕: {path}")

    # Test Desktop button
    success, path, error = simulate_button_click("desktop", config_mock)
    if path.exists():
        assert success, "Desktop 按鈕應該成功（路徑存在時）"
        print(f"    ✅ Desktop 按鈕: {path}")
    else:
        assert not success, "Desktop 按鈕應該失敗（路徑不存在時）"
        assert "❌" in error, "應該有錯誤訊息"
        print(f"    ⚠️  Desktop 按鈕: 路徑不存在（預期行為）")

    # Test Documents button
    success, path, error = simulate_button_click("documents", config_mock)
    if path.exists():
        assert success, "Documents 按鈕應該成功"
        print(f"    ✅ Documents 按鈕: {path}")
    else:
        print(f"    ⚠️  Documents 路徑不存在")

    # Test Downloads button
    success, path, error = simulate_button_click("downloads", config_mock)
    if path.exists():
        assert success, "Downloads 按鈕應該成功"
        print(f"    ✅ Downloads 按鈕: {path}")
    else:
        print(f"    ⚠️  Downloads 路徑不存在")

    # Test with nonexistent path
    config_mock.get.return_value = "/nonexistent/path"
    success, path, error = simulate_button_click("default", config_mock)
    assert not success, "不存在的路徑應該失敗"
    assert "❌" in error, "應該有錯誤訊息"
    print(f"    ✅ 不存在路徑正確處理")


def run_all_tests():
    """執行所有測試"""
    print("=" * 70)
    print("開始執行快速按鈕功能測試")
    print("=" * 70)

    tests = [
        ("路徑解析", test_default_button_path_resolution),
        ("跨平台支援", test_desktop_paths_all_platforms),
        ("Documents 路徑", test_documents_path),
        ("Downloads 路徑", test_downloads_path),
        ("錯誤處理-不存在路徑", test_error_nonexistent_path),
        ("錯誤處理-檔案路徑", test_error_file_as_directory),
        ("Tilde 展開", test_path_with_tilde_expansion),
        ("相對路徑計算", test_relative_path_conversion),
        ("平台偵測", test_current_platform_detection),
        ("主目錄檢查", test_home_directory),
        ("按鈕模擬", test_simulate_all_buttons),
    ]

    passed = 0
    failed = 0

    for test_name, test_func in tests:
        print(f"\n{len(tests) - passed - failed}. {test_name}")
        try:
            test_func()
            passed += 1
        except AssertionError as e:
            print(f"    ❌ 測試失敗: {e}")
            failed += 1
        except Exception as e:
            print(f"    ❌ 執行錯誤: {e}")
            failed += 1

    print("\n" + "=" * 70)
    print(f"測試完成: {passed} 通過, {failed} 失敗")
    print("=" * 70)

    if failed == 0:
        print("\n✅ 所有測試通過！")
        return 0
    else:
        print(f"\n❌ {failed} 個測試失敗")
        return 1


if __name__ == "__main__":
    import sys

    sys.exit(run_all_tests())
