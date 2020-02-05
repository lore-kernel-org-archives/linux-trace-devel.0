Return-Path: <SRS0=zdMd=3Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ACCC35249
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Feb 2020 07:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A69B62085B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Feb 2020 07:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qCJSvVwQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgBEHHs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 02:07:48 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44338 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgBEHHs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 02:07:48 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so675343lfa.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Feb 2020 23:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pmxQJCdLKR3h2MlakR4GiAXlc7H5M2V5Oh8uW6+8pWU=;
        b=qCJSvVwQWm4n9DKA+nAWD0BwdinZdf6H2DqYNHvoBcxc1FBtcYaO+FZmH7F7T64tVD
         GBjnMZejNfQBFzPVQWiN3Z7WBrCg86u0MlqfG3HuekBX2BqB6Bzm7cSkmV9XooocRo9M
         BgpY4htbihmfPG7Y/67UID9yeskbFYBracUlh7OiqkDjfm0fGTkEI59SAj4/TmbHrb9A
         9hbDspp9gpvyEp4QZ8OvF4RZc+yUhfwvlrUf94Vxdyr9Nx+taFxWWnR4q7Jx89na1ASS
         djG6HLWf0tvfchttEIRt61nKIyNouEsCSjjAXQbhUpQaxKflp2HYbo7S9xO9fQml2K43
         WBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pmxQJCdLKR3h2MlakR4GiAXlc7H5M2V5Oh8uW6+8pWU=;
        b=ix8NBw8wUcatBFwLd4w7fSZk3XchKvgot7zi5Can3ge/LX6T213VIvtXo94G36ZvTn
         vCrwECkOHs9r/ptx/zvGYTSka5ysQtrmpQW8XBpeAFwknVFxOBzgiDGivCynFcjNqpz3
         LwXV/J7DkG++5D4klGH1IXqZn2GJpmF2B0llWiT7wDKWX/hUG1l/At/IVGyCqc3PoKc+
         XKtykejK8aswHuNtW/IwwSEuiAbdYS1ttl+DpaipIFo0ltBgYoB4OlcaGNzibQQgzWLa
         TmYaEmsIpYOSjQ5eruf/bPa0cbC1USFhspF8y2Mo6apIE4vi3kZoMNfp2iS5k88aHZGb
         t2Mw==
X-Gm-Message-State: APjAAAXKVcy90VhDGcfmCVesNqsMHjg0+ojdvsmx9flGtG8ruiANgNRJ
        UHeTirvPoZ1aPlcehOgS4GN1Wc2g07k=
X-Google-Smtp-Source: APXvYqyL+4xqX3iIw8DVO5w6w+XnPcd5xfzCVwoGLNSb087IlFiY7rjL/WQ0rVMuS9RccuIVosShOQ==
X-Received: by 2002:a19:748:: with SMTP id 69mr17236115lfh.40.1580886466459;
        Tue, 04 Feb 2020 23:07:46 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m24sm15172893ljb.81.2020.02.04.23.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 23:07:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: Fix search path for libtracefs
Date:   Wed,  5 Feb 2020 09:07:43 +0200
Message-Id: <20200205070743.13836-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Cmake uses wrong relative path while searching for
development version of libtracefs: lib/trace-cmd,
but the tracefs library is located at lib/tracefs

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 kernel-shark/build/FindTraceCmd.cmake | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index f27fafe..c29b779 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -43,7 +43,7 @@ find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
                                        ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
-find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a
+find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                        ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
-- 
2.24.1

