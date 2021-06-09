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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ECCC48BCD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 21:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68AC613EE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 21:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFIVru (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 17:47:50 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:49707 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhFIVrm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 17:47:42 -0400
Received: by mail-yb1-f202.google.com with SMTP id v184-20020a257ac10000b02904f84a5c5297so33138602ybc.16
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jun 2021 14:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zdP1AHWCCekvL0RtIO+w3lx0Ra2ABCeIMLKp230MTVk=;
        b=QvhVr8T+bbOHKzMMGw28AircfwcdR2ifidMEPlzs7rZaSZzj36iuVQxstmDf2iUFJy
         XmyFXNg5ZCH2Kd5OBKWivTxN287rd0oYTfwk601Iu0R48Wtc/eR70aVcKuL46L0cM3XX
         a6xvj2+cAa18DY44wmCmN0VKIWaCg4XTqv0c93dOd42gvAduaSqCoQXKjhWbS5j7VbTu
         CuGD5q9/ApooyNQQxDrnEfoi2+xt19bYFcF7GzprXhGa4pfezZ1m/o7/CS7ddLeUA5gB
         s6xWJxChCCGgbw3DSovQIzWrMq8o1G8qLJZ3jz3KFf8EqpAKeTQrDKthO4zhIzQhbi8V
         mssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zdP1AHWCCekvL0RtIO+w3lx0Ra2ABCeIMLKp230MTVk=;
        b=AYEfzHu42JC9QYvMR3OijjGCfMK+czKw9VQP3ayGWmPW1xWDaSlQTGjsaMERJH6QAI
         wfrBH1evkEHDqWb6fqvbbAnqbqu/NgfXm0pOin4dFkjaoTLpU/6Z91ISpxJhDgSvyrS2
         YsE6aPVMfnVSOnA2c9hZsOxDo6sKS2ighZDh8+TxDzxPblLqdWCeLzOvQXED5WbD2ET+
         naZ+GhdEbXUhGFQeBYNYhFbr8JDbMkF9QIEH0RLav5wgIoPYYQosgAViuQZhExe2qGsi
         R3DDcmpcuzN/ci168eCIpY5zlM2W4uzG5EREqowQuvboeLWThnhkOZDTbWexfEWcEt1L
         EOgg==
X-Gm-Message-State: AOAM530C5IvYVSPZTO9abrI1ZvJDaRV4s7kyKK6eMbz6YRk3kSQi73bb
        FmgqLCtE6T2uVUE9c8r65mQq4dFEhLhZrXYFqOev93oIg8EHcs0pd4zJ9d8eiocJuYnu2yOKCpc
        +hSt6otTp5s4yRGVb70tb1YG9audHdNkFRb+e5iCEX/0Uyc0JpqWV+2WvU+TVWCD5FYRR5lHb16
        RssO4=
X-Google-Smtp-Source: ABdhPJy53zVecTl8snWCggdgIu5HXo6oZd+d31FkySuYg/EHf1bnxNT6FKMtKIH9J8/hg3iDjp295brOSx82
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:7996:689a:4aa:98a7])
 (user=irogers job=sendgmr) by 2002:a25:da8a:: with SMTP id
 n132mr2921824ybf.504.1623275087084; Wed, 09 Jun 2021 14:44:47 -0700 (PDT)
Date:   Wed,  9 Jun 2021 14:44:42 -0700
Message-Id: <20210609214442.523914-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH] libtraceevent: Workaround address sanitizer warnings.
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

Reading a character 1 into an empty string (ie s = ""; ... = s[1]) triggers an
address sanitizer warning on reading of an unitilized value. Reorder the
code to avoid this.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 1217491..9915cb4 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2039,7 +2039,7 @@ out_free:
 
 static int get_op_prio(char *op)
 {
-	if (!op[1]) {
+	if (strlen(op) == 1) {
 		switch (op[0]) {
 		case '~':
 		case '!':
@@ -2117,10 +2117,6 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 	if (arg->type == TEP_PRINT_OP && !arg->op.left) {
 		/* handle single op */
-		if (token[1]) {
-			do_warning_event(event, "bad op token %s", token);
-			goto out_free;
-		}
 		switch (token[0]) {
 		case '~':
 		case '!':
@@ -2132,6 +2128,10 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 			goto out_free;
 
 		}
+		if (token[1]) {
+			do_warning_event(event, "bad op token %s", token);
+			goto out_free;
+		}
 
 		/* make an empty left */
 		left = alloc_arg();
-- 
2.32.0.272.g935e593368-goog

