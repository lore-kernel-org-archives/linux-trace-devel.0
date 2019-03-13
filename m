Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323C7C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D13C20643
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfCMPWu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:22:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34256 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfCMPWu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:22:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id o10so4701828wmc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aufaCDtkY9mXlP1hwty/h041sVOcnpu0fmxVOqJsGKg=;
        b=iTDLf/XNLYzrDzss1U/9j/FYapkQrgEenAQiY+yzsZR6oi+JuCJLPjH8mpVJGuz+7o
         f68ueV8rImek6Fz0MyiFj4GWWtxTlZlvGS8rp15uYgfRdvFaBtpgykXwjQhtYRx2Ivql
         oxD4mmO3TbnTeouJWFCuIOIc1IZiFh4bCKVk/6bj0HlntRVre5fDZRURcmB7EfW+xJXs
         ToeAZKkZdx09agX48UDm5R/ELr40OqEUKii/0U8yl1X3D0XGoi/n/BLvtwi+TliVJH5E
         xl9O1iaaJHmo/R08AcGrUsu4cr/wgvQ2FF5sMf3bsEj6GFtBPqGBcI+A6WGbFoAM08yz
         BHxQ==
X-Gm-Message-State: APjAAAWuWluBcQRuBO/ps2t1KzyC8g+azAuP0MK/7xTCGB28v9srqeos
        J5DYdgYbgaUQNbB9Qh9DjBM=
X-Google-Smtp-Source: APXvYqx37fTZOAIDFpelFkSNXfwFIy7j2IPlhQeULrDDyF0e/EKa10N2ABTgVjMFG7rHRNpbSGAdow==
X-Received: by 2002:a1c:a186:: with SMTP id k128mr2656386wme.54.1552490568257;
        Wed, 13 Mar 2019 08:22:48 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id w10sm20775822wrn.32.2019.03.13.08.22.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:22:47 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 1/3] kernel-shark: Reorder the priority when searching for trace-cmd libs
Date:   Wed, 13 Mar 2019 17:22:18 +0200
Message-Id: <20190313152220.22026-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313152220.22026-1-ykaradzhov@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CMAKE build system of KernelShark performs automated search for the
trace-cmd libraries, headers and executable before building the GUI.
The new order of the list of directories to search in is the following:

1. ${TRACE_CMD}/  ($TRACE_CMD is an environment variable)

2. CMAKE_SOURCE_DIR/../

3. Platform / system specific locations

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/FindTraceCmd.cmake | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index fb2092a..b09a11b 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -14,17 +14,27 @@
 
 # MESSAGE(" Looking for trace-cmd ...")
 
+# First search in the user provided paths.
 find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
                                 PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                       ${CMAKE_SOURCE_DIR}/../tracecmd/)
+                                       ${CMAKE_SOURCE_DIR}/../tracecmd/
+                                NO_DEFAULT_PATH)
 
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/trace-cmd/
-                                       ${CMAKE_SOURCE_DIR}/../include/trace-cmd/)
+                                       ${CMAKE_SOURCE_DIR}/../include/trace-cmd/
+                                NO_DEFAULT_PATH)
 
 find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a
                                 PATHS  $ENV{TRACE_CMD}/lib/trace-cmd/
-                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/)
+                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/
+                                NO_DEFAULT_PATH)
+
+# If not found, search in the default system paths. Note that if the previous
+# search was successful "find_path" will do nothing this time.
+find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd)
+find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h)
+find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
 
-- 
2.19.1

