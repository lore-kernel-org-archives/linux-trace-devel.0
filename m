Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642EDC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Apr 2021 15:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29CFE61462
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Apr 2021 15:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhD3PkI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Apr 2021 11:40:08 -0400
Received: from mailrelay2-2.pub.mailoutpod1-cph3.one.com ([46.30.212.1]:44047
        "EHLO mailrelay2-2.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhD3PkI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 11:40:08 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2021 11:40:08 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=20191106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=mPvwBg5WyEL8RKfWjaaue1aGwVI9G4lMRQcZXlsbv8M=;
        b=m3mDNc0jlCDq9s0Y/ROOVUWnzsW0NZBN2o92hsFnbYmmTJ/J8L+blVfoTyCI8toIZBK7qHq/dmHAl
         JStRclFKBG+RHNd343bTVCUiTJYH74HsHuVgIYwkKAN8Um021RmDLIUs1KJUIdkEMBvZQny+JsgqlJ
         gy3hjUP3JkvbYTc8n1VnWgPaRl83QPhVGvrLWxPXxt6GbABPurUoaYeMwReZ99NdtoQecwdYq9ojqO
         nW0mTroafeorD0GYV6Kw5DQhrD0lPyQhlu4UgHcqNJIV+k3yUCeN/vZNSprpyHjRkVSu/2SKItFsyA
         EObv35i3NRqzgKBFDBw8rFxubQFj7oA==
X-HalOne-Cookie: e9c66cadacf9449ecde10b0e11fbe8e531804775
X-HalOne-ID: fab13229-a9c7-11eb-b567-d0431ea8a290
Received: from localhost.localdomain (ua-85-227-233-29.bbcust.telenor.se [85.227.233.29])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id fab13229-a9c7-11eb-b567-d0431ea8a290;
        Fri, 30 Apr 2021 15:23:16 +0000 (UTC)
From:   peter@berginkonsult.se
To:     linux-trace-devel@vger.kernel.org
Cc:     Peter Bergin <peter@berginkonsult.se>
Subject: [PATCH] trace-cmd: Changing default install path of plugins
Date:   Fri, 30 Apr 2021 17:24:30 +0200
Message-Id: <20210430152430.1958285-1-peter@berginkonsult.se>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Peter Bergin <peter@berginkonsult.se>

README file states that default install path for plugins
is '/usr/local/lib/trace-cmd/plugins' but Makefile did
specify other location.

Signed-off-by: Peter Bergin <peter@berginkonsult.se>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ec73b5c..0d8fea0 100644
--- a/Makefile
+++ b/Makefile
@@ -94,7 +94,7 @@ plugin_tracecmd_dir = $(libdir)/trace-cmd/plugins
 python_dir ?= $(libdir)/traceevent/python
 var_dir = $(HOME)/.trace-cmd/
 else
-plugin_traceevent_dir = $(libdir)/traceevent/plugins
+plugin_traceevent_dir = $(libdir)/trace-cmd/plugins
 python_dir ?= $(libdir)/trace-cmd/python
 PLUGIN_DIR_TRACEEVENT = -DPLUGIN_TRACEEVENT_DIR="$(plugin_traceevent_dir)"
 PLUGIN_DIR_TRACECMD = -DPLUGIN_TRACECMD_DIR="$(plugin_tracecmd_dir)"
-- 
2.25.1

