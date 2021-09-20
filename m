Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E57EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 02:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B0161183
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 02:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhIUCuN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 22:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346490AbhIUCSZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 22:18:25 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C8AC09B12B
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Sep 2021 11:37:23 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b20-20020ac87fd4000000b002a69ee90efbso8814524qtk.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Sep 2021 11:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=d3gUSjIa26VWKSKKG6848HU8WNz+Wzy8iG8o/CBkKD8=;
        b=hHT43r1Nb0UAh/hzGq93oKwf/q1KvBwsZ/6X1sB+gP7R8+CA+n56M6XRUjR6Rlc4mD
         FuzhM5TA+eODsJZvZOHr5XCp6zLRfFLvixTmCrijiYVgqRqZgwDlcyLOB8jc66y5H8XN
         2mJe1FRP1oXz4b4zV981o1ZGkpqZa0KXvcqUoROxRGidzTH+Twg1e360Wdw+HOgRytdB
         LhHauCtfO8OkusKWe41351BEXMY0kZET4oBi4JAUYPDfLW3dG787AaKJGif2YfiwM8oY
         /rJAVaDfcCNAZ/BPqKyzxT+B4pYYc3OTm5tqFEfNI6e/nQmcjEZGwFhbYziJISsV9tvz
         mMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=d3gUSjIa26VWKSKKG6848HU8WNz+Wzy8iG8o/CBkKD8=;
        b=fpuMfVKocQFRgPOat/JfIh0Y6YyglMfg8lncLG5lUB5UHLX7ecQumfHQIvaX1LLvja
         uFUTQy6RPn6Dp5+eV9Xiyb86HFw8D5yYLzJu8foqyJ23PdoKk6C9pgcUs+Zr6bluqnVT
         LGUhs3reChqmySb0hr0XfAViv3KiVQ/u+LK8EpFEDfKWagSSzKpt/IFINTt0E5S/8Sin
         lbXPxi+GC8vm+MqRj3H4LZMj2OikHOBCEZDxw5oqQZllIfC2abV9ivbQFneqGNAhRltm
         1HrKedfI6xrDXmxgB9qRhpcZjgJNOC8hnjEtP7w55PYwdu4B5e4mKk4m7nLFF8YB40oX
         QoQQ==
X-Gm-Message-State: AOAM531tQK7yy4ZpNu9Zu5A+EYp/dR2QolI3FfAuFrKtmFEpiGuXLtTS
        HiORUlJMwyNOIL2KJYbUYNe0XWq5BZNA9q2YLcyKcpAzrsCrzKV4ahNN7EiWLJilygnigsTibhb
        cEoTV5BZ4fRN4gShvBYy1n0KC6RwA5QnO7iiNwHda6k/FoB2R9dtFp6hknzFk6eonKPke+3M+TS
        DaLp4=
X-Google-Smtp-Source: ABdhPJzaMz/IdN508rishVh4oLQOYL+ysQMc+d+2EgDLWuJLalvOYwZle/ali3S1GGuonLgYCEub9fEV/le9
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:b49c:1db4:1370:c581])
 (user=irogers job=sendgmr) by 2002:ad4:472c:: with SMTP id
 l12mr19070139qvz.1.1632163041351; Mon, 20 Sep 2021 11:37:21 -0700 (PDT)
Date:   Mon, 20 Sep 2021 11:37:15 -0700
Message-Id: <20210920183715.33377-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH] libtraceevent: Fix for print_field
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Correct a typo in an operator which resolves a clang warning:

src/event-parse.c:5408:41: error: converting the enum constant to a boolean [-Werror,-Wint-in-bool-context]
        if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
                                               ^

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 8057fb5..7063758 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5405,7 +5405,7 @@ void static inline print_field(struct trace_seq *s, void *data,
 	if (!parse || event->flags & TEP_EVENT_FL_FAILED)
 		goto out;
 
-	if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
+	if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_STRING))
 		goto out;
 
 	start_parse = parse;
-- 
2.33.0.464.g1972c5931b-goog

