Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DECC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 23:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiBXXtG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiBXXtF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 18:49:05 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8441AF8CC
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:48:34 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d726bd83a2so14215417b3.20
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7Lg5kU6W9eh0qus/LLWFm9cWMJt/6AjrbG9lw4UNRww=;
        b=cZkS8d7xgjY5ZrRxOeIuQw7sgf/eB2eb8P+YODHwAYm1sMJ1a/s3Wm61t2FGi+FYY6
         h168PU97wd/RMPBlHzWY3YySYWjvwKfCA/JbwyxnrmwC/kE8AETInNKte+Smq7a3twPv
         tXBYIfJ57N5j0LqlF2zqb1ZrfTzDG/5WNVs2P6JpRxGuE+HWafWggjKQnWWkPFKMw2ID
         clNx3Nv8PQ39TSAPCyEKxia/wa+pwAzkhjpP3vmBPzJ+rcQ4ot6smz/3oubZLrl7y6xg
         myXguCzOEnTBmfRl5I2vUx+eO7Np1DKkNQQH7X6WNr+eC9VYajzq/71xXjrKEXv0Ys8/
         h1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7Lg5kU6W9eh0qus/LLWFm9cWMJt/6AjrbG9lw4UNRww=;
        b=CVSKQJIMDcPj76PjqAK5Kr4zVUWHgw/s2UVIuHwSl7qNUb6U7Vu5A9D4zv+vuF1OB9
         dv5xI7tKoHzIxP/n4A8EYD7h5MOotOBHC+wvDZRFOM0JYwqaimNHhfqVO1VW2FcgH0j9
         KjZN2go0vNRSsZT5ArXkSNynv7s/oNkWZl3aNTbaZvnOm6aBYISTKfFo/ZFn6Kt/qyA1
         BbK5UpDAl7oV8IzWwKUwcRGtqJPOLAgDxyDIrPUE8x/vtl06IbX8Bd2ToHB9aKRYBW9r
         ukFbR935MdiPTzgYKbVIjgo5QYA4122OR9RGIZjU+QWDkWEwWLuB6MuR8Ro/eMJpxTOo
         eKtg==
X-Gm-Message-State: AOAM532UEXrp7Nb/039Wh8MCysVOBjrJM2LvicMUNZuSOU7Zp0z+lEgo
        fE7U1XsUksVxWd4FmunPSSFsWZ3Fnoe9EQ6bN1sef8obPcNQAQG87XFOkzPUwSmMVG1SrzbF4XP
        AtVXFdyas0Of1qmHrSFbNZYgN6q+bZf2ikkc/ZEZntzOOa0HBiF07i53YpsmcomAwuc6LmILOzx
        8xsxc=
X-Google-Smtp-Source: ABdhPJyoRlBGhdyjp24EpHqYIGzxJwi5AuSglJ1qA5OidBkndYFCkeLsZpe41pF7vDIEhGPqHNoEf7HEPEcH
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:213e:9e73:c323:5ae])
 (user=irogers job=sendgmr) by 2002:a81:8414:0:b0:2d0:fdd8:f7e2 with SMTP id
 u20-20020a818414000000b002d0fdd8f7e2mr4859200ywf.156.1645746513980; Thu, 24
 Feb 2022 15:48:33 -0800 (PST)
Date:   Thu, 24 Feb 2022 15:48:23 -0800
In-Reply-To: <20220224234823.1190425-1-irogers@google.com>
Message-Id: <20220224234823.1190425-3-irogers@google.com>
Mime-Version: 1.0
References: <20220224234823.1190425-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 3/3] libtracefs: Move initialization below a null test.
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
index 61804b9..8fee474 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -724,13 +724,18 @@ tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
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
2.35.1.574.g5d30c73bfb-goog

