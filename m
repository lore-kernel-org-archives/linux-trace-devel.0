Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2B7C47247
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C867214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeQvWOfR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgEHPX0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 11:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEHPXZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 11:23:25 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C1CC061A0C
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 08:23:25 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id e25so2076040ljg.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 08:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UUXxr+xgbcEYOkT1di2VL8kwLKqLNzPMA1snU9UZn0g=;
        b=PeQvWOfRvgckCjluk8nrJIeFE7fIVCZu9kN+H/8PfPHq3Qo4B01RaFlrLRMfL23Bms
         1N6JsNvsoGKE9ef5soseC9lA78OI3hy6Vx/npcVS85WcmP9DoTMXstIB1L/SDbBW9MwB
         e1lO8+ZolLWaukw3LP0qc5M7FQoT+7YqnM89q1TW5zQBMESjH1fnkbPgcv/TumQyPY8k
         tyYxnWG30CwaO4bE5RZlGQ6AlH5hBJ9uWpKHS5pf2jFHylrLbopiRMnazgFe3zQLm0NW
         sRY73sasz8XsZJvRxHq/kAqPgUlDjkKU9zpTeR/slaLXc7iNZWemZWDQwVPEZE65ozYi
         /47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UUXxr+xgbcEYOkT1di2VL8kwLKqLNzPMA1snU9UZn0g=;
        b=j1rQo7dZ7zKa2LqIRNaB6eMxFrS7NXp1dVr44MA2B8yeRf6ehjn4ZITnDqM965Ki7n
         /NFw5AxluKaKg1yg+3g/ICw6+euzY/7o3e/IXDcfVK7JCHX/GBXTC1lMbxYhEbJJots6
         ufjcCj9+zCxIAgiT6tLj+K5D5ta6VdB09O+1xhoM4b5HhiTJjcs0PGCGuDODdQifaU+A
         EFYR6Qr55SsTApqP5WwcTDA+nCqjcT9j+20QGGYKZrjHTCypUiUPeAzsmt7k0DyXWKgp
         fnTvnVzMVh+9hN2Lw6xHK4FKDldvu07IdZB4Gk4RC/arUBWxCPA0pLmCKB5KD45xAKN1
         YhnQ==
X-Gm-Message-State: AOAM533McymuYoYCBL1GMZyn+aHjb+BaFGqzOc3+neSljYvvqRkD0EHt
        DFxcHe2+aDomK0C20BLCUp4=
X-Google-Smtp-Source: ABdhPJwqOBwXcHGu7peZd8CplY6d5JTaQEYyLuGWKOqzOukfR6bUgLa3gquMY7xQMGm9aMRPAoOptA==
X-Received: by 2002:a2e:a311:: with SMTP id l17mr2092894lje.106.1588951403849;
        Fri, 08 May 2020 08:23:23 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id q20sm1466497lfm.35.2020.05.08.08.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:23:23 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH v3 2/3] kernel-shark: Add command line options for selecting plots to be shown
Date:   Fri,  8 May 2020 18:23:01 +0300
Message-Id: <20200508152302.27843-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200508152302.27843-1-y.karadz@gmail.com>
References: <20200508152302.27843-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example:
  kernelshark -i mytrace.dat --cpu '1,4-7' --pid 11

This will show CPUs: 1, 4, 5, 6, 7 and task(PID): 11.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Suggested-by: Julia Lawall  <julia.lawall@inria.fr>
---
 kernel-shark/src/KsUtils.cpp     | 24 +++++++++++++++++++
 kernel-shark/src/KsUtils.hpp     |  2 ++
 kernel-shark/src/kernelshark.cpp | 41 +++++++++++++++++++++++++++++---
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 77d0c7c..8c61b3f 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -336,6 +336,30 @@ QStringList splitArguments(QString cmd)
 	return argv;
 }
 
+/** Parse a string containing Ids. The string can be of the form "1 4-7 9". */
+QVector<int> parseIdList(QString v_str)
+{
+	QStringList list = v_str.split(",", QString::SkipEmptyParts);
+	QVector<int> v;
+
+	for (auto item: list) {
+		int i = item.indexOf('-');
+		if (i > 0) {
+			/* This item is an interval. */
+			int to = item.right(item.size() - i - 1).toInt();
+			int from = item.left(i).toInt();
+			int s = v.size();
+
+			v.resize(s + to - from + 1);
+			std::iota(v.begin() + s, v.end(), from);
+		} else {
+			v.append(item.toInt());
+		}
+	}
+
+	return v;
+}
+
 }; // KsUtils
 
 /** A stream operator for converting QColor into KsPlot::Color. */
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index f44139b..8293e7d 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -136,6 +136,8 @@ QString getSaveFile(QWidget *parent,
 
 QStringList splitArguments(QString cmd);
 
+QVector<int> parseIdList(QString v_str);
+
 }; // KsUtils
 
 /** Identifier of the Dual Marker active state. */
diff --git a/kernel-shark/src/kernelshark.cpp b/kernel-shark/src/kernelshark.cpp
index 1ec6678..0de80af 100644
--- a/kernel-shark/src/kernelshark.cpp
+++ b/kernel-shark/src/kernelshark.cpp
@@ -29,20 +29,43 @@ void usage(const char *prog)
 	printf("  -u	unregister plugin, use plugin name or absolute path\n");
 	printf("  -s	import a session\n");
 	printf("  -l	import the last session\n");
+	puts(" --cpu	show plots for CPU cores, default is \"show all\"");
+	puts(" --pid	show plots for tasks, default is \"do not show\"");
+	puts("\n example:");
+	puts("  kernelshark -i mytrace.dat --cpu 1,4-7 --pid 11 -p path/to/my/plugin/myplugin.so\n");
 }
 
+#define KS_LONG_OPTS 0
+static option longOptions[] = {
+	{"help", no_argument, nullptr, 'h'},
+	{"pid", required_argument, nullptr, KS_LONG_OPTS},
+	{"cpu", required_argument, nullptr, KS_LONG_OPTS},
+	{nullptr, 0, nullptr, 0}
+};
+
 int main(int argc, char **argv)
 {
 	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
 	QApplication a(argc, argv);
 
+	QVector<int> cpuPlots, taskPlots;
+	bool fromSession = false;
+	int optionIndex = 0;
 	KsMainWindow ks;
-
 	int c;
-	bool fromSession = false;
 
-	while ((c = getopt(argc, argv, "hvi:p:u:s:l")) != -1) {
+	while ((c = getopt_long(argc, argv, "hvi:p:u:s:l",
+					    longOptions,
+					    &optionIndex)) != -1) {
 		switch(c) {
+		case KS_LONG_OPTS:
+			if (strcmp(longOptions[optionIndex].name, "cpu") == 0)
+				cpuPlots.append(KsUtils::parseIdList(QString(optarg)));
+			else if (strcmp(longOptions[optionIndex].name, "pid") == 0)
+				taskPlots.append(KsUtils::parseIdList(QString(optarg)));
+
+			break;
+
 		case 'h':
 			usage(argv[0]);
 			return 0;
@@ -95,6 +118,18 @@ int main(int argc, char **argv)
 			ks.loadDataFile(QString(input_file));
 	}
 
+	auto lamOrderIds = [] (QVector<int> &ids) {
+		/* Sort and erase duplicates. */
+		std::sort(ids.begin(), ids.end());
+		ids.erase(std::unique(ids.begin(), ids.end()), ids.end());
+		return ids;
+	};
+
+	if (cpuPlots.count() || taskPlots.count()) {
+		ks.setCPUPlots(lamOrderIds(cpuPlots));
+		ks.setTaskPlots(lamOrderIds(taskPlots));
+	}
+
 	ks.show();
 	return a.exec();
 }
-- 
2.20.1

