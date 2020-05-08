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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676E2C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457C3214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WafJPnXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEHPXZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 11:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEHPXY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 11:23:24 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FDBC061A0C
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 08:23:23 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id g10so1702548lfj.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 08:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lTxYXmCND4/OE3RUcjHoEnYdVSUXDPzJVkv/UEEKKp0=;
        b=WafJPnXVTYAe8m8l1khwJDmtagpnQiyzXC8eF5PEGuZrJE1Hn3pT4pBsSEse/VuDtR
         5At3QcrbdA+jWLbkLT4/u1WA//hU9eEyfMw14xv1FcOwRu4lTM/OLy8wAdHaRApM4sKv
         kuK7QbGuh8DhXcF2DqBOomubWnQ/1q9yxefP7yKf0JjBOLUSTK4ASt1sCM743qF3csSw
         CJMByMcpA9+VeKtHA4ViieOXXmhd1laVziF4zYeP3rkc+HjyNjcJrQANb9+hX6OUVQCU
         YeP+jQ6rYDMtKW7Oq+zS9C6pvkQa+2WCt5u9MSl313mIrtv03DVVdyaVF6c+TrdGQQ/x
         +lYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lTxYXmCND4/OE3RUcjHoEnYdVSUXDPzJVkv/UEEKKp0=;
        b=Ixw+FwZYVy86Rr+kTW0M7JWcIRs+9mUp0NEoLWdNu8VdRxS9sbOVFLrx72jNExR1G+
         n217I+r2rNz4zKAuWNLgA0xTg2h8A/ajeK3QKzifRRrRad2xViFr2OpAhaeQcQBR4mKn
         uk2QsOY5XVAsf4GZjSupibUt+H0SwFWP+Fl8sRLypkPycOY+VhS0Jf6BvKK8M61dDj9o
         0ncuUQIyo9wRmBkJPdmIE2mF5v4WBUucYyBVrEmdfxdJw8g/P/97YExcwjwcDaVYA4lD
         R2So7q1JKt4c5u58MavgWIM0nuFJ5ACA7MbBGplJGrnYB0qt+wbPZDpz7UPBDoJNu/eK
         oJrQ==
X-Gm-Message-State: AOAM533acT+5DcU0FOV+YXKp9HmBKghAf6PtZqhWo1Wv0SUD6gzYcUeD
        izyO25fMZWJ99CHNHVXGZZ1UyDe0/4w=
X-Google-Smtp-Source: ABdhPJxqxwe9ynf830hcL+rcGb3K2B7/kgrSzp8zaKbGl173LnzGeX7g8UNKINDt2BdZSZ/8KjFvKA==
X-Received: by 2002:a19:ad45:: with SMTP id s5mr2308940lfd.106.1588951401432;
        Fri, 08 May 2020 08:23:21 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id q20sm1466497lfm.35.2020.05.08.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:23:20 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 1/3] kernel-shark: Add methods for selecting the plots to be shown
Date:   Fri,  8 May 2020 18:23:00 +0300
Message-Id: <20200508152302.27843-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200508152302.27843-1-y.karadz@gmail.com>
References: <20200508152302.27843-1-y.karadz@gmail.com>
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
index 1f56645..fc4e9a9 100644
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
index 997ea54..2fac107 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -62,6 +62,10 @@ public:
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

