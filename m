Return-Path: <SRS0=eYsA=6L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DE1C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC83206B6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhB6njL9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgD0PmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728032AbgD0PmU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 11:42:20 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2601C0610D5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:19 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id l19so18075342lje.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4C24MlcI+zyJupm/LhxK9ybhVXtpl+GwOndMUrVxfbA=;
        b=LhB6njL9hxz7KHBvB5kvDt7rM2QYQhi8FiKLZsL5o0R9d8qIRHmEDoVXyqM476osUV
         unsdi588O9x5WFy+r18wLl2tHql99M6WwIPYbK7/Mg50abjcVsmhcoRHOe+DN73ePfLt
         VIZ4ZjCwXT9C+OcJtuJCDb8r0ZeeLqSpXUE+IIxlIcJ4l7hAH8E8UpddcyjdVi+kuttR
         J0PSUOlgKDubkW8ipCFNi8xHTcsedGCmaA2XPhQQ+ff9WfTVC1KSTsyR1For5CJD8tMC
         UNAF2yqG1gP4YjkNf96adgAn99Ou9SWG7MRwRVhSg7xYw6YTBnttgBvfLz0lVAK54csY
         KILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4C24MlcI+zyJupm/LhxK9ybhVXtpl+GwOndMUrVxfbA=;
        b=Cdd9ESE+QZNV8Zj9JRAFXhimOxL5FCFZk1oc3Jy+NH84WcprQCcC7yq29db/aV9RtM
         M1I39SzQ/VjJq0X3JxM6uYpv5odHIPMQBHdcWZy3KtlOQgNxElBtvYBEOTx9PPbZ1CyH
         sMp46ROlXssv94roJcWutVjP49TDJCM3xnBT3TUohM/6xLX9VXgOExlJYKhCccMMtVNy
         6vI/2tQT9qlyhgBSxrHH3OKDwmCxKzkAop4+yCU8AsuL1F+qoeJNwWbr8EzSTeJbi5s4
         hMMa3XkTaVw3Hw8LirGrm5ka6Zozjm/HQE6Ph9r6bHWgfBfEuE2EQZAYkbWIdAaDHpJu
         XR5w==
X-Gm-Message-State: AGi0PubPMKpGzVmeK51JaST4NMxIZ40EcGKjShARAsgAASZqIU9SwFeY
        KsXlwLpr6q1KiQeBWhaTmio=
X-Google-Smtp-Source: APiQypLezAdvNjkAf3d0tzyYHt4Ww8nnWoOxbv7EHYCfn0wdCxFvvmIUGPgvZpaMR66NxRW/+DIOvg==
X-Received: by 2002:a2e:9ada:: with SMTP id p26mr15029806ljj.14.1588002138392;
        Mon, 27 Apr 2020 08:42:18 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id s8sm11515524lfd.61.2020.04.27.08.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:42:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] kernel-shark: Add command line options for selecting plots to be shown
Date:   Mon, 27 Apr 2020 18:41:51 +0300
Message-Id: <20200427154152.20592-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427154152.20592-1-y.karadz@gmail.com>
References: <20200427154152.20592-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example:
  kernelshark -i mytrace.dat --cpu '1 4-7' --pid 11

This will show CPUs: 1, 4, 5, 6, 7 and task(PID): 11.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Suggested-by: Julia Lawall  <julia.lawall@inria.fr>
---
 kernel-shark/src/KsUtils.cpp     | 24 ++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp     |  2 ++
 kernel-shark/src/kernelshark.cpp | 34 +++++++++++++++++++++++++++++---
 3 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index e99509f..3997d97 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -298,6 +298,30 @@ QStringList splitArguments(QString cmd)
 	return argv;
 }
 
+/** Parse a string containing Ids. The string can be of the form "1 4-7 9". */
+QVector<int> parseIdList(QString v_str)
+{
+	QStringList list = v_str.split(" ", QString::SkipEmptyParts);
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
index db1bf5e..2efc01c 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -132,6 +132,8 @@ QString getSaveFile(QWidget *parent,
 
 QStringList splitArguments(QString cmd);
 
+QVector<int> parseIdList(QString v_str);
+
 }; // KsUtils
 
 /** Identifier of the Dual Marker active state. */
diff --git a/kernel-shark/src/kernelshark.cpp b/kernel-shark/src/kernelshark.cpp
index 1ec6678..0978590 100644
--- a/kernel-shark/src/kernelshark.cpp
+++ b/kernel-shark/src/kernelshark.cpp
@@ -29,20 +29,43 @@ void usage(const char *prog)
 	printf("  -u	unregister plugin, use plugin name or absolute path\n");
 	printf("  -s	import a session\n");
 	printf("  -l	import the last session\n");
+	puts(" --cpu	show plots for CPU cores, default is \"show all\"");
+	puts(" --pid	show plots for tasks, default is \"do not show\"");
+	puts("\n example:");
+	puts("  kernelshark -i mytrace.dat --cpu \'1 4-7\' --pid 11 -p path/to/my/plugin/myplugin.so\n");
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
+				cpuPlots = KsUtils::parseIdList(QString(optarg));
+			else if (strcmp(longOptions[optionIndex].name, "pid") == 0)
+				taskPlots = KsUtils::parseIdList(QString(optarg));
+
+			break;
+
 		case 'h':
 			usage(argv[0]);
 			return 0;
@@ -95,6 +118,11 @@ int main(int argc, char **argv)
 			ks.loadDataFile(QString(input_file));
 	}
 
+	if (cpuPlots.count() || taskPlots.count()) {
+		ks.setCPUPlots(cpuPlots);
+		ks.setTaskPlots(taskPlots);
+	}
+
 	ks.show();
 	return a.exec();
 }
-- 
2.20.1

