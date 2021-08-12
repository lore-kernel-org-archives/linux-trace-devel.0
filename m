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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8055FC43214
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56BFD6108C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhHLJAL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbhHLJAL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:11 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F020C061765
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k29so7193839wrd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 01:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeMg1CH8uTrgXIBuHu2Gci6pzh1HB3V82fxaxaegB7w=;
        b=LHQ+yR32SOrOl5yYKVxNe8KospLtZA7qbhdfkV0g2KrmgJlAhzm9L6hUy2/QiwcE43
         hPDcRE5KR+ykklfiQnAA5ADDWIB2M63NlyXuc7X/xHEMPxtTnmlCtxpRDgLJLttGLZ1G
         APfPKdyq5LtkKwiOzAvCzgQGpi7I3ZXpLj1fBKPFTux1AS13mdztpy1bR/Yhi9TRm0Gr
         9T4jlcm/dFKfGjk3um6GqmIKw3wFsZna1zmNWtvCBrAHRJxRcv9A4F8Otc69C8E/YXeq
         ak9cIOdwbbLgSGhUMTVJrVvpq0JPoLfIdjXMbQ7DjpBh74ueh5ClykJXoFq3i17anUcI
         pv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeMg1CH8uTrgXIBuHu2Gci6pzh1HB3V82fxaxaegB7w=;
        b=Aa12AiAtpRXzCfpGIh/kUHnIMPVSIyfVJEfCKoRAqN969aygKAXCjyHgtiNoCwwnWv
         LBnlh7LpSwhdsQK2b6i9v4wsEAlHDNrwhPPECyyQZQ0JQTmVgKwfrXRhn2o0kZBLvegH
         tmsEJG5B/HDAbMN9ygLJ0+KqPThFa5KW085hcFVfQFjTlwXLj542WjSG5oDr0/negikP
         OcjoFx03yoQK/BCoWXQg4LSKLbEo8ITnizAUVXcwjmKu+Xs0I1eOSdN+oPWHQirbC29m
         0qPAUzU+9YrxqBVeTOCvwhX1/MzCBH+OJ0SY74nb34xRoidaGdgVRbb+8aBbIkjcq6q1
         qk8Q==
X-Gm-Message-State: AOAM533Bc1R3Bg7cErTjUbZQigUMCBrp/zhhgjCP2cfoHOq7TAJ6Uide
        aR9+uY7aqN2blYo0zqhpUKQ=
X-Google-Smtp-Source: ABdhPJx23jUpn36HJZyxdFQrZomvTVRFVOdnh+k2bX4rkW5PFicvsCqOOT6ncOidJS1S8IgkJtEn+A==
X-Received: by 2002:a5d:59aa:: with SMTP id p10mr2833108wrr.0.1628758784874;
        Thu, 12 Aug 2021 01:59:44 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id m10sm936683wro.63.2021.08.12.01.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 01:59:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 2/5] libtraceevent: Have all field args point to the field they represent
Date:   Thu, 12 Aug 2021 11:59:26 +0300
Message-Id: <20210812085929.54832-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812085929.54832-1-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
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
index 62b56bb..02ec677 100644
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

