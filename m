Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC9BC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D0152075A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQWqQsrI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgFVHqD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgFVHqC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 03:46:02 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969BDC061794
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:02 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id rk21so627438ejb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uslf9wj7VYPFdtH631quImeKR/e3/zbIm1hklJFw4Sw=;
        b=qQWqQsrIx2QLXD/Xrdg0RtaroYvWzNLVVF3oz9uwTzBYEQABdKGbbMkd60cRKn4Ibx
         t+quWqWu6R2llAxbI+JRd00DsyW/f/Dot0eWj7pWpj4GUPk1Q1hcFhlm1TV5KNKUY2WS
         RRrTuTeBjWpa9OMd27f7YOPMglo5ca3J0LD5pibUUij6XbZ1qb2HaHUa/8xVFcpMcKDx
         z01taYAiq4GM5z4DLsXMYvu0249d3qPjx/oj9qoyptAWD3lB6TetSPBLZWy6womkbaCM
         /s2U2cLW9/TD/5m2wR8XAhjz8bdM0ZjTPpIEEwGL0MOMTEjzGaNIG0sOW4jVLQGN2Q5q
         FbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uslf9wj7VYPFdtH631quImeKR/e3/zbIm1hklJFw4Sw=;
        b=AxFfubgNRL1oBzTcaZMrYFYJKhqgEpYmde/wtR5NEG7n0TfLZavQZELH3Tecr/dmnm
         VUqkYbMRoxNIKpXdT21Ub/vNGb+zdx0GvigfdzxfE+jaroZeki1D5GkGFjMpPL2RDGFL
         nhXQ1f4a/BYkHalPKNUrZoKBqx4qqQzU+yXw0UYlR0Sr38zuh0hMgir5Gl0gckN0TLF7
         /GjyQA8+ACSvZQgb9MzwcAyhA+v7p28tMPk5sOBaTPf+xA0EZyWOV5kuVrlp3Lo+yfkN
         WsqKD6fu7qlGlTMxSktXSx2ojWXz7cgrdQOm8CVlfYXN4EDQNeKAH5qVuyBt4iF5hh0i
         ch8g==
X-Gm-Message-State: AOAM531FtjoJEDDUax9FAWFswlwL2VpFwzsiOekqznTIfCauTVg95Zbm
        Mv2Qn22JfGJewKpyHJtHwFw=
X-Google-Smtp-Source: ABdhPJxBh5asUdjxvlFDq9Llgl/0x3+fbOOWlHz9t8jdubd4LgL2LOj934qz9TIc2iIXWWkV5676vQ==
X-Received: by 2002:a17:906:f2c4:: with SMTP id gz4mr269180ejb.484.1592811961298;
        Mon, 22 Jun 2020 00:46:01 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.148])
        by smtp.gmail.com with ESMTPSA id k23sm11094048ejo.120.2020.06.22.00.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:46:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd: traceevent: Take care of return value of asprintf
Date:   Mon, 22 Jun 2020 10:45:53 +0300
Message-Id: <20200622074554.151747-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622074554.151747-1-tz.stoyanov@gmail.com>
References: <20200622074554.151747-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

According to the API, if memory allocation wasn't possible, or some
other error occurs, asprintf will return -1, and the contents of strp
below are undefined.

  int asprintf(char **strp, const char *fmt, ...);

This patch takes care of return value of asprintf to make it less error
prone and prevent the following build warning.

  ignoring return value of ‘asprintf’, declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: He Zhe <zhe.he@windriver.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: hewenliang4@huawei.com
Link: http://lore.kernel.org/lkml/1582163930-233692-1-git-send-email-zhe.he@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/parse-filter.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 20eed719..c271aeeb 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1958,7 +1958,8 @@ static char *op_to_str(struct tep_event_filter *filter, struct tep_filter_arg *a
 				default:
 					break;
 				}
-				asprintf(&str, val ? "TRUE" : "FALSE");
+				if (asprintf(&str, val ? "TRUE" : "FALSE") < 0)
+					str = NULL;
 				break;
 			}
 		}
@@ -1976,7 +1977,8 @@ static char *op_to_str(struct tep_event_filter *filter, struct tep_filter_arg *a
 			break;
 		}
 
-		asprintf(&str, "(%s) %s (%s)", left, op, right);
+		if (asprintf(&str, "(%s) %s (%s)", left, op, right) < 0)
+			str = NULL;
 		break;
 
 	case TEP_FILTER_OP_NOT:
@@ -1992,10 +1994,12 @@ static char *op_to_str(struct tep_event_filter *filter, struct tep_filter_arg *a
 			right_val = 0;
 		if (right_val >= 0) {
 			/* just return the opposite */
-			asprintf(&str, right_val ? "FALSE" : "TRUE");
+			if (asprintf(&str, right_val ? "FALSE" : "TRUE") < 0)
+				str = NULL;
 			break;
 		}
-		asprintf(&str, "%s(%s)", op, right);
+		if (asprintf(&str, "%s(%s)", op, right) < 0)
+			str = NULL;
 		break;
 
 	default:
@@ -2011,7 +2015,8 @@ static char *val_to_str(struct tep_event_filter *filter, struct tep_filter_arg *
 {
 	char *str = NULL;
 
-	asprintf(&str, "%lld", arg->value.val);
+	if (asprintf(&str, "%lld", arg->value.val) < 0)
+		str = NULL;
 
 	return str;
 }
@@ -2069,7 +2074,8 @@ static char *exp_to_str(struct tep_event_filter *filter, struct tep_filter_arg *
 		break;
 	}
 
-	asprintf(&str, "%s %s %s", lstr, op, rstr);
+	if (asprintf(&str, "%s %s %s", lstr, op, rstr) < 0)
+		str = NULL;
 out:
 	free(lstr);
 	free(rstr);
@@ -2113,7 +2119,8 @@ static char *num_to_str(struct tep_event_filter *filter, struct tep_filter_arg *
 		if (!op)
 			op = "<=";
 
-		asprintf(&str, "%s %s %s", lstr, op, rstr);
+		if (asprintf(&str, "%s %s %s", lstr, op, rstr) < 0)
+			str = NULL;
 		break;
 
 	default:
@@ -2148,8 +2155,9 @@ static char *str_to_str(struct tep_event_filter *filter, struct tep_filter_arg *
 		if (!op)
 			op = "!~";
 
-		asprintf(&str, "%s %s \"%s\"",
-			 arg->str.field->name, op, arg->str.val);
+		if (asprintf(&str, "%s %s \"%s\"",
+			 arg->str.field->name, op, arg->str.val) < 0)
+			str = NULL;
 		break;
 
 	default:
@@ -2165,7 +2173,8 @@ static char *arg_to_str(struct tep_event_filter *filter, struct tep_filter_arg *
 
 	switch (arg->type) {
 	case TEP_FILTER_ARG_BOOLEAN:
-		asprintf(&str, arg->boolean.value ? "TRUE" : "FALSE");
+		if (asprintf(&str, arg->boolean.value ? "TRUE" : "FALSE") < 0)
+			str = NULL;
 		return str;
 
 	case TEP_FILTER_ARG_OP:
-- 
2.26.2

