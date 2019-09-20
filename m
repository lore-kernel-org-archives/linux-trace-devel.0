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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCB6C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0286207FC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oac0dJtq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408706AbfITKsn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:48:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33216 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408703AbfITKsn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:48:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id r17so9250988wme.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6FFwUsxoFzc+hY7PxaoFIpi3ees7WEwo0cj++kWpZQc=;
        b=oac0dJtqGmCfP57ae6KbknbclHUw1a/AcHTYaeRbG4rWklbf68eXeFsm8Ut6eT6QtQ
         89OkxStfHWpGD0I9DNNGU5S4lsfe2dzWpqzR6jMiEUOvGVBKUhNmQsUxLilZpGTjfxoZ
         cCwIo3Zl8fLPusSxYyfKxhNFQvxjQH1sUHEuBan0N+UK1ij6w7sc66BER23JaLIY+nmU
         Nb6i3OcGjbS1yF1UQgf9RPl2S9HxVSxTBMbRIuKuGu2HAcmX7US0wmgfRPYnSoMneBzC
         Q1t9Zu75RAOfns7lrvAuUW/ykeIzecEg2a3zBkxbQnhMstTZ0wYWRITFR0551MPkX8BF
         4MUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6FFwUsxoFzc+hY7PxaoFIpi3ees7WEwo0cj++kWpZQc=;
        b=OhZXgUu9Q+nF1Mubae583DiTG7iPyYnyklkBN8d16Jj9Ok4jxkbv6yzmI7TgT3BylC
         58WrIdnFiXY66Ne2JwDMCabf6pZ9p9SBQpwUI/j/i3oGExkGpc8rdM3NgaCxo6pn9f8K
         luUimIjRejVDFwu/K0I5e4pAtCLIkDuJbALgTo8WvWtky2Yuy2DoIMekNEDaYJ9CvouD
         VdHeX2FLQ6Xd7RbUN7rfycxnGucIJvvH/llqZWRbm9swmgXHJVKO+4Cu42GPBDynkF1E
         NZi4I/0FTcaK0ONjFy4AnedRCqI5BTt+xLIdP4jAon3rZnXFNe9XdlB9tQECJW/s72Uq
         BhFw==
X-Gm-Message-State: APjAAAWAhetWh/g+PGfkPuXsH2N/EX8ggcVa99eOX01uCz57M0oYtjgI
        64LRcpee71d2LURSjFh2PZS9ZoTh
X-Google-Smtp-Source: APXvYqwSXNylNonOqoRlzAcTtFsIbGlBvPhuqya/i/MLwNctgaCXi3hGv8Bte8h9ur5e8PMiqD4G0g==
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr1755798wmb.35.1568976521543;
        Fri, 20 Sep 2019 03:48:41 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t14sm1641978wrs.6.2019.09.20.03.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:48:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Fix the file paths used by Doxygen
Date:   Fri, 20 Sep 2019 13:48:30 +0300
Message-Id: <20190920104831.23475-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920104831.23475-1-y.karadz@gmail.com>
References: <20190920104831.23475-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The Doxygen documentation, including its configuration file, have been
moved to another directory. Therefore the paths, used by Doxygen to find
its input, have to be changed accordingly.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Fixes: d4d68c9 (kernel-shark: Separate trace-cmd and kernelshark)
---
 kernel-shark/Documentation/doxygen/dox_config | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/Documentation/doxygen/dox_config b/kernel-shark/Documentation/doxygen/dox_config
index 43c7f84..89b9284 100644
--- a/kernel-shark/Documentation/doxygen/dox_config
+++ b/kernel-shark/Documentation/doxygen/dox_config
@@ -4,7 +4,7 @@
 DOXYFILE_ENCODING      = UTF-8
 PROJECT_NAME           = "KernelShark"
 PROJECT_BRIEF = "Kernel Shark is a front-end reader of the Linux kernel tracing data."
-INPUT                  = ../src/ ../src/plugins/
+INPUT                  = ../../src/ ../../src/plugins/
 SOURCE_BROWSER         = YES
 QT_AUTOBRIEF           = YES
 TAB_SIZE               = 8
@@ -13,4 +13,4 @@ CASE_SENSE_NAMES       = YES
 SORT_MEMBER_DOCS       = NO
 STRICT_PROTO_MATCHING  = YES
 DOT_MULTI_TARGETS      = YES
-PROJECT_LOGO           = ../icons/KS_logo_stacked.svg
+PROJECT_LOGO           = ../../icons/KS_logo_stacked.svg
-- 
2.20.1

