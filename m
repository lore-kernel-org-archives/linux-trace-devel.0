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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2CFC55191
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 13:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD31820767
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 13:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrM91Npl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgDXN0Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgDXN0P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 09:26:15 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDDAC09B046
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 06:26:06 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id u6so9911673ljl.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x6AsaGgfnB5d3swwbxvqlyfBr5y+rWpPNBJKIuvep14=;
        b=GrM91NplNgosV2AUZt6nGrfnYzyaJOj0HwCiokcL+c5K376cInOhwcd50DC4FBKOu/
         yJ6da5uEtTorH894tYwc1C2b3kYDxTVXIV23QTxx9dz6YQXxYMjy3qcFxEKppCa42m2g
         2kblAw96ExBBnV/a7RkKRIePmP8UFQko6gQOrGqm41sv8Zwj5xLFncgJ6YqzZbvwUCJv
         /lSX3sBXi53IbOuvYRipltYrE3HbNdYHuAhef1K+vy5dWgqr+Il66HaspjEsrfpIkcHN
         xbAlcY7S7vHVpvWBr5rR5HSWOEbsW8sI1jTLc10PqFeA3LQriRypPU2lfNjDCXNfuA0y
         XZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x6AsaGgfnB5d3swwbxvqlyfBr5y+rWpPNBJKIuvep14=;
        b=KFS5v9+U+Czq/RQI2USvU4PZfZPjwa9z9D5c6KsJZTkFWMrRkUWmUIzeCZndKYv+UG
         HGv8TKrEyPWUhPYuTUeLrhEVJVxKjdRm/6bX0NeAMrWF46dPvaNzxqkGiWMp9C9PgXYD
         WME1czp75pNG2nt9s37qfnwmPu3PahvMIfSLCe1HJLiSK82OmjVUuo8lhqpF73HgohFq
         DN7gnAZ3AQBil1QmJxIhDPVhY8mnqu1ruZJubdfgnPwOKk9ip0nrN3vkDFbZ+MeT4YCu
         J9EoMXGLZ9hX91TOO5jmPke5G3/7oFDJm+rxiGEnTRjOdgLMXQjBP1xjuzlWRng75imj
         r6ag==
X-Gm-Message-State: AGi0PubRT0tvk7H7fChv4PaCgjysAigJU1NrmsYd2m9FXR3KUSsaciLg
        asysMhYzWaWy9Apnqml8iug=
X-Google-Smtp-Source: APiQypLEgPk9xV7c5knNcF0mwNbQ/0S5AqRTMPNCQ7Hl5DQu9VOP+mRSuZw174/y1jSghDOOCFCY6A==
X-Received: by 2002:a05:651c:2011:: with SMTP id s17mr5574017ljo.242.1587734765185;
        Fri, 24 Apr 2020 06:26:05 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.94])
        by smtp.gmail.com with ESMTPSA id p14sm4302287lfe.87.2020.04.24.06.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:26:04 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Add methods for selecting the plots to be shown
Date:   Fri, 24 Apr 2020 16:25:41 +0300
Message-Id: <20200424132542.1620-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424132542.1620-1-y.karadz@gmail.com>
References: <20200424132542.1620-1-y.karadz@gmail.com>
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
 kernel-shark/src/KsGLWidget.cpp   |  6 ++---
 kernel-shark/src/KsMainWindow.cpp | 39 +++++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index e930006..f5a96ac 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -369,9 +369,9 @@ void KsGLWidget::loadData(KsDataStore *data)
 	_model.fill(_data->rows(), _data->size());
 
 	/* Make a default CPU list. All CPUs will be plotted. */
-	_cpuList = {};
-	for (int i = 0; i < nCPUs; ++i)
-		_cpuList.append(i);
+	if (_cpuList.isEmpty())
+		for (int i = 0; i < nCPUs; ++i)
+			_cpuList.append(i);
 
 	/* Make a default task list. No tasks will be plotted. */
 	_taskList = {};
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

