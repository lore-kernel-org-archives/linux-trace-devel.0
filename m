Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E702C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 12:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B008208C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 12:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4gRflK0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406132AbfITMBj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 08:01:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45349 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406120AbfITMBj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 08:01:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so6451051wrm.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 05:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ngUDqMbjbqmKFktbgf4JJc5rd6kHgEE5QS5QXNTGoJw=;
        b=H4gRflK0lAmeApwk4TP7TF2vCu4N8GyLVx2tD5knObRH1zVxigE+o8xBhT9wCmhbBG
         PriVxwvszxD0Y+aRSwqiK5gzBOIVmkAezOSldmoCrAGBwDpsIsEfqUWRn/GxAkTA7Kov
         crYmmCOhz4fHosriHWT29tCKV2UDsZwfqM3j/HZL9aknwwNdrQ0PeASN3RwGt3A6RTOb
         4kDn7ZtuCMI6yQGzEtIJ2jeNKgUo4lNTq8r8J/jVqqkINoLv8dLSBifRCEPfutPCOWvQ
         E2qh89n5BRzrltQkYQsRSgv6IWk2cRqXGTv8t/lv8JrklcwvxCz1osUv1Ycd9bW5odD7
         +Ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ngUDqMbjbqmKFktbgf4JJc5rd6kHgEE5QS5QXNTGoJw=;
        b=jmkmejuM6kfbCZpa1zpft3KbE1OM9Sp9ASk+5Jcjh2d8o086cu6TvGA6IKo53pkc5i
         TmeeuBWHt0WiWJNF4YLMwyRLapd6iA3KBQxRuGIabv8ClkRtk8A84aXt+2ZMxmFq7Ej2
         02QNH18RMSpehVKjsQ3vZhudJikAymU0L9R7ESbtO6zLLdrrQvT3c5zReuj+tgZMssbd
         o2dYSd0K6NjVkzrJa0a6W6kB8jgPzJD132FeUM95HdY+RbG/y9/eHwl3ZfjRMO8agyzj
         OKOQQGOHP1QBFxm/EPotHPJkK0d8VfYgUyYucq4bwZYSjNWft7BZu9ipM2Uq5Rkqb60+
         1gcA==
X-Gm-Message-State: APjAAAXaoZcFBKqVtq55ihQudOCM3UGn4qLqHuxHjpHGfOVV0JwCrU/R
        d4Bt+SRfUMttPf8bpHYUcl8=
X-Google-Smtp-Source: APXvYqxVQZ5AHcrXJ5TFQDbU3KJXEvDN2xyA5a56DjGZfjbUX7xrvW3Jg1fxmGFa1VhMrcGkgXdbeQ==
X-Received: by 2002:adf:cc0a:: with SMTP id x10mr11537772wrh.195.1568980897838;
        Fri, 20 Sep 2019 05:01:37 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z189sm2679008wmc.25.2019.09.20.05.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 05:01:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] trace-cmd: Correct the install paths of traceevent and trace-cmd libraries
Date:   Fri, 20 Sep 2019 15:01:32 +0300
Message-Id: <20190920120132.30824-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to be able to use the installed versions of the library's headers
(and the libraries itself) the directories structure of the source has to
be reprodused in the install location.

This modification is needed by the NumPy interface of KernelShark.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index dabdf8d..6c66c02 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
 libdir ?= $(prefix)/lib
 libdir_SQ = '$(subst ','\'',$(libdir))'
-includedir = $(prefix)/include/trace-cmd
+includedir = $(prefix)/include
 includedir_SQ = '$(subst ','\'',$(includedir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
@@ -344,12 +344,12 @@ install_gui: install_cmd gui
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
 
 install_libs: libs
-	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
+	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ)/trace-cmd)
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-- 
2.20.1

