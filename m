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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB6EC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5586861A10
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCYGle (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhCYGlD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:03 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AED1C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o16so1158380wrn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dyWukcMW7GmZiqYJEO7XCZFR0f+MugJSuQK6wQtLAAk=;
        b=mwv5ZodNmtXWD52VP1bNxJ+kGD/uZzYdhPSiPYrjF6SBOW7wFACvPHDSOwIzxyTpnX
         raXzwPKkmiOR+8Y1G1JH7Y6zhi/dDT6rAUrn1MxzBZiBAQfd7+4BabIwnAdYpw44jJTJ
         CweZ87x/WUv2SSThKcBtIyJqCpJcReIUoMe6qH4dct9t65feSFvMEXg4UOazXzf9yiDL
         PA/1XS/I7IjiwQrCrDcajKextro5R2+5WC5b38COeWEe1WxAhIPxHBQsrV9ckPNMNmrg
         XkgLBtEjzSugxAl0APKa5ilkQw8OJpev0HRhi4GLTESfyMcvOrNdVxGduNu5Fd+/M7Xv
         L6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dyWukcMW7GmZiqYJEO7XCZFR0f+MugJSuQK6wQtLAAk=;
        b=Zt3ra7VFN25DJ8nC50R0RLNnC2OrWr9Ayx26GWa57y9mRuUK5ohrmR1NUMaS4z167j
         9igX2OG+ArVuLqfDUe8xXXUraRm/zLRiaLcxewEqLKbYzWKh84ln2G0amIUk/2TCdFRW
         2i78V6/0g+i/Sed1CaSHYxzGXjCysr9y/PzQ5RQ01mFwaHjmuk7s3uzr4I3qehjZMCR5
         WuJftMHYtj9XfaJeLGlztpkr6q7wE9H1nIetoIA4neZTRPh63PZqgk4VEHV0zhc67N/p
         dpzFQX2gWAcXQEVDfjpSpYu4e0Ik0h/Lb6zw5hhzFb7RgBqen5TwWbN7ilB/cpTkUKe0
         o2bQ==
X-Gm-Message-State: AOAM531+FcRfTLUorM3mTwgDCN2h9mbpDWAx3D2gJVV6VukqMHZi9zWn
        C+5aNrBsRVikoLwHkQJqOuU=
X-Google-Smtp-Source: ABdhPJyze9/yTb7Rb8i88eI1osLBmmLMvyAhYj5NfgiW5gAzhz+hvuQ9LHhXZwCxKIKBVUJTRqYMEw==
X-Received: by 2002:a5d:6a86:: with SMTP id s6mr7275925wru.307.1616654462388;
        Wed, 24 Mar 2021 23:41:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 05/23] trace-cmd: Add new local function to check if a trace clock is supported
Date:   Thu, 25 Mar 2021 08:40:37 +0200
Message-Id: <20210325064055.539554-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new local function is added to check if a given trace clock is
supported by the ftrace:
 clock_is_supported()
This function is used by the other patches from the set.
The logic should be part of the tracefs library, when a tracefs API is
implemeneted, this local funciton will be removed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 635897e1..c7197ba0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5683,6 +5683,34 @@ check_instance_die(struct buffer_instance *instance, char *param)
 		    tracefs_instance_get_name(instance->tracefs), param);
 }
 
+static bool clock_is_supported(struct tracefs_instance *instance, const char *clock)
+{
+	char *all_clocks = NULL;
+	char *ret = NULL;
+
+	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", NULL);
+	if (!all_clocks)
+		return false;
+
+	ret = strstr(all_clocks, clock);
+	if (ret && (ret == all_clocks || ret[-1] == ' ' || ret[-1] == '[')) {
+		switch (ret[strlen(clock)]) {
+		case ' ':
+		case '\0':
+		case ']':
+		case '\n':
+			break;
+		default:
+			ret = NULL;
+		}
+	} else {
+		ret = NULL;
+	}
+	free(all_clocks);
+
+	return ret != NULL;
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
-- 
2.30.2

