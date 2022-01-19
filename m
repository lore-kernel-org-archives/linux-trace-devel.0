Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89991C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 15:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbiASP5p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 10:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355867AbiASP5o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 10:57:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69674C06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 07:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0731961534
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 15:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F075C340E1;
        Wed, 19 Jan 2022 15:57:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nADLC-007PZl-85;
        Wed, 19 Jan 2022 10:57:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 2/4] libtracefs: Fix typos and grammar in get_affinity man page
Date:   Wed, 19 Jan 2022 10:57:39 -0500
Message-Id: <20220119155741.1766541-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220119155741.1766541-1-rostedt@goodmis.org>
References: <20220119155741.1766541-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

There were some mistakes in the man page for the get_affinity() API
functions. Fix them.

Link: https://lore.kernel.org/all/CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com/

Reported-by: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-affinity.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 0f3093d62035..107334dd1298 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -24,7 +24,7 @@ char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*
 
 DESCRIPTION
 -----------
-These functions set or retrieves the CPU affinity that limits what CPUs will have tracing enabled
+These functions set or retrieve the CPU affinity that limits what CPUs will have tracing enabled
 for a given instance defined by the _instance_ parameter. If _instance_ is NULL, then
 the top level instance is affected.
 
@@ -71,7 +71,7 @@ RETURN VALUE
 ------------
 All the set functions return 0 on success and -1 on error.
 
-The functinos *tracefs_instance_get_affinity()* and *tracefs_instance_get_affinity_raw()*
+The functions *tracefs_instance_get_affinity()* and *tracefs_instance_get_affinity_raw()*
 returns an allocated string that must be freed with *free*(3), or NULL on error.
 
 The function *tracefs_instance_get_affinity_set()* returns the number of CPUs that
-- 
2.33.0

