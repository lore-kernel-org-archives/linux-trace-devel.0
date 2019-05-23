Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDF5C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAD6320665
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731185AbfEWPSr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:18:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44450 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730741AbfEWPSq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:18:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so6697617wru.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:18:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WjmaV1lSkCYDOvb3GEAecwv2rT46hwvlIAOUE8+KUcA=;
        b=IPtZhvXdtMYpSKTohOvNc83wmLs0h9Ib4UZLEItR3+A8pD3Z/aqoxW5o3iQHqQUtFG
         +6yw1IQxsj1pz/E9hzVhlZLXv4PEXwileO0JzwVq+v3IvSq2BmHOu3ZkAbk8QD66KdFy
         WXIhGHmNrnb+dGM08n5M5eEblxyM+Hnn5BGWW2usmJ32KbWdfq1gQ17r4DpuXr8wg3wE
         3NS/jZQiUjHYQ0eXi6xwFhWsiPjHfYxcxBBXhp7qCG5+CLvFighR1Ip+oldC7EAjlnmn
         AQYoFIOikLnuaYSLvTG7RdkIL9xW+/NVW+60IGQblK9/vc+6mh5cyqswKNQHxNmQoZco
         ZK5A==
X-Gm-Message-State: APjAAAXYPBBpAuj3KT1trhj3V6TKik2FMbLf7jRLcRrIBiOY6QPycB/q
        mGKvrHPUSBGwU557C9qLNxg=
X-Google-Smtp-Source: APXvYqxVjmDhScNxGbIjm/yVO6pgegX5Hl5lY45AI2Bn3fPWaXVArUsyng7uVnCRMsUX+PeVT4dQlA==
X-Received: by 2002:a5d:4b81:: with SMTP id b1mr34396913wrt.217.1558624725412;
        Thu, 23 May 2019 08:18:45 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x9sm12687071wmf.27.2019.05.23.08.18.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:45 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/5] kernel-shark: Use the shared versions of the trace-cmd libraries.
Date:   Thu, 23 May 2019 18:18:10 +0300
Message-Id: <20190523151812.31391-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523151812.31391-1-ykaradzhov@vmware.com>
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

You may need to clean Cmake's cache after aplaying this patch:

cd kernel-shark/build
./cmake_clean.sh
cmake ..

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/FindTraceCmd.cmake | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index 21315e7..7ebf8da 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -24,12 +24,12 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                        ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
 
-find_path(TRACECMD_LIBRARY_DIR  NAMES  trace-cmd/libtracecmd.a
+find_path(TRACECMD_LIBRARY_DIR  NAMES  trace-cmd/libtracecmd.so
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                        ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
-find_path(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.a
+find_path(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.so
                                   PATHS  $ENV{TRACE_CMD}/lib/
                                          ${CMAKE_SOURCE_DIR}/../lib/
                                   NO_DEFAULT_PATH)
@@ -38,13 +38,13 @@ find_path(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.a
 # search was successful "find_path" will do nothing this time.
 find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd)
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
-find_library(TRACECMD_LIBRARY_DIR  NAMES  trace-cmd/libtracecmd.a)
-find_library(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.a)
+find_library(TRACECMD_LIBRARY_DIR  NAMES  trace-cmd/libtracecmd.so)
+find_library(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.so)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
 
   SET(TRACECMD_FOUND TRUE)
-  SET(TRACECMD_LIBRARY "${TRACECMD_LIBRARY_DIR}/trace-cmd/libtracecmd.a")
+  SET(TRACECMD_LIBRARY "${TRACECMD_LIBRARY_DIR}/trace-cmd/libtracecmd.so")
 
 ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
 
@@ -61,7 +61,7 @@ ENDIF (TRACECMD_FOUND)
 IF (TRACEEVENT_LIBRARY_DIR)
 
   SET(TRACEEVENT_FOUND TRUE)
-  SET(TRACEEVENT_LIBRARY "${TRACEEVENT_LIBRARY_DIR}/traceevent/libtraceevent.a")
+  SET(TRACEEVENT_LIBRARY "${TRACEEVENT_LIBRARY_DIR}/traceevent/libtraceevent.so")
 
 ENDIF (TRACEEVENT_LIBRARY_DIR)
 
-- 
2.20.1

