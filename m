Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C36C4741F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A4C21734
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcJ80MX/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgI2Nlt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730077AbgI2Nlr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:47 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89C8C0613D0
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w5so5446558wrp.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RObba5nOQIMZIo9xXirofkHxdXvwu2Ta2PFfn0grAJI=;
        b=RcJ80MX/idYGoZOIH9/L4vQg/JRsSrLbH9dyzRjJimyiV20rHHW1caQHcGm0IEB2Xz
         VKvdesCz8+pe9zUcNGiBq8pw1XLBGgs0NcN5XU5HKSA2tJVPqFANd2OV6lS62IKyd1lv
         xHUdN8f1nc2Zs7zwJw2m1Wvqhqp/vusfU47rZo1yZjM7AW9gu5BNexflHbFI77MnRVij
         PZmesIV2NPPYGIzcOpTFFlhjyNfTVYxi8LSmzusRVqGjKBycLUeXv3BXRLHoBmimPh2e
         vEPfigykxisUij2CMoMGR0DyzjwHJzEBbglIWmygtwy5mVmt4DKqbTV4OjrhirOL7Yop
         xiwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RObba5nOQIMZIo9xXirofkHxdXvwu2Ta2PFfn0grAJI=;
        b=kW69GK/i/n/Jk2ZEaz9BjsOn4k4/Xmi6wPS0tJMCaPpvBhkDGKJhhkUwZrOTabwNYu
         y+Q75Hx5EZTHdKiiptFf+aSz1RhpQDxvAJyg15W6dxdG0dGFF3npGNljxX1ZpPACbCdD
         YZJ9yH0yZA+SqHyKWcCUWJGJvQ3l7ANUrQVnJ0dVJDg/3B3LcLBnB4Ho5jpXQiwn4tf+
         D+NRRFDwzFyCPJHoNdk85s7lAXfl+Qx2K/9mn/0YjS7M/TmIwBcHDr+h5Ts/dV/5Ecmq
         qAE/KKNBZ+VlnrwaGYo+/2Yxh1QJCtnJC9Ku2C5il+XZRIvfqDG9pCBCKj1PKFdFUyRr
         GIkA==
X-Gm-Message-State: AOAM5320vSFzpO43JTCBpkqF7QXx8DaeZ7GCUxwI2R3vBlkYlA9rTtns
        3stByaSDoHvGAiwaVIGoAVs=
X-Google-Smtp-Source: ABdhPJwaz0JqyxHR4z9WAi4kyUOkNKPBQQRNfS+PAoFRJBtqKzR0acy2M6myo4XuT4wuGwHS3s2KVw==
X-Received: by 2002:adf:f88d:: with SMTP id u13mr4708423wrp.213.1601386905379;
        Tue, 29 Sep 2020 06:41:45 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 01/15] kernel-shark: split kernel-shark from trace-cmd repo
Date:   Tue, 29 Sep 2020 16:41:09 +0300
Message-Id: <20200929134123.178688-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Kernel-shark is no longer a directory in the trace-cmd repository.
It is now a stand alone repository, hence we should not try to search
for the trace-cmd libraries in the original directory tree of the
trace-cmd repo.

Signen-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/FindTraceCmd.cmake | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/build/FindTraceCmd.cmake b/build/FindTraceCmd.cmake
index c29b779..02f4529 100644
--- a/build/FindTraceCmd.cmake
+++ b/build/FindTraceCmd.cmake
@@ -18,7 +18,6 @@ if (CMAKE_BUILD_TYPE MATCHES Debug)
 
   find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd
                                      PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                            ${CMAKE_SOURCE_DIR}/../tracecmd/
                                      NO_DEFAULT_PATH)
 
 endif (CMAKE_BUILD_TYPE MATCHES Debug)
@@ -31,26 +30,22 @@ endif (NOT TRACECMD_EXECUTABLE)
 
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
-                                       ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
+
 find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
                                 PATHS  $ENV{TRACE_CMD}/include/
-                                       ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
 
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
-                                       ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
 find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
-                                       ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
-                                       ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
 # If not found, search in the default system paths. Note that if the previous
@@ -94,7 +89,6 @@ ELSE (TRACEFS_FOUND)
 
 ENDIF (TRACEFS_FOUND)
 
-
 IF (TRACEEVENT_LIBRARY)
 
   SET(TRACEEVENT_FOUND TRUE)
-- 
2.25.1

