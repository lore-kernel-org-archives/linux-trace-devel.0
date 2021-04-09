Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B2BC43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 616766115B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhDISEy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhDISEx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:04:53 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807BFC061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 11:04:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g17so6817577edm.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Apr 2021 11:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uFCmyoZmsYF6TR1HKFUQCv6oPEMxr+ouFLjkaPL86hk=;
        b=rcNAu4KRXpyZXhQGq/pbn6F5+RELDegRgQ/oHjtrY/cli+gVNcE3nQIni6MKg65NEs
         /M8/f9BO/MwE2FqqT20qPDxuwmZCoQ/5FKecAtEBdXDlltwjDq6/1R9CHPRQjIQYLdUJ
         nZ64+4a2N3isPobctrBy+bDIiDf6zbPznygbxPovKHh+zjQpYQ47Cuy32wr0TtPthggf
         BeeKDcgZjjv4etfmsmM47rWq9RMn+3kn5VqMWWISm3HQyzqecEZh2meMlbTbxQpq5OjX
         s8wS1SWosLiHO2yHrrY3DAWJT4FdkOUtzUfyNkh6XU2P7WGb5hg92nRKyWk1Phl+Aagn
         I/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uFCmyoZmsYF6TR1HKFUQCv6oPEMxr+ouFLjkaPL86hk=;
        b=bhNxhApFczdeEkI1bLZmbRw4BDZH8mxUhsnUs/0hqEeTed4GdR0wCCS5Cs3WPNJx3T
         wdRe1xm4z+iJqRpzn3i+SVmeqI6xuIhsiuLx/A2SbkDs6HUk1IHtxh4TS4re+J7yY/+Z
         rvM85tnqq5Hrp1Nwg6bNXN2+S2FspWhBeQswHWh5M3aeYt6z7PULY3kgtOIve+HCWwCp
         WV5ExS5j4lkP+X0O8AWyfRTSlCeLvBE3mQaWk6J4eq+b8wt6dawc+HNIxbE4p8HAHgNJ
         xYd/aRS+/RQjpUw+GYZRNf8eWEUbRykjWfHFb2sO7gGdeba7q2Dz8ClfRAnefukx7v4x
         EgxA==
X-Gm-Message-State: AOAM530n6x3D1fbbg0mBYUgKWLLVnCgbsCtaf9TAAJbgxBmNne1KEBww
        476MFjMWzQ3IDafxNmLW3KY=
X-Google-Smtp-Source: ABdhPJzUu8BZpFFz/iWdKECMiTIJa99GSICWJVQUSWLJeNpZtXcSD+YlrKJuWCOjFOUhHHLf6zqDjA==
X-Received: by 2002:aa7:cdcf:: with SMTP id h15mr18696189edw.28.1617991479231;
        Fri, 09 Apr 2021 11:04:39 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id b14sm1865568edx.39.2021.04.09.11.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:04:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 1/5] libtracefs: Fix issues with tracefs_option_id()
Date:   Fri,  9 Apr 2021 21:04:19 +0300
Message-Id: <20210409180423.72497-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180423.72497-1-y.karadz@gmail.com>
References: <20210409180423.72497-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Few mistakes have been made when introducing this API function.
First of all, its declaration is missing from the header file.
In addition to this the argument type is missing "const".

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 1 +
 src/tracefs-tools.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 70b7ebe..d3db8b5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,6 +145,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
+enum tracefs_option_id tracefs_option_id(const char *name);
 
 /*
  * RESET	- Reset on opening filter file (O_TRUNC)
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index d48062c..f409def 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -192,7 +192,7 @@ const char *tracefs_option_name(enum tracefs_option_id id)
  * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
  * unknown option name.
  */
-enum tracefs_option_id tracefs_option_id(char *name)
+enum tracefs_option_id tracefs_option_id(const char *name)
 {
 	int i;
 
-- 
2.27.0

