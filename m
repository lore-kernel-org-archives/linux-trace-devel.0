Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE05C4167B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 18:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiLOSeD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 13:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiLOSdh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 13:33:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29AF242
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 10:31:59 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso4774024ybx.19
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 10:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cQiNqKdPjqw4QnOS79pxkaJEwk3jEFOQF0llvUiiH9Y=;
        b=renTso6WCBWxtuszmFZjnngIPAOzTdnVDmy8FwnqudUHboBAfGWw+ZYgRVqul4cTJ+
         9vXIPh8dfha7sQdQPAiJRG0Z/B82L0TYgNQBho7MZWWh4EQSVzzavcSUIhjVoiXWSwv2
         zH2jIGpJ4mHsGTwBvS6nWMEhNLT4AlpS2ALruUJwKEorQKywvCyBySu5iSVJo3Ep6uQt
         8Aq48itutjckr5TBtNjDhgcXT2BSoVAJI8Ea6FpfhYejon8VbTzS6zlh2fKnMDCFqk3K
         JOS6KmokNCxw6xI5mXypuW/zjZZiiLygTuXThXRg3o0NIVAbY2IwnFipzirGLCjj+rLd
         E6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cQiNqKdPjqw4QnOS79pxkaJEwk3jEFOQF0llvUiiH9Y=;
        b=Ur80+flm7deN3YF0kZ697pFix/lFXvlJm26GzNWnUs7/6M6tRi/bpVRoLBSpz2JbwT
         /7Q9WOvROAqJ2AeVPmquhwC+AHbHNRb6GAGUjdcXJ2mYSm3WD5Owq0+akEoXSJcLE05N
         tKbJ1X1KEEe503+D18AXdzkSxsCM/PveUhdHMxpgGG9peTqAQ1UC06nI7jWsEOqw8Pfq
         GaQFpkg5NGZlaUIdNAdPqVHdn5jWZagxvJNvTZ7S+inIR+tbArFR1B1wdINWutWWsjWf
         fmcs9Fd35NtIbTqe8mqaNf7+QZxOIPcGTL98zoG4bJAmwmp/69i5r9HZaysIzVqksRf2
         fwBA==
X-Gm-Message-State: AFqh2kqSIyAmuJcaG8pFa6MGJ8EBM5nrDkaR6c8poEeuz9plH8H2MMha
        F7ecssuY1ruq4l2SzegM4SeeOA5ypjehznQiXSrgXWPKcfcK5bFPMi2lfY/33ijuvuud9bstYYT
        c2M9cnM6riPVzLZuCwZwspNiwYoy+X/JFZyAO3OaA8+cu+TF7aEvCe3q8Tfv/NiN/nWwgHZNHZG
        /sDCU=
X-Google-Smtp-Source: AMrXdXtWeIFDBVzvRDQ8zhyYdo7h2YF/kbn3w5QdpFyqX4VYpTO01lAzPbLX9S2aDyqm+hfqaMdNFLJ4GJQF
X-Received: from irogers.svl.corp.google.com ([2620:15c:2d4:203:de6d:aa93:7423:e679])
 (user=irogers job=sendgmr) by 2002:a25:6f46:0:b0:739:a1c7:f11a with SMTP id
 k67-20020a256f46000000b00739a1c7f11amr102751ybc.461.1671129119188; Thu, 15
 Dec 2022 10:31:59 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:31:50 -0800
Message-Id: <20221215183151.2685460-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH v1 1/2] libtracefs: Move initialization below a null test.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Computing the address from a NULL pointer results in undefined behavior
which things like undefined behavior sanitizer promote into real
failures.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-dynevents.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 48bb26a..02e8023 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -709,13 +709,18 @@ dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 	      char **event, char **prefix, char **addr, char **format)
 {
 	char **lv[] = { system, event, prefix, addr, format };
-	char **rv[] = { &dynevent->system, &dynevent->event, &dynevent->prefix,
-			&dynevent->address, &dynevent->format };
+	char **rv[] = { NULL, NULL, NULL, NULL, NULL };
 	int i;
 
 	if (!dynevent)
 		return TRACEFS_DYNEVENT_UNKNOWN;
 
+	rv[0] = &dynevent->system;
+	rv[1] = &dynevent->event;
+	rv[2] = &dynevent->prefix;
+	rv[3] = &dynevent->address;
+	rv[4] = &dynevent->format;
+
 	for (i = 0; i < ARRAY_SIZE(lv); i++) {
 		if (lv[i]) {
 			if (*rv[i]) {
-- 
2.39.0.314.g84b9a713c41-goog

