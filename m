Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F36C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiFFT7R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiFFT7E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:59:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5903C6353E
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:59:01 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e9so3143430pju.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jun 2022 12:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3J9EOSaJLHILFZZeBSOPXwCDa8pm36JAUYwAlOw8WkM=;
        b=dsQmo82nF2iKpZkuE52uk9pqyrgRKg1vvEHOAZg+5RcRLU6yQdqZyPJ0Lbbso80Qud
         j4OStWe75MuGL2cgYzDoC67gJPOzB6KChu2JSc19RvrSArszv6mBYAIfz1pucxdZ1n4P
         QBoiSY61QMIQB9xuTflfkdZfKYx9WoiB7GKKAvGWO2D24KrOlVwWZNnhbthU55PH9JjI
         JYKoRXN29AHG02QfOyvzQpNjTRSMSUnesJqohUMENYOO2ePE5f4hAD7rJiPeg3tZmQ4q
         P4gD1334Aze+k9mY+iP7xNvpXxj6a27WmAHa/7ikMUDzd65KGBWBzLIP6QFfQfUjCv52
         Ua5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=3J9EOSaJLHILFZZeBSOPXwCDa8pm36JAUYwAlOw8WkM=;
        b=AMj536LEBFjJQMmFEiBz5IgxAJFgb1qrnDuJ4a/07db7kPqVbDYxEkrNEczFPRDFfl
         7qQSvkf2oUZ5EezSmo4HjswtYlH7ZLMVWsYqjc9eEOt4armt+O5+800tUB1tfK6pzzOY
         5VK6dMPtbZaumMFXECzC8JY9BzwqAd32/L6CSvkEK18lDGm6zpvtN/COriO69QMRMXT8
         pTtffGV8Lm7j4/S63zKEoer+u41n5TEk5ANcuwe8+K5Kqv3OJEg4FVukNpXIhwu6V1hu
         j+k8XqXrYVeUeKmsxVAg7JiKruSpRV2WFNVN34UyqzQ8ohWhPmi6QqGLdGv0tgrxl15Z
         oeBA==
X-Gm-Message-State: AOAM533zu3MY0KQqsXP73Mbe8x60GQilB5xLJZ6G1VOSL4+yO/VUktse
        TWmhK4mZ+hJ2B9f02JXy+MFhDxaIiSIaeQ==
X-Google-Smtp-Source: ABdhPJyDW2w6SYMj+0teItCNxpHrC3psIwy6U6yZK9oyOvQKbH7oZ0vC5jHbNd2efw5ji4sQWk6R2w==
X-Received: by 2002:a17:90b:1c08:b0:1e2:fcfe:be30 with SMTP id oc8-20020a17090b1c0800b001e2fcfebe30mr27860104pjb.240.1654545540605;
        Mon, 06 Jun 2022 12:59:00 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:6780:cb0:6b1a:3905:4424:4d4c])
        by smtp.gmail.com with ESMTPSA id z28-20020aa79e5c000000b005184af1d72fsm11314205pfq.15.2022.06.06.12.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 12:59:00 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Subject: [PATCH] libtraceevent: Reset right arg when copying TEP_PRINT_OP
Date:   Mon,  6 Jun 2022 12:58:59 -0700
Message-Id: <20220606195859.771436-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When processing a TEP_PRINT_OP type arg, the original arg was copied
to the left arg and resets itself.  But it misses the reset the right
in some places and it could result in a use-after-free.

A fuzzer test found out that something like below can trigger it

  print fmt: "", c * ((3 * t)[

At the time it sees the "[" token, the arg would have like

  arg->type = TEP_PRINT_OP
  arg->op.op = "*"
  arg->op.left = (arg of 3)
  arg->op.right = (arg of t)

and it creates a new left and copies the contents.  Also it resets
itself with

  arg->op.op = "["
  arg->op.left = (new left)

But it can have the same arg->op.right if the process_array() fails
before setting it.  It should reset the right pointer as it passed the
ownership before.  The same thing can happend for process_cond().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 src/event-parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 8b839cb..8f4fb59 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2317,6 +2317,7 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		arg->type = TEP_PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
+		arg->op.right = NULL;
 		arg->op.prio = 0;
 
 		/* it will set arg->op.right */
@@ -2422,6 +2423,7 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		arg->type = TEP_PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
+		arg->op.right = NULL;
 
 		arg->op.prio = 0;
 
-- 
2.36.1.255.ge46751e96f-goog

