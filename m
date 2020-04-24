Return-Path: <SRS0=pvIb=6I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADA6C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 13:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DBA205C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 13:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MRk7gojA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgDXN0Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgDXN0P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 09:26:15 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E105C09B047
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 06:26:09 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 131so7642284lfh.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 06:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZJkvy5GlAGf5dHKMFZzQ9kGcLaomL/6y0igeHo6dghw=;
        b=MRk7gojAn7Lbpkdjje+0g9UCvvs9tZQ+oahFqEKIM9DqQIkcHLKIcYTxn78u3RZqcR
         JUmopavfu2HbsucnTb53RqcKld6QFozZQBgBPxEqB+5w59q8YvjTWIAwZ0/qROdr6zDi
         duWcGCzbPZVZKEnR6x0fF+/qCDCriAAP30S7cK1H80N2USyMJyBWXjd8YkaCzcm3VpsQ
         AIFTnMV6U+7cKjMY8GZ+OwdXh6VlrBXkA3OrJ/gMIMK0IUqAcgj7KSa5+0PAc3xZZZdX
         DLZyV1xBwXhUfabzyEJUTwZ4G6fQaXzkgHAM158p4DDPoe8fgnrXS+LLxZk0AQ4U4C84
         4lIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZJkvy5GlAGf5dHKMFZzQ9kGcLaomL/6y0igeHo6dghw=;
        b=kQVNW1bNRahkqgj8AA8MVLVwT1LmF+JUNnoICTYFR/V533HHWn40PaDtppR/eHMPXE
         XH2zPjpwEQnSj6+4kBnSOAPYAZXPCqBHanvh8Pc4BnCs0Hq2yiiT/dArkqZ57CsgbExj
         HbvthRZT6sdwt1cVNzZVFGa3+9bIPVji2k9WexOIQGfsUyKHj4YF3XRtM8uIx1Bnykok
         dqCk/BENADZ78uINCyvaDTARgye/Pw+aPEfg47s/O3H/mC61FQ9Qfvp7zg1L4khzP4bR
         9JAD2t9fG9B9qjQ0eKMrCEy+9eapZb+6KX4kynIIvmX3ehSTP0smo2APWg/XdAWig0hK
         l6DA==
X-Gm-Message-State: AGi0Pua5k4Rv9H9vRkF68Kuv8cgyowL2YbspBO0+kQU1oxtXPZXWv22A
        OlYj/YaEuScwLLKXT6FfB/A=
X-Google-Smtp-Source: APiQypIYQlk0bCSI2U/GZMRnzqTIITaBycO8Gc0H4n2T3AiyFfekFlhfKnw6E34HhiqxAPXRV7eTYg==
X-Received: by 2002:a19:c850:: with SMTP id y77mr6200783lff.45.1587734767105;
        Fri, 24 Apr 2020 06:26:07 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.94])
        by smtp.gmail.com with ESMTPSA id p14sm4302287lfe.87.2020.04.24.06.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:26:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Add command line options for selecting plots to be shown
Date:   Fri, 24 Apr 2020 16:25:42 +0300
Message-Id: <20200424132542.1620-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424132542.1620-1-y.karadz@gmail.com>
References: <20200424132542.1620-1-y.karadz@gmail.com>
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
 kernel-shark/src/KsUtils.cpp     | 24 ++++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp     |  2 ++
 kernel-shark/src/kernelshark.cpp | 32 +++++++++++++++++++++++++++++---
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index e99509f..4a46014 100644
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
+			int from = item.left(i).toInt();
+			int n = item.right(i).toInt() - from + 1;
+			int size = v.size();
+
+			v.resize(size + n);
+			std::iota(v.begin() + size, v.end(), from);
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
index 1ec6678..55b5831 100644
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
@@ -95,6 +118,9 @@ int main(int argc, char **argv)
 			ks.loadDataFile(QString(input_file));
 	}
 
+	ks.setCPUPlots(cpuPlots);
+	ks.setTaskPlots(taskPlots);
+
 	ks.show();
 	return a.exec();
 }
-- 
2.20.1

