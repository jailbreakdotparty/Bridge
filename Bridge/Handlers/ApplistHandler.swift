//
//  ApplistHandler.swift
//  Bridge
//
//  Created by Main on 11/5/25.
//

import SwiftUI
import Combine

func processAppList(clipboardContents: String, completion: @escaping (_ applistProcessed: Bool) -> Void) {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @Environment(\.openURL) var openURL
    
    if clipboardContents.isEmpty || !clipboardContents.contains("CoreServices") {
        Alertinator.shared.alert(title: "Error!", body: "An applist was not generated properly, or no applist was generated at all.", actionLabel: "Re-Run Shortcut", action: {
            openURL(URL(string: "shortcuts://run-shortcut?name=Bridge")!)
        })
    } else {
        let rawAppList = clipboardContents.components(separatedBy: "\n")
        for item in rawAppList {
            let parts = item.components(separatedBy: "?")
            let appName = parts.first ?? ""
            let partitionType = parts.last ?? ""
            if partitionType == "CoreServices" {
                secondaryPartitionAppList.append(item)
            } else {
                mainPartitionAppList.append(item)
            }
        }
        completion(true)
    }
}

func displayAppName(item: String) -> String {
    let parts = item.components(separatedBy: "?")
    let appName = parts.first ?? ""
    return appName
}

func isApplicationInMainPartition(item: String) -> Bool {
    let parts = item.components(separatedBy: "?")
    let appName = parts.last ?? ""
    
    if appName == "Applications" {
        return true
    } else {
        return false
    }
}

let debugApplist = "App1?Applications\nApp2?Applications\nApp3?Applications\nApp1?CoreServices\nApp2?CoreServices\nApp3?CoreServices"
let staticApplist = "AAUIViewService?Applications\nAccessibilityReader_iOS?Applications\nAccessibilityUIServer?CoreServices\nAccessorySetupUI?Applications\nAccountAuthenticationDialog?Applications\nActivityMessagesApp?Applications\nActivityProgressUI?Applications\nAdaptiveMusicApp?Applications\nAegirProxyApp?CoreServices\nAirDropUI?Applications\nAirPlay Receiver?Applications\nAirPlaySenderUIApp?Applications\nAMSEngagementViewService?Applications\nAMSUIAuthenticationViewService?Applications\nAnimojiStickers?Applications\nAppDeletionUIHost?Applications\nAppDistributionLaunchAngel?Applications\nAppleIDSetupUIService?Applications\nAppProtectionUIHost?Applications\nAppSSOUIService?Applications\nAskPermissionUI?Applications\nAskToUIHost?Applications\nAssistiveTouch?CoreServices\nAuthenticationServicesUI?Applications\nAuthKitUIService?Applications\nAVKitRoutingService?Applications\nAXRemoteViewService?Applications\nAXUIViewService?Applications\nBacklinkIndicator?Applications\nBarcodeScanner?Applications\nBatteries?Applications\nBluetoothUIService?CoreServices\nBusinessChatViewService?Applications\nBusinessExtensionsWrapper?Applications\nCameraOverlayAngel?Applications\nCarCamera?Applications\nCarPlay?CoreServices\nCarPlaySettings?Applications\nCarPlaySetup?Applications\nCarPlaySplashScreen?Applications\nCarPlayTemplateUIHost?CoreServices\nCarPlayWallpaper?Applications\nCharge?Applications\nCheckerBoard?Applications\nCheckerBoardRemoteSetup?Applications\nClarityBoard?CoreServices\nClarityCamera?Applications\nClarityPhotos?Applications\nClimate?Applications\nClipViewService?Applications\nClockAngel?Applications\nClosures?Applications\nColorPickerUIService?Applications\ncom.apple.launchservices.lsd?CoreServices\nCommandAndControl?CoreServices\nCompanionViewService?Applications\nCompassCalibrationViewService?Applications\nContactPhotoCarouselRemoteAlert?Applications\nContinuityCaptureShieldUI?Applications\nContinuitySingShieldUI?Applications\nCoreAuthUI?Applications\nCoreIDVUIService?Applications\nCoverage Details?Applications\nCredentialSharingUIViewService?Applications\nCTCarrierSpaceAuth?Applications\nCTKUIService?Applications\nCTNotifyUIService?Applications\nDDActionsService?Applications\nDemoApp?Applications\nDevice Recovery Assistant?Applications\nDeviceOMatic?CoreServices\nDiagnostics?Applications\nDiagnosticsReporter?Applications\nDiagnosticsService?Applications\nDisplayCal?Applications\nDKPairingUIService?Applications\nDockFolderViewService?Applications\nEscrowSecurityAlert?CoreServices\nEventViewService?Applications\nExposureNotificationRemoteViewService?Applications\nEyeReliefUI?Applications\nFaceTimeLinkTrampoline?Applications\nFamily?Applications\nFamilyControlsAuthenticationUI?Applications\nFamilyExtensionHost?Applications\nFeedback Assistant iOS?Applications\nFeedbackRemoteView?Applications\nFinanceStub?Applications\nFinanceUIService?Applications\nFindMyExtensionContainer?Applications\nFindMyRemoteUIService?Applications\nFMDMagSafeSetupRemoteUI?Applications\nFontInstallViewService?Applications\nFontPickerUIService?Applications\nFTMInternal?Applications\nFullKeyboardAccess?CoreServices\nGameCenterRemoteAlert?Applications\nGameCenterUIService?Applications\nGameCenterWidgets?Applications\nGameOverlayUI?CoreServices\nGameTrampoline?Applications\nGAXApp?Applications\nGuestUserHandoverSetup?Applications\nHangHUD?CoreServices\nHashtagImages?Applications\nHDSViewService?Applications\nHeadphoneProxService?Applications\nHealthENBuddy?Applications\nHealthENLauncher?Applications\nHealthPrivacyService?Applications\nHearingApp?Applications\nHomeCaptiveViewService?Applications\nHomeControlService?Applications\nHomeUIService?Applications\niCloud?Applications\niCloud+?Applications\niMessageAppsViewService?Applications\nInCallService?Applications\nInputUI?Applications\nIntelligentLight?CoreServices\nIOUIAngel?CoreServices\nJellyfish?Applications\nLimitedAccessPromptView?Applications\nLiveTranscriptionUI?CoreServices\nLocalAuthenticationUIService?Applications\nMagnifierAngel?Applications\nMailCompositionService?Applications\nMBHelperApp?Applications\nMedia?Applications\nMediaRemoteUI?Applications\nMediaRemoteUIService?Applications\nMessagesViewService?Applications\nMobilePhone?Applications\nMobileReplayer?Applications\nMomentsUIService?Applications\nMTLReplayer?Applications\nMusicKitUI?CoreServices\nMusicRecognition?Applications\nMusicUIService?Applications\nMXUIServiceApp?Applications\nNetworkEndpointPickerUI?Applications\nNewDeviceSetupUIService?Applications\nNFCUISceneService?Applications\nOTEAutomationTest?Applications\nOverlayUI?CoreServices\nPassbookSecureUIService?Applications\nPassbookUISceneService?Applications\nPassbookUIService?Applications\nPASViewService?Applications\nPCViewService?Applications\nPDUIApp?Applications\nPeopleMessageService?Applications\nPeopleViewService?Applications\nPhotosUIService?Applications\nPosterBoard?Applications\nPreBoard?Applications\nPreferences?Applications\nPreviewShell?Applications\nPrint Center?Applications\nProductKitViewer?Applications\nProximityReaderSceneUI?Applications\nProximityReaderUIService?Applications\nRecoverDeviceUI?Applications\nRemoteiCloudQuotaUI?Applications\nRemotePaymentPassActionsService?Applications\nRepairCal?Applications\nReplayKitAngel?Applications\nSafariViewService?Applications\nSafetyMonitorApp?Applications\nScreen Time?Applications\nScreenContinuityShell?Applications\nScreenSharingServer?CoreServices\nScreenSharingViewService?Applications\nScreenshotServicesService?Applications\nScreenTimeUnlock?Applications\nSESUIServiceApp?Applications\nSetup?Applications\nSharedWebCredentialViewService?Applications\nSharingUIService?Applications\nSharingViewService?Applications\nShazamEventsApp?Applications\nShortcutsActions?CoreServices\nShortcutsUI?Applications\nShortcutsViewService?Applications\nSidecar?Applications\nSIMSetupUIService?Applications\nSiri?Applications\nSleepLockScreen?Applications\nSleepWidgetContainer?Applications\nSLYahooAuth?Applications\nSoftwareUpdateUIService?Applications\nSOSBuddy?Applications\nSpotlight?Applications\nSpringBoard?CoreServices\nSpringBoardEducation?Applications\nStickerPickerService?Applications\nStickersUltra?Applications\nStoreDemoViewService?Applications\nStoreKitUISceneService?Applications\nStoreKitUIService?Applications\nSubcredentialUIService?Applications\nSupportFlow?Applications\nSystemActions?Applications\nSystemPaperViewService?Applications\nTDGSharingViewService?Applications\nText Message Filter?Applications\nTirePressure?Applications\nTransfer to Android?Applications\nTrip?Applications\nTrustMe?Applications\nTVAccessViewService?Applications\nTVRemoteUIService?Applications\nTVSetupUIService?Applications\nVehicle?Applications\nVideoSubscriberAccountViewService?Applications\nVoiceOverTouch?CoreServices\nWeb?Applications\nWebContentRestrictionsUI?Applications\nWebSheet?Applications\nWidgetRenderer_Activities?Applications\nWidgetRenderer_CarPlay?Applications\nWidgetRenderer_Default?Applications\nWidgetRenderer_WatchFaces?Applications\nWorkoutRemoteViewService?Applications\nWritingToolsUIService?Applications"
