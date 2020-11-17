Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313E2C63697
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 21:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB47F24631
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 21:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgKQVQt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 16:16:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45599 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgKQVQt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 16:16:49 -0500
Received: by mail-wr1-f65.google.com with SMTP id p1so24795219wrf.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Nov 2020 13:16:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=IzZcU43drwA1XrmKgPsIpjKV5dJbTj+dYj4jVmRLqqE=;
        b=CoRV0PClskzZgvuBe3w4FKDev9kpDubU6PB/ymW9Z+y1VNbkrl4IMeuds04+BO52JZ
         ue07lqaaqGmdcJ4/++PLVCyE+/h0mNiu7h3G7DFnPglpA0LXgNtSZQJnYMtqYbH/2QV1
         KhQeCyjiir5AFyMt4JNTEnfufLY5BKvh/d+oVVkgYse7yRkKfD4bI5lYec5PIKmOAAGi
         1w9UeZ4hyA5baUoK4wnfSEARxsZQtNuyjeKPkjnH9Dj/AFuYDHlm1sgLyJ9kl24RXKS9
         My5iqV3dmqlAjm9REZNpXXLEJkTq3QbyG4idmdJbJ6t2DbyUciDaD7GV3DCoZ1NGKMVP
         bQxg==
X-Gm-Message-State: AOAM533PAD//LfhMF6j+Xeqqu5+8sKLmDxRVDSGKRobgGO6+2CKXcwVP
        gqez+EIMkKerFSWq/GxhYgjtmPnDYjQ=
X-Google-Smtp-Source: ABdhPJxjqEcPI8SKGs46S86FeGEqhj0ughi9pJ3XStRO+CjMNK+dpSPRXhGG6yvJEThrH2P5ha6KwA==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr1462737wrv.359.1605647807519;
        Tue, 17 Nov 2020 13:16:47 -0800 (PST)
Received: from [127.0.0.1] (87.78.186.89.cust.ip.kpnqwest.it. [89.186.78.87])
        by smtp.gmail.com with ESMTPSA id z189sm5359246wme.23.2020.11.17.13.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 13:16:46 -0800 (PST)
Subject: [PATCH] Fix `make -jN trace-cmd gui`
From:   Dario Faggioli <dfaggioli@suse.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Date:   Tue, 17 Nov 2020 21:16:45 +0000
Message-ID: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Doing `make -j8 trace-cmd gui` fails like this:

  CMake Error at build/FindTraceCmd.cmake:110 (MESSAGE):

    Could not find libtraceevent!

  Call Stack (most recent call first):
    CMakeLists.txt:24 (include)

Or like this:

  CMake Error at build/FindTraceCmd.cmake:64 (MESSAGE):

    Could not find trace-cmd!

  Call Stack (most recent call first):
    CMakeLists.txt:20 (include)

That's because we need `trace-cmd` to have finished
building before starting to build `gui`.

Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
---
 Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b034042..c8d1e02 100644
--- a/Makefile
+++ b/Makefile
@@ -301,7 +301,9 @@ BUILD_TYPE ?= RelWithDebInfo
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
-gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
+gui: force
+	$(MAKE) $(CMD_TARGETS)
+	$(MAKE) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"


