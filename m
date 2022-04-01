Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE8DC4321E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Apr 2022 23:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353464AbiDAXpT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 19:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353441AbiDAXpQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 19:45:16 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A03B1137;
        Fri,  1 Apr 2022 16:43:24 -0700 (PDT)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id D9D1820DF566;
        Fri,  1 Apr 2022 16:43:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9D1820DF566
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648856604;
        bh=Oh80tgumXtzVzhggUEiO+Gt+FYTYz042ycLpTb3589E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf4OEVSZYqxagEaoFE4TbHt24MEmYbnLV7aIknrOlR6tzp6QaNC9WopANU/Kuf9Ah
         n6eaEFJtsa79RTpsRwi29DGZQVqE1AuZ0O4reRG8/SoQl//xziCPtcwLU4oU3F78Gk
         xQ2UbCKazJ/HI2ZrodtV2lD+LcLQ7BIeituECbRc=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH 2/7] tracing/user_events: Use NULL for strstr checks
Date:   Fri,  1 Apr 2022 16:43:04 -0700
Message-Id: <20220401234309.21252-3-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401234309.21252-1-beaub@linux.microsoft.com>
References: <20220401234309.21252-1-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trivial fix to ensure strstr checks use NULL instead of 0.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index a6621c52ce45..075d694d20e3 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -277,7 +277,7 @@ static int user_event_add_field(struct user_event *user, const char *type,
 	goto add_field;
 
 add_validator:
-	if (strstr(type, "char") != 0)
+	if (strstr(type, "char") != NULL)
 		validator_flags |= VALIDATOR_ENSURE_NULL;
 
 	validator = kmalloc(sizeof(*validator), GFP_KERNEL);
@@ -458,7 +458,7 @@ static const char *user_field_format(const char *type)
 		return "%d";
 	if (strcmp(type, "unsigned char") == 0)
 		return "%u";
-	if (strstr(type, "char[") != 0)
+	if (strstr(type, "char[") != NULL)
 		return "%s";
 
 	/* Unknown, likely struct, allowed treat as 64-bit */
@@ -479,7 +479,7 @@ static bool user_field_is_dyn_string(const char *type, const char **str_func)
 
 	return false;
 check:
-	return strstr(type, "char") != 0;
+	return strstr(type, "char") != NULL;
 }
 
 #define LEN_OR_ZERO (len ? len - pos : 0)
-- 
2.25.1

