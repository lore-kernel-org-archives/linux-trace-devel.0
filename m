Return-Path: <SRS0=pI6O=2G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCFEC2D0C0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 13:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDE7206D8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 13:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTInKNzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfLPNkY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 08:40:24 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32904 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfLPNkY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 08:40:24 -0500
Received: by mail-lj1-f195.google.com with SMTP id p8so218459ljg.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Dec 2019 05:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qxdYiAEaaXfDZ5DbjuOrrHG2NwSkMig4q0joPuoIsPU=;
        b=XTInKNzZ7xRy02EG9hkzACnhOeOf76XvaPN9GWuCMX62w2ZRQ+z+jawF89flWRgn+K
         GlrhaxhZD0mhslMwaLqVKew7mPSySOsPfrTwiXbPo4fOwjp0muk2bDIrS/5x6Yvc2CvM
         bPZ2VT6uG5ncgklrcvawglzW/P5L3yFVz9mnvGgFbkylTrlGftJlWLiJaBD5k0s/fhkg
         MDOaplFgfG7McpXglpFgIn644jKVlzIEqa/6p8SEMUf1UV2bSNHQFIHQ/07nxh4JIRWX
         3kSobe+pZzjTL7RNORaaUmZDwcu7oJZ9o8u2ynDHHYI+iBxX6qkgTdE8qjMRaCRM5nWH
         ay5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qxdYiAEaaXfDZ5DbjuOrrHG2NwSkMig4q0joPuoIsPU=;
        b=mCNMls0bBF9pr8AW/Xyy2a70HLIjqTS49RrspOhyJj3t4nleNA0r21ibKILbCNOyYC
         jLleBy0NTrtMNN0jUI1VWYtQ+lT9VB0NUahAyyQohuPUj1VMQgEz2LvLqWQp/eTXBkT7
         guNx3hEmRYq3XwYDxOP/5imRVpFjfcI0f1BzuGQ75Cnr64kMYAYMsRZSD2cJmDu1yl3h
         abt62XicvohV5Fb1OMkfaLJTY1y569+kgMDhBC05+A6X6FmlW3r+cVaXdH15OBnteWJM
         yiwAlXYazl10VKSaTcVtyGe8qA5WKNJ3LaNEm8YOIDPrz4wGt6pmMyRtY6S6lAj2j2qy
         AU9Q==
X-Gm-Message-State: APjAAAW4Tw3x0Hok2DKIyYxkqd7ERuAsdufpf7Z1WdgqBxjZlZ0Nooos
        fux0+1tdtB31VssxtPZzhPWoQSyB
X-Google-Smtp-Source: APXvYqymjbgqAstoF13sP2IAVwlFwC2JJ/zQGRGSvZ6jXRAN1yLewKXxZ/4/cQvP74w0sTucisef1w==
X-Received: by 2002:a2e:a404:: with SMTP id p4mr18734650ljn.234.1576503622209;
        Mon, 16 Dec 2019 05:40:22 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 204sm7506118lfj.47.2019.12.16.05.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 05:40:21 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Search for visible entry only if this is really needed
Date:   Mon, 16 Dec 2019 15:39:17 +0200
Message-Id: <20191216133917.31690-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216133917.31690-1-y.karadz@gmail.com>
References: <20191216133917.31690-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

ksmodel_task_visible_event_exist() and ksmodel_cpu_visible_event_exist()
are relatively expensive operations. It make sense to perform those only
if the entry that was found so far has been filtered out (is invisible).
The patch also makes the processing of the CPU and Task graphs more
consistent.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsPlotTools.cpp | 42 ++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index a8eddcd..fe3008e 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -829,14 +829,17 @@ void Graph::fillCPUGraph(int cpu)
 			pidBack = KS_FILTERED_BIN;
 
 		visMask = 0x0;
-		if (ksmodel_cpu_visible_event_exist(_histoPtr, bin,
-							       cpu,
-							       _collectionPtr,
-							       &index))
-
-			visMask = _histoPtr->data[index]->visible;
-		else if (eFront)
-			visMask = eFront->visible;
+		if (eFront) {
+			if (!(eFront->visible & KS_EVENT_VIEW_FILTER_MASK) &&
+			    ksmodel_cpu_visible_event_exist(_histoPtr, bin,
+								       cpu,
+								       _collectionPtr,
+								       &index)) {
+				visMask = _histoPtr->data[index]->visible;
+			} else {
+				visMask = eFront->visible;
+			}
+		}
 	};
 
 	auto lamSetBin = [&] (int bin)
@@ -918,6 +921,7 @@ void Graph::fillCPUGraph(int cpu)
 void Graph::fillTaskGraph(int pid)
 {
 	int cpuFront, cpuBack(0), pidFront(0), pidBack(0), lastCpu(-1), bin(0);
+	struct kshark_entry *eFront;
 	uint8_t visMask;
 	ssize_t index;
 
@@ -991,12 +995,15 @@ void Graph::fillTaskGraph(int pid)
 
 	auto lamGetPidCPU = [&] (int bin)
 	{
+		eFront = nullptr;
 		/* Get the CPU used by this task. */
 		cpuFront = ksmodel_get_cpu_front(_histoPtr, bin,
 						 pid,
 						 false,
 						 _collectionPtr,
-						 nullptr);
+						 &index);
+		if (index >= 0)
+			eFront = _histoPtr->data[index];
 
 		cpuBack = ksmodel_get_cpu_back(_histoPtr, bin,
 					       pid,
@@ -1026,12 +1033,17 @@ void Graph::fillTaskGraph(int pid)
 						       nullptr);
 
 			visMask = 0x0;
-			if (ksmodel_task_visible_event_exist(_histoPtr,
-							     bin,
-							     pid,
-							     _collectionPtr,
-							     &index)) {
-				visMask = _histoPtr->data[index]->visible;
+			if (eFront) {
+				if (!(eFront->visible & KS_EVENT_VIEW_FILTER_MASK) &&
+				    ksmodel_task_visible_event_exist(_histoPtr,
+								     bin,
+								     pid,
+								     _collectionPtr,
+								     &index)) {
+					visMask = _histoPtr->data[index]->visible;
+				} else {
+					visMask = eFront->visible;
+				}
 			}
 		}
 	};
-- 
2.20.1

