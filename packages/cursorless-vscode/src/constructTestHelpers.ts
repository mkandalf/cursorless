import {
  CommandServerApi,
  ExcludableSnapshotField,
  ExtraSnapshotField,
  HatTokenMap,
  IDE,
  NormalizedIDE,
  ScopeProvider,
  SerializedMarks,
  StoredTargetKey,
  TargetPlainObject,
  TestCaseSnapshot,
  TextEditor,
} from "@cursorless/common";
import {
  StoredTargetMap,
  plainObjectToTarget,
  takeSnapshot,
} from "@cursorless/cursorless-engine";
import { TestHelpers } from "@cursorless/vscode-common";
import * as vscode from "vscode";
import { VscodeIDE } from "./ide/vscode/VscodeIDE";
import { toVscodeEditor } from "./ide/vscode/toVscodeEditor";
import { vscodeApi } from "./vscodeApi";
import { VscodeFileSystem } from "./ide/vscode/VscodeFileSystem";

export function constructTestHelpers(
  commandServerApi: CommandServerApi | null,
  storedTargets: StoredTargetMap,
  hatTokenMap: HatTokenMap,
  vscodeIDE: VscodeIDE,
  normalizedIde: NormalizedIDE,
  fileSystem: VscodeFileSystem,
  scopeProvider: ScopeProvider,
  injectIde: (ide: IDE) => void,
  runIntegrationTests: () => Promise<void>,
): TestHelpers | undefined {
  return {
    commandServerApi: commandServerApi!,
    ide: normalizedIde,
    injectIde,
    scopeProvider,

    toVscodeEditor,

    // FIXME: Remove this once we have a better way to get this function
    // accessible from our tests
    takeSnapshot(
      excludeFields: ExcludableSnapshotField[],
      extraFields: ExtraSnapshotField[],
      editor: TextEditor,
      ide: IDE,
      marks: SerializedMarks | undefined,
      forceRealClipboard: boolean,
    ): Promise<TestCaseSnapshot> {
      return takeSnapshot(
        storedTargets,
        excludeFields,
        extraFields,
        editor,
        ide,
        marks,
        undefined,
        undefined,
        forceRealClipboard ? vscodeIDE.clipboard : undefined,
      );
    },

    cursorlessTalonStateJsonPath: fileSystem.cursorlessTalonStateJsonPath,
    cursorlessCommandHistoryDirPath: fileSystem.cursorlessCommandHistoryDirPath,

    setStoredTarget(
      editor: vscode.TextEditor,
      key: StoredTargetKey,
      targets: TargetPlainObject[] | undefined,
    ): void {
      storedTargets.set(
        key,
        targets?.map((target) =>
          plainObjectToTarget(vscodeIDE.fromVscodeEditor(editor), target),
        ),
      );
    },
    hatTokenMap,
    runIntegrationTests,
    vscodeApi,
  };
}
