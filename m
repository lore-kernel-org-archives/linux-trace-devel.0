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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F6BC54FCB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22CFB20735
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bt1CWCRK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD0PmR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728032AbgD0PmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 11:42:17 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8406C03C1A7
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:16 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id g4so18108020ljl.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ABPby8OBmB71raeP0X30P+jP4GhOfo80R/Dch90ugcI=;
        b=Bt1CWCRKyhDytKIKdwX/pwf0MU5bSK9mqnk/UItxmJxrMeWfvEc/dcrqJoirBD4gEj
         bruQLAVyd8L3jCMl/1aYx7pfB3sHtYbJOYlJJrDDbW2EXXffrqIUgaoBU+i3B+7t4box
         cmqA5iY5cGv/Vm/aiZm8llOjPmcxFWOX/0C0hI3zSCuAvk2eLwnkRfbqDdppuDkF1oQW
         GKgwBAhNgK2HMJKId81F2QVFFWZVCr1k+Gq6zwsSuFcTlXKHFwFPPZ7UM5eVthF2u1/3
         VkGzDjXlqY9ZkW/E78+2++D7g2m3B8YQlllrDc/NT5cuIoPBl4M+a9W44srdbHmlCwbE
         MqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ABPby8OBmB71raeP0X30P+jP4GhOfo80R/Dch90ugcI=;
        b=CfeTUVEqzFvX/qLHn6NkTHmBQ6Hq/LfxsjCkJWSjXHk74LcUm5ZihJ0z7Ww8hm779v
         gnY4H1wgj9yMykyzeH/KW4RoQV0Aa0FomG30apneQsOhH0AKT0k3vG1MSKV6SKKjH8ev
         B9+PLdUIHp4yTNMaORteyxwvn/39ChkkA0M+YOqRRJnuRvHHqX3KzxlYqnNSOLXZUilJ
         QJF4ZSCWRerKtXhm3HARGTdrdk17rZzvaAJClKx9hKY/7hrE3lhRfmsuLDJ4Sdk6u32E
         AcZ+m5hJXjfIdJ3yFZ3sfjH169x31o8JzM3YBBvo/LevWYIqhMfKZzq2aCsTMC1FwfwW
         amMQ==
X-Gm-Message-State: AGi0PuYT8pCfjnJ34ftc3fMbiiK1Geln55d+9Jx7djTLT6bdAySh6UdB
        y4QsFjdxbR4ZTllWgROfEi4Kgs5FY4k=
X-Google-Smtp-Source: APiQypK9c/lUXn+Awc/e1W+obWRiFn4hOy68idiVzW8QK6AkcsOaibAJ//sFSjGLchwynjvZp/XhLA==
X-Received: by 2002:a2e:8087:: with SMTP id i7mr13502265ljg.99.1588002135304;
        Mon, 27 Apr 2020 08:42:15 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id s8sm11515524lfd.61.2020.04.27.08.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:42:14 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] kernel-shark: Add methods for selecting the plots to be shown
Date:   Mon, 27 Apr 2020 18:41:50 +0300
Message-Id: <20200427154152.20592-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427154152.20592-1-y.karadz@gmail.com>
References: <20200427154152.20592-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The methods are added to the public interface of the KsMainWindow class
and can be used to pre-select the CPU and Task plots to be shown, before
opening the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 39 +++++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 2 files changed, 43 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index a5a399c..333e14b 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -172,6 +172,45 @@ KsMainWindow::~KsMainWindow()
 		kshark_free(kshark_ctx);
 }
 
+/** Set the list ot CPU cores to be plotted. */
+void KsMainWindow::setCPUPlots(QVector<int> cpus)
+{
+	int nCPUs = tep_get_cpus(_data.tep());
+	auto lamCPUCheck = [=] (int cpu) {
+		if (cpu >= nCPUs) {
+			qWarning() << "Warning: No CPU" << cpu << "found in the data.";
+			return true;
+		}
+
+		return false;
+	};
+
+	cpus.erase(std::remove_if(cpus.begin(), cpus.end(), lamCPUCheck),
+		   cpus.end());
+
+	_graph.cpuReDraw(cpus);
+}
+
+/** Set the list ot tasks (pids) to be plotted. */
+void KsMainWindow::setTaskPlots(QVector<int> pids)
+{
+	QVector<int> allPids = KsUtils::getPidList();
+	auto lamPidCheck = [=] (int pid) {
+		int i = allPids.indexOf(pid);
+		if (i < 0) {
+			qWarning() << "Warning: No Pid" << pid << "found in the data.";
+			return true;
+		}
+
+		return false;
+	};
+
+	pids.erase(std::remove_if(pids.begin(), pids.end(), lamPidCheck),
+		   pids.end());
+
+	_graph.taskReDraw(pids);
+}
+
 /**
  * Reimplemented event handler used to update the geometry of the window on
  * resize events.
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index eef4f96..774e1c9 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -61,6 +61,10 @@ public:
 		_plugins.unregisterPlugin(plugin);
 	}
 
+	void setCPUPlots(QVector<int> cpus);
+
+	void setTaskPlots(QVector<int> pids);
+
 	void resizeEvent(QResizeEvent* event);
 
 	/** Set the Full Screen mode. */
-- 
2.20.1

