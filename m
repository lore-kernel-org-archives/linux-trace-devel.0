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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BA8C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA59560EFF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbhHJM1g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbhHJM1f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 08:27:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09E4C0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f13so29916344edq.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xVHdHGYjX9UVBzG4KqE24R9p9HjA9/m50lIgXZE/w7M=;
        b=KkxGZuU0slxyjs7O2O1Vqk7OrNep9X+1dx8fKOjokuTwIoHCcMLJKlVUthWmyNFdKw
         FXlPRi20S9n/xVw+svpRVUwbnAu8fofFSzN6s7+d/2gcvyZ7vGRG6R7fUoPWvSDWX/1o
         infOUPQgYFws75rb97cFqX0rI+czou28raL7fN8wTuOmjOtC2qDPaEWLdLaLXk21rNdW
         rsyLIGTKwMEX/Gg4XsBd2up6oE5t20Cr+h1JEjfZCdYWZnIy5hGbItRkVkmWw7dym7P0
         C0usWcMNJq0mFlf5Ajl+p3DJgdKtdRbkPazTtBZsUtB8SQ/mV0rMg9lkdM6iIRVX1MBB
         4tZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVHdHGYjX9UVBzG4KqE24R9p9HjA9/m50lIgXZE/w7M=;
        b=ti3pJgtM3D1fNhKHUsqdX6gk5HWkLfucabQF1lknkz1gmWEIZu3DHNkmXWH6wT3F5A
         JgsG3oRn3Y4rfvrWXyqnjZepySBMks3mCfJUNKlKR3211S0b3JCQGuGvLLBEdIid1ytV
         VN6GBHOZvCpBtx0AuHFLJYTNhZEqoCunCjkgtwbBWLNBe+VabM6AM49lffxBETaViH0+
         ErBoRmOsNyXsUrMUwWnzBwThuXJSh5Tz25mUzxVl3zYLrV3zdoYF8o4DKR39bq3OTf83
         gJFLMtgx30XRDZ3y5Jfob5RWceL6LC/DPshqVRNpoLaqslpXu0ytYpcoBBXW9MyWivnZ
         Y+2Q==
X-Gm-Message-State: AOAM5302dsck3c+aP/PBAx3ZnQ8CgDCIx1evk1GYJuO9JXtla0vgjQXn
        YxQ2iAQqUKApjtmC4iUmLoU=
X-Google-Smtp-Source: ABdhPJxuAS0iT+Js0icQXexgEYJBEXjXnLKtwlFr/IPfur5NxBxqaS/WJQk79UtZs0MyJ0Sn5azoVA==
X-Received: by 2002:aa7:d4da:: with SMTP id t26mr4619848edr.42.1628598432427;
        Tue, 10 Aug 2021 05:27:12 -0700 (PDT)
Received: from crow.. ([95.87.199.76])
        by smtp.gmail.com with ESMTPSA id ks20sm1074501ejb.101.2021.08.10.05.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:27:11 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 2/5] libtraceevent: Have all field args point to the field they represent
Date:   Tue, 10 Aug 2021 15:26:56 +0300
Message-Id: <20210810122659.145759-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810122659.145759-1-y.karadz@gmail.com>
References: <20210810122659.145759-1-y.karadz@gmail.com>
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

