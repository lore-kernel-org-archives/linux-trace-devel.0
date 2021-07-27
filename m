Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A529BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 879F761A87
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbhG0Nml (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 09:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbhG0Nml (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 09:42:41 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515ACC061760
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:42:41 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id g15so15304853wrd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L87eVHcjD4boJXwtqTgjpMO7ctPkMtX7TpeO7uWVwpI=;
        b=vLyEbN4G7MPGrBcm5D3XkoKlJCsR0aRyQMxOQZxAHgSe9uDfrddYDzobKcFTPk6LpS
         ySBDZ1g/EwC3SUDiKvznHxk35NFbNALB8NskeTKqTZBEem6Bp1PsCfi5/FOJDsMqJe5E
         EkHgCW/5rS2WGTnFb0c3lNkUEG9s+OkBfCvZoCe/Ygn0+bkTMRJ4cWT+MwF9idpoicaa
         NfuuE4qVXzWWDD0VQbYa2mmykVKIsHTOgDtXEdSBIBL6CQKX64eKOIdnz2iHHnFA6pUe
         wqc4NHnmDrBNvw/kyFC71HJa7t0B29bFN02fiy2LTOU7Ev4liV1B1T1wU7bf7+l/9fga
         1HTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L87eVHcjD4boJXwtqTgjpMO7ctPkMtX7TpeO7uWVwpI=;
        b=NTcjY/63+YeHonx+EKMxh1lEv9CDHKI3fPgTIzpFysPVgYaaS+14xWOZHVUuNgD8H+
         a6H1w4SDQm9As0WjuZmvOLI06MHsT3zf5fsD8VIQStoNWsVlcHMNWzCt2gUNJkqDgP2+
         3knCoT/Xpb7CMGa/nsKBICuuG17rA8ogNp/ma+591kaD5i2USpWvS1wYwwKphvFDh08z
         0ashXK4xlCDpCuXTLHSScwKIzC1fEyaHquJlJ3DYOCEvEGa8ggOcbf//kE1LYaaxv7mi
         aOSEm0M2qkELvRoJtJ1cQbUoLZO/Gx9Pd/8e3eaelmE/QiEVKucrgUb77x/EcwhnMq+B
         f2hQ==
X-Gm-Message-State: AOAM531Qt8T+sUFLc5D8M9T/+xqhAyMlB/uNaCOdJMc9lCWoXSLDFsK1
        Sl0PGdakvSrpUVKzMe0HoCxT83NZVkg=
X-Google-Smtp-Source: ABdhPJzyrR5pXSDntJpZSwK8xTZq+baFxYy2kd++Vm0wqO+7+a8MYkeSuT7K0i08DvcPsyIqmpQUdw==
X-Received: by 2002:a5d:4348:: with SMTP id u8mr21826123wrr.28.1627393359766;
        Tue, 27 Jul 2021 06:42:39 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id i7sm3500667wre.64.2021.07.27.06.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 06:42:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Fix warnings from deprecated Qt APIs
Date:   Tue, 27 Jul 2021 16:42:25 +0300
Message-Id: <20210727134225.25025-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727134225.25025-1-y.karadz@gmail.com>
References: <20210727134225.25025-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Couple of APIs used by KernelShark have been marked as deprecated
in the recent version of Qt. Fix all compilation warnings caused
by the usage of these deprecated APIs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt      |  6 ++++++
 build/deff.h.cmake  |  1 +
 src/KsGLWidget.cpp  | 12 ++++++++++--
 src/KsUtils.cpp     |  6 +++---
 src/KsUtils.hpp     | 10 ++++++++++
 src/kernelshark.cpp |  2 +-
 6 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 67dfb81..c2c0983 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -83,6 +83,12 @@ if (Qt5Widgets_FOUND)
 
     endif()
 
+    if(Qt5Widgets_VERSION VERSION_LESS "5.15")
+
+        set(QT_VERSION_LESS_5_15 TRUE)
+
+    endif()
+
 endif (Qt5Widgets_FOUND)
 
 find_package (Boost COMPONENTS unit_test_framework)
diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 06cbf16..82379df 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -31,6 +31,7 @@
 
 /** Qt - old version detected. */
 #cmakedefine QT_VERSION_LESS_5_11
+#cmakedefine QT_VERSION_LESS_5_15
 
 /** Location of the KernelShark tests. */
 #cmakedefine KS_TEST_DIR "@KS_TEST_DIR@"
diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 8aab7b3..3b2e0d4 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -345,10 +345,18 @@ void KsGLWidget::wheelEvent(QWheelEvent * event)
 		 * Use the position of the mouse as a focus point for the
 		 * zoom.
 		 */
-		zoomFocus = event->pos().x() - _bin0Offset();
+#ifdef QT_VERSION_LESS_5_15
+
+	zoomFocus = event->pos().x() - _bin0Offset();
+
+#else
+
+	zoomFocus = event->position().x() - _bin0Offset();
+
+#endif // QT_VERSION_LESS_5_15
 	}
 
-	if (event->delta() > 0) {
+	if (event->angleDelta().y() > 0) {
 		_model.zoomIn(.05, zoomFocus);
 	} else {
 		_model.zoomOut(.05, zoomFocus);
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 3db8951..364c25d 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -486,7 +486,7 @@ QString getSaveFile(QWidget *parent,
  */
 QStringList splitArguments(QString cmd)
 {
-	QString::SplitBehavior opt = QString::SkipEmptyParts;
+	auto opt = KS_SPLIT_SkipEmptyParts;
 	int i, progress = 0, size;
 	QStringList argv;
 	QChar quote = 0;
@@ -527,7 +527,7 @@ QStringList splitArguments(QString cmd)
  */
 QVector<int> parseIdList(QString v_str)
 {
-	QStringList list = v_str.split(",", QString::SkipEmptyParts);
+	QStringList list = v_str.split(",", KS_SPLIT_SkipEmptyParts);
 	QVector<int> v;
 
 	for (auto item: list) {
@@ -553,7 +553,7 @@ QVector<int> parseIdList(QString v_str)
  */
 QMap<int, QVector<int>> parseTaskList(QString v_str)
 {
-	QStringList taskList = v_str.split(",", QString::SkipEmptyParts);
+	QStringList taskList = v_str.split(",", KS_SPLIT_SkipEmptyParts);
 	QVector<int> streamIds, allPids;
 	kshark_context *kshark_ctx(nullptr);
 	QMap<int, QVector<int>> ret;
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index cf209bc..1a97d9e 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -86,6 +86,16 @@ typedef std::chrono::high_resolution_clock::time_point  hd_time;
 std::chrono::duration_cast<std::chrono::duration<double>>( \
 std::chrono::high_resolution_clock::now() - t0).count()
 
+#ifdef QT_VERSION_LESS_5_15
+
+	#define KS_SPLIT_SkipEmptyParts QString::SkipEmptyParts
+
+#else
+
+	#define KS_SPLIT_SkipEmptyParts Qt::SkipEmptyParts
+
+#endif // QT_VERSION_LESS_5_15
+
 //! @endcond
 
 namespace KsUtils {
diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index 8ed4948..92bc1f1 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -87,7 +87,7 @@ int main(int argc, char **argv)
 			break;
 
 		case 'a':
-			appInputFiles << QString(optarg).split(" ", QString::SkipEmptyParts);
+			appInputFiles << QString(optarg).split(" ", KS_SPLIT_SkipEmptyParts);
 			break;
 
 		case 'p':
-- 
2.30.2

