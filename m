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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA7CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 04:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB55B61029
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 04:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhHEEgc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhHEEgc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 00:36:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A18C061765
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Aug 2021 21:36:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e78-20020a2569510000b029059206351038so5170036ybc.22
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Aug 2021 21:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=U/unuY5uEryQZd2feqa/U7cr6gDE1sLQP0xIJ6EIRUk=;
        b=TfU3/0Blg7ma2uriJLj+8l+EzFmIqD67vvflFQdwDzdYA0gf3ykrZ9FcVdRZ3OFTKS
         UPO8vBROqEhzkTStpkmxyKXzccbzwcp5aBcl/RjD937JSp5uPlDo8TeREK7098CpLCY+
         qczPLpNaWsZXc+JqhiJo6gOVlLDmjbKU8FSrG3Xp4kTfmT1kn7VgnbQift31zU2JRvvX
         tUXTNtYG2hcezwpy1xeuSS/ym90YgefLkyWT7IyBMBp1wjFfTYjOjG9anIXjfA38Y+mB
         VjUeTZFK9HLSUCiN4d36AAZ216SZQIrITAEGzRLpdEhAZMrQ9La6qq8Vdt4G1I7apl7s
         jjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=U/unuY5uEryQZd2feqa/U7cr6gDE1sLQP0xIJ6EIRUk=;
        b=qff6MMfKkPJ/AXh1y0eSy5wAq0NWuCYvDKFtrrPCcTEohb4Ogpk1keug/EsIbTsP1r
         xE4fbBbRUyz9j/oboSDVAO+4B2lRoSGgmBZVZeZIx18T+v9I/AxND8RxHhyqZOEO6yX8
         qQhVBhyCpfwBHDtCw5g7usCNcqcHRUGqhBEiU/9Z20brRzfBmvqd93X7Hii339i+w/4k
         pJ5O68wUgf3bSrjB7GY2JVvKjvqkp/juI21Lm9ytcNioNXPmscQoD7cmZ4M3dZ86d2bl
         sLPqXlPig7VbHI5Ik1UMmchtkmP3T/4LzgmlAn9qPUPIkgYujH0Fg7B/8c4r06inrCYg
         pE/g==
X-Gm-Message-State: AOAM531bClXX7zMRNSsg8RiMbmAh6thrG9PSsoniOL6zPOxrUp8mP6De
        gQxS5dZ/6KjpumnZ0jt5GzmXN7c6+GQ4lQzZOoad4jxT7DhtDGQ4hCOMv0vAWvEwx7dWNtf0t35
        VlXLf7LUuaxYBaNhyMxBCobV9uwGBml3zHkuLkznkd5QubCWq5DHRQY150J5tBDtOy7+wINhyyL
        HQVPQ=
X-Google-Smtp-Source: ABdhPJzbUS94TY8+CNt3rxnUamyhkv3YiPUc5ncVB7f2MmNvY52Do7X6AIE4rNFYn1BpaBiqqY5gKD2xIPi0
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:5ce4:b09b:a28f:3bd3])
 (user=irogers job=sendgmr) by 2002:a25:14c2:: with SMTP id
 185mr3593028ybu.374.1628138177869; Wed, 04 Aug 2021 21:36:17 -0700 (PDT)
Date:   Wed,  4 Aug 2021 21:36:10 -0700
Message-Id: <20210805043610.2116406-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] trace-cmd: Fix out of range comparison
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Claire Jensen <cjense@google.com>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Comparing an unsigned int with a uint64_t causes zero extension of the
unsigned int. This doesn't allow the unsigned int to ever equal LONG_MIN
or LONG_MAX, i.e the branch is always false.

This issue was caught by clang:

tracecmd/trace-vm.c:340:37: error: result of comparison of constant 9223372036854775807 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                if ((cid_id == LONG_MIN || cid_id == LONG_MAX) && errno == ERANGE)
                                           ~~~~~~ ^  ~~~~~~~~
tracecmd/trace-vm.c:340:15: error: result of comparison of constant -9223372036854775808 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                if ((cid_id == LONG_MIN || cid_id == LONG_MAX) && errno == ERANGE)

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tracecmd/trace-vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index d204411..02979ba 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -337,7 +337,7 @@ static void read_guest_cid(char *name)
 		if (!cid)
 			continue;
 		cid_id = strtol(cid + strlen(VM_CID_ID), NULL, 10);
-		if ((cid_id == LONG_MIN || cid_id == LONG_MAX) && errno == ERANGE)
+		if ((cid_id == INT_MIN || cid_id == INT_MAX) && errno == ERANGE)
 			continue;
 		guest = add_guest(cid_id, name);
 		if (guest)
-- 
2.32.0.605.g8dce9f2422-goog

