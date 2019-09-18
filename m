Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFB4C4CEC4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DAD2067B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tWwztvrQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfIROYX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:24:23 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:55497 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729768AbfIROYX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 10:24:23 -0400
Received: by mail-wm1-f53.google.com with SMTP id a6so300065wma.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 07:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBYsA8Ck/cWefGhdXXIj6TfpObBg8c+Yz3+UuH7d+GM=;
        b=tWwztvrQPGxqCBJhGBPg9Kv7uAepBTjtg7UU3xVqJzgQNE5FRpcZinkTOtIlspd4qR
         kwxD3LJLr8HRto1OkU2+alhgAhPz5UAURzhxIlxGMzGDqzw4Ppio6VNb6niiPiou8cr9
         Sl/nZrx1uYyF8UsVNKSbUUDAEsPju6d4QL79e9kesb9JssLZ+sXMuKpBmTLb3lgmuldw
         xtiUrlX7JemtJpY9OVUCM2XCvr+TyKlwIpwRSbsXEV1+8Xv+S5QzR81nhjB1OGZNbBnG
         eUitQ/sxPb9BhB1eHqjoww0gl+Q7b62O6EA3d5EMGMV0NBokHHQgO70K02i557/x6xHj
         kqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBYsA8Ck/cWefGhdXXIj6TfpObBg8c+Yz3+UuH7d+GM=;
        b=T7f5rf4j034xw+6KBTTe6OxSXEReH2nu9DmIKKJbCoTaVfQeMc2qVXV3EyH8lBse+z
         IRmRZM6WA/Kvo8yG51oBEfIcoodpqjF0QrM065QErK8y/WMESmUPzc1xB3O/NkBfhYBv
         u9otHxBH3hPOPyv490CHrzEvaBjUcVJqMKjLJsfKifRuY1hgY02RQ+IYX/7i/KJVqXkI
         32Fear68SD0lpD69TKx36EhwC8oW7663G3j56FV2Jy/iRL9X4WfaFE+rf6qS/JdIEtud
         68+HEm2Ti+Kg8xaS0VZDcUrCyVhD/A5FaKMxm1aU0Ke+adDuAbKRBALlXS9txpV0t42+
         ZqYw==
X-Gm-Message-State: APjAAAW68zFnELT90smafICXI2Vex1EGwcUfAAfzctcdmUvWZpstWuJH
        wTZxaxfIDdtTSzKTYgSk0oE=
X-Google-Smtp-Source: APXvYqw72p4QZRCgWUEk9CafPaay7G2LDFF+siWHjO02kwlqTN/Mr8LrUCYvMOkWZknFlO5dd3cjxQ==
X-Received: by 2002:a7b:cc0e:: with SMTP id f14mr3111893wmh.42.1568816661741;
        Wed, 18 Sep 2019 07:24:21 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7526251wrv.64.2019.09.18.07.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 07:24:21 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark: Add quotation marks parsing example/test
Date:   Wed, 18 Sep 2019 17:23:19 +0300
Message-Id: <20190918142319.11821-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190918142319.11821-1-y.karadz@gmail.com>
References: <20190918142319.11821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The example implements a small GUI that executes shell commands.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/examples/CMakeLists.txt |  4 +++
 kernel-shark/examples/cmd_split.cpp  | 52 ++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100644 kernel-shark/examples/cmd_split.cpp

diff --git a/kernel-shark/examples/CMakeLists.txt b/kernel-shark/examples/CMakeLists.txt
index e16216e..35e6b1e 100644
--- a/kernel-shark/examples/CMakeLists.txt
+++ b/kernel-shark/examples/CMakeLists.txt
@@ -23,3 +23,7 @@ target_link_libraries(dplot   kshark-plot)
 message(STATUS "widgetdemo")
 add_executable(widgetdemo          widgetdemo.cpp)
 target_link_libraries(widgetdemo   kshark-gui)
+
+message(STATUS "cmd_split")
+add_executable(cmd_split           cmd_split.cpp)
+target_link_libraries(cmd_split    kshark-gui)
diff --git a/kernel-shark/examples/cmd_split.cpp b/kernel-shark/examples/cmd_split.cpp
new file mode 100644
index 0000000..ac68844
--- /dev/null
+++ b/kernel-shark/examples/cmd_split.cpp
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+// C++
+#include<iostream>
+using namespace std;
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "KsUtils.hpp"
+
+int main(int argc, char **argv)
+{
+	QString text = "echo \"I want \\\" here\" \\\n \"and \\\' here\"";
+	QApplication a(argc, argv);
+	QStringList argList;
+	bool ok = true;
+	QProcess proc;
+
+	while (ok) {
+		text = QInputDialog::getMultiLineText(nullptr,
+						      "Shell quoting test",
+						      "Shell input:",
+						      text,
+						      &ok);
+
+		if (ok) {
+			argList = KsUtils::splitArguments(text);
+			qInfo() << argList;
+
+			proc.setProgram(argList.takeFirst());
+			proc.setArguments(argList);
+
+			proc.start();
+			proc.waitForFinished();
+
+			cout << proc.errorString().toStdString()
+			     << endl
+			     << proc.readAllStandardError().toStdString()
+			     << endl
+			     << proc.readAllStandardOutput().toStdString()
+			     << endl;
+		}
+	}
+
+	return 0;
+}
-- 
2.20.1

