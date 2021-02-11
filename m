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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DF2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFED564E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBKKjq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhBKKf4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:56 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EB5C0611C0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w2so9208886ejk.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kR+y9XBolf2uKxjrop4eTTdx9fwxjJy7j/QO0D/zDdY=;
        b=nrCggwzFteQ9HNCDwdO9zLxlx5Z3B94qHp5laNyKZMTAr19mEpsIa/FVU+0vw4eoND
         WMhIp0TNfSOMFiJHAb6ZEbN7GwknHTUVo77z9PjyfaK+U8UL6uXp8oHuKxhozPiXTy8i
         ggIXzv6SZ0LQxDjGqai3AYY47XlqQbei6Gnv6Z0gGRTqhLhzKth/EN3olpHzyBHNy/oT
         Mx618iAOLtFAn2pTd5APp3KjEWylYQmkuaMjUxcbbBJvaHVpZ0xcGsFkgkDAsOkWksfz
         ipYEgITI/glx2RvTRamhcHXsxsSIb1JaskXw3b5WbYCw3e94WB2XKscJfxIuij/iYRGq
         iBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kR+y9XBolf2uKxjrop4eTTdx9fwxjJy7j/QO0D/zDdY=;
        b=qoe07GTDhjS4ut5vsxKEFYUGKqVMKENFqKTWSATLMJKXd7Y8tetuvGIC4R9TEHaZJ1
         I3HK33ymIHJNy1AHuUSNyIRDmWv79VcJCKanX0qmyZmmKFBBRj9t2e0N56DX6GgZuzOz
         PgpfkkfKNe07domTbqvfHWQuLmEBxod3LW3Udi53gRNVyMiCeRdSnRMudXKB3ShsGoRo
         w1Rny4SASH267ZiIqRTewOqzHyRggMYQmi14/0eH/GWrTd2lVGZ2TI49FwRh6vz0Msc+
         eNALvnuJ1CrsmKnC47css8jmSuRfiU+kj4bFDlXVALz8lIOw4awotdI2GEEYN+B9xy6B
         cg0A==
X-Gm-Message-State: AOAM531mKfyC5rRlWcD+BJQT7VfMEhiAAcewZ+mquK97vFxvN0m5mPI/
        PhI0cYrnlQiRYJSmTAOy93c=
X-Google-Smtp-Source: ABdhPJxkLl+kdiNno4n+lQB4EYVhwuXHMbZWcQTaruZPmPDXIySTf2Wkr8JgMQ/K9W8/712xcCvK/w==
X-Received: by 2002:a17:906:a2d2:: with SMTP id by18mr7573350ejb.262.1613039566181;
        Thu, 11 Feb 2021 02:32:46 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:45 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 25/27] kernel-shark: Show Task plots from command lime
Date:   Thu, 11 Feb 2021 12:32:03 +0200
Message-Id: <20210211103205.418588-26-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add a new command line option for starting KernelShark that allows
the user to select Task plots to be shown. The new option is similar
to "--pid" but the tasks can be specified by name.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsUtils.cpp               | 32 ++++++++++++++++++++++++++++++++
 src/KsUtils.hpp               |  2 ++
 src/kernelshark.cpp           | 17 +++++++++++++----
 tests/libkshark-gui-tests.cpp | 25 +++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 27cda55..ec53267 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -548,6 +548,38 @@ QVector<int> parseIdList(QString v_str)
 	return v;
 }
 
+/**
+ * @brief Convert a string containing task names into a list of PID numbers.
+ */
+QMap<int, QVector<int>> parseTaskList(QString v_str)
+{
+	QStringList taskList = v_str.split(",", QString::SkipEmptyParts);
+	QVector<int> streamIds, allPids;
+	kshark_context *kshark_ctx(nullptr);
+	QMap<int, QVector<int>> ret;
+	QString name;
+
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	streamIds = getStreamIdList(kshark_ctx);
+	for (auto const sd: streamIds) {
+		allPids = getPidList(sd);
+		for (auto const pid: allPids) {
+			name = kshark_comm_from_pid(sd, pid);
+			if (name.isEmpty())
+				continue;
+
+			for (auto const task: taskList) {
+				if(name == task)
+					ret[sd].append(pid);
+			}
+		}
+	}
+
+	return ret;
+}
+
 /**
  * @brief Split the ststem name from the actual name of the event itself.
  *
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index 0d2c9c3..cf209bc 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -161,6 +161,8 @@ QStringList splitArguments(QString cmd);
 
 QVector<int> parseIdList(QString v_str);
 
+QMap<int, QVector<int>> parseTaskList(QString v_str);
+
 QStringList getTepEvtName(int sd, int eventId);
 
 /** Get a string to be used as a standard name of a CPU graph. */
diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index 41ffbe7..8ed4948 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -32,7 +32,8 @@ void usage(const char *prog)
 	printf("  -s	import a session\n");
 	printf("  -l	import the last session\n");
 	puts(" --cpu	show plots for CPU cores, default is \"show all\"");
-	puts(" --pid	show plots for tasks, default is \"do not show\"");
+	puts(" --pid	show plots for tasks (by PID), default is \"do not show\"");
+	puts(" --task	show plots for tasks (by name), default is \"do not show\"");
 	puts("\n example:");
 	puts("  kernelshark -i mytrace.dat --cpu 1,4-7 --pid 11 -p path/to/my/plugin/myplugin.so\n");
 }
@@ -42,6 +43,7 @@ static option longOptions[] = {
 	{"help", no_argument, nullptr, 'h'},
 	{"pid", required_argument, nullptr, KS_LONG_OPTS},
 	{"cpu", required_argument, nullptr, KS_LONG_OPTS},
+	{"task", required_argument, nullptr, KS_LONG_OPTS},
 	{nullptr, 0, nullptr, 0}
 };
 
@@ -50,6 +52,7 @@ int main(int argc, char **argv)
 	QVector<int> cpuPlots, taskPlots;
 	bool fromSession = false;
 	int optionIndex = 0;
+	QString taskList;
 	int c;
 
 	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
@@ -67,7 +70,8 @@ int main(int argc, char **argv)
 				cpuPlots.append(KsUtils::parseIdList(QString(optarg)));
 			else if (strcmp(longOptions[optionIndex].name, "pid") == 0)
 				taskPlots.append(KsUtils::parseIdList(QString(optarg)));
-
+			else if (strcmp(longOptions[optionIndex].name, "task") == 0)
+				taskList = QString(optarg);
 			break;
 
 		case 'h':
@@ -136,9 +140,14 @@ int main(int argc, char **argv)
 		return ids;
 	};
 
-	if (cpuPlots.count() || taskPlots.count()) {
+	if (cpuPlots.count() || taskPlots.count() || taskList.size()) {
 		ks.setCPUPlots(0, lamOrderIds(cpuPlots));
-		ks.setTaskPlots(0, lamOrderIds(taskPlots));
+
+		auto pidMap = KsUtils::parseTaskList(taskList);
+		pidMap[0].append(taskPlots);
+		for (auto it = pidMap.begin(); it != pidMap.end(); ++it) {
+			ks.setTaskPlots(it.key(), lamOrderIds(it.value()));
+		}
 	}
 
 	ks.raise();
diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
index 5a0ca01..bc49194 100644
--- a/tests/libkshark-gui-tests.cpp
+++ b/tests/libkshark-gui-tests.cpp
@@ -286,3 +286,28 @@ BOOST_AUTO_TEST_CASE(GraphModel)
 	model.reset();
 	BOOST_CHECK_EQUAL(model.rowCount({}), 0);
 }
+
+BOOST_AUTO_TEST_CASE(KsUtils_parseTasks)
+{
+	QVector<int> pids{28121, 28137, 28141, 28199, 28201, 205666, 267481};
+	kshark_context *kshark_ctx{nullptr};
+	kshark_entry **data{nullptr};
+	std::string file(KS_TEST_DIR);
+	ssize_t n_rows;
+	int sd;
+
+	kshark_instance(&kshark_ctx);
+	file += "/trace_test1.dat";
+	sd = kshark_open(kshark_ctx, file.c_str());
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
+
+	auto pids_test = parseTaskList("zoom,sleep");
+	BOOST_CHECK(pids == pids_test[0]);
+
+	for (ssize_t r = 0; r < n_rows; ++r)
+		free(data[r]);
+	free(data);
+
+	kshark_close(kshark_ctx, sd);
+	kshark_free(kshark_ctx);
+}
-- 
2.25.1

