import GhosttyKit
#if canImport(AppKit) && !canImport(UIKit)
    import AppKit
#endif
@testable import GhosttyTerminal
import Testing

#if canImport(AppKit) && !canImport(UIKit)
    struct TerminalAppKitKeyInputTests {
        @Test
        func shiftEnterPreservesShiftForKeybindingMatching() throws {
            let event = try makeKeyEvent(
                modifierFlags: [.shift],
                characters: "\r",
                charactersIgnoringModifiers: "\r",
                keyCode: 0x24
            )
            let input = event.buildKeyInput(
                action: GHOSTTY_ACTION_PRESS,
                translationModifiers: event.modifierFlags
            )

            #expect(input.mods.rawValue & GHOSTTY_MODS_SHIFT.rawValue != 0)
            #expect(input.consumed_mods.rawValue & GHOSTTY_MODS_SHIFT.rawValue == 0)
        }

        @Test
        func shiftTabPreservesShiftForKeybindingMatching() throws {
            let event = try makeKeyEvent(
                modifierFlags: [.shift],
                characters: "\t",
                charactersIgnoringModifiers: "\t",
                keyCode: 0x30
            )
            let input = event.buildKeyInput(
                action: GHOSTTY_ACTION_PRESS,
                translationModifiers: event.modifierFlags
            )

            #expect(input.mods.rawValue & GHOSTTY_MODS_SHIFT.rawValue != 0)
            #expect(input.consumed_mods.rawValue & GHOSTTY_MODS_SHIFT.rawValue == 0)
        }

        @Test
        func shiftedPrintableTextStillConsumesShift() throws {
            let event = try makeKeyEvent(
                modifierFlags: [.shift],
                characters: "A",
                charactersIgnoringModifiers: "a",
                keyCode: 0x00
            )
            let input = event.buildKeyInput(
                action: GHOSTTY_ACTION_PRESS,
                translationModifiers: event.modifierFlags
            )

            #expect(input.mods.rawValue & GHOSTTY_MODS_SHIFT.rawValue != 0)
            #expect(input.consumed_mods.rawValue & GHOSTTY_MODS_SHIFT.rawValue != 0)
        }

        private func makeKeyEvent(
            modifierFlags: NSEvent.ModifierFlags,
            characters: String,
            charactersIgnoringModifiers: String,
            keyCode: UInt16
        ) throws -> NSEvent {
            try #require(
                NSEvent.keyEvent(
                    with: .keyDown,
                    location: .zero,
                    modifierFlags: modifierFlags,
                    timestamp: 1,
                    windowNumber: 0,
                    context: nil,
                    characters: characters,
                    charactersIgnoringModifiers: charactersIgnoringModifiers,
                    isARepeat: false,
                    keyCode: keyCode
                )
            )
        }
    }
#endif
