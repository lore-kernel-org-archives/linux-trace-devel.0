Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBB7C4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD7B60F56
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 12:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhHKMMl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 08:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbhHKMMl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 08:12:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789F4C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 203-20020a1c00d40000b02902e6a4e244e4so1798594wma.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xVHdHGYjX9UVBzG4KqE24R9p9HjA9/m50lIgXZE/w7M=;
        b=cvAKRIXw98+/UbgLmcrNY1Hz3vxSpQwvNy/tWthJn/3klGL0a+d5TbUk2CLAE1uFN3
         ckRHg1zOTPD1ZvyMEd0aSa4yRVRK8cM+ELvsFkkxAvB3Z1G9MCoVUzAk78mYFOAapJqC
         DRNLrM3woHwzl5t9j0sq5ZxVT5udVICgqENtLiE7bxtq8sAdGXqVqeBWvkVOTNq6gn9H
         ygSzysBvgO63xuzhZIJvmhXAuFst9RGq0Z7BmiQ5Ks3OrXpZFeAQQoXD23JBDe2tjlw0
         qaGoffrXX3I+14Vv+OVFh8AM2hvZ0MwMJU4bLtJWJDS/jYx77OAT9Lz09oN47hQWtiPh
         c6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVHdHGYjX9UVBzG4KqE24R9p9HjA9/m50lIgXZE/w7M=;
        b=afoiM4r95PJgyCapAjrTlsF5b7pcWRtFLGntdXligNaG492399BnSxqP6lRKu/sXqa
         M2u/g7mDuuonGxnk7aGzGsrVDU88mr1WYHGw7SSDdTAooASn2bfOXBB7QGRXNmYvw+Ni
         GLCDP0Ez3bT/aBOSC6qodDsnBZ2YVSLsxUYy+J/q7CxhgQ0LE8pjHWE2qYxrtQ/c6Fyj
         oXhBB9u73bvCIbRfwuV1aAtZUpO3/qqJUQwSU/w+2qf4L4PLu/pPwtU5a9DBZIaQqiEY
         LmigoFzp8CvKcX11aHmfs99ZKxampST6IsmgAnSuxHFzhNhCDC4YCMcAi0K6WJmA3KMv
         gLBA==
X-Gm-Message-State: AOAM531MEPxeX+F8WENUnIll44bicxnDYxF+N7OF6oGS3RKhOdcKiSAc
        jgWkYc/+sXM3z1Wlhuby2s8=
X-Google-Smtp-Source: ABdhPJxdXPLIY72fRMKg0G76AGawAZy7mx/COalJ66S1CUOs8DvSbl49paavyM8ekuq/NPpuZX6utQ==
X-Received: by 2002:a05:600c:4f83:: with SMTP id n3mr9707043wmq.123.1628683936137;
        Wed, 11 Aug 2021 05:12:16 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id k1sm27104011wrz.61.2021.08.11.05.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 05:12:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 2/5] libtraceevent: Have all field args point to the field they represent
Date:   Wed, 11 Aug 2021 15:12:00 +0300
Message-Id: <20210811121203.29123-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811121203.29123-1-y.karadz@gmail.com>
References: <20210811121203.29123-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

In order to have tep_print_field() print the field closer to the way it
is printed via the "pretty_print" method, all field args, must keep a
pointer to the field it represents.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index fd6d916..1a8cc54 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2334,12 +2334,12 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	arg->type = TEP_PRINT_FIELD;
 	arg->field.name = field;
 
+	arg->field.field = tep_find_any_field(event, arg->field.name);
+
 	if (is_flag_field) {
-		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= TEP_FIELD_IS_FLAG;
 		is_flag_field = 0;
 	} else if (is_symbolic_field) {
-		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= TEP_FIELD_IS_SYMBOLIC;
 		is_symbolic_field = 0;
 	}
-- 
2.30.2

