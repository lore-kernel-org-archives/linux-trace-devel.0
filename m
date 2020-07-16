Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D953CC433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B638C206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="heEHLAD1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgGPJUV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgGPJUV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:21 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEBFC061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:20 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id br7so5817307ejb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SFz3sEn/yFAbwIBTv6Et2mRPYvPo+5gNotXAyS3/YMA=;
        b=heEHLAD1UHsbx0rmEYC3URIvqbsCiSPyBfnDMVUTP8jNN5ELt9Ce6DdA6sLsIpNahc
         nD7y4aZW9pss5EyNH0DYl4ytTraK7yqnyh4tzBz4XYSlwuy2Gkc7EOoFFsr4H7w+txTf
         161dp1C7mdES1m73oxOcRYe0wVg9fyv5W5NT8QNyaJcH39aGftlSNwFICFtcZ4SFpzGv
         iFVbWgltgeAgpOwXDpOuiPvRSiWI1wtw2qdG6a81rwPtY0TOqwbmN6lE/YH8g+lj8w/m
         dGVES5jG0BhUonOuPss2IpSrdZcQ5VDhrI05W1P6wND9egdKCoAiywOygpj33D9b/xTe
         NGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SFz3sEn/yFAbwIBTv6Et2mRPYvPo+5gNotXAyS3/YMA=;
        b=URatmhXIOC825abAAOJH89VQ+vcHtej9siBZ1kuPu4OwcHOVT16DuPBBmCI4w9zu63
         qfWbJAb2hMFUuSNab9Brn2VRwwTx7Z2+TfJ3kZsNUKRXO8R4Lg4ao+eL2rALCbIjAK9y
         7wRU9G+0TpyT/h1ycU8PoA2fzhqUMcwEl6TxB7sGLNPBeHqnodKcOWO29NdZUysJ/9El
         PYMl24jSsvjjT17SipL4Q7YtdLbMX4vbCoQxck9FI3tnzcBB22dSOkuRl/mQjsKsYpEe
         /xG/sEbPAv9ofukfFGZjcdFoUFuSytrYTZi6mfriwtnF4rAv0jtcBhhOpaQ2qXS5yFl7
         no9Q==
X-Gm-Message-State: AOAM532i5wRi9FlIFaRlb5QFRd9QJI52FE4frpvhbKXsDltGdaI6G2bQ
        tjwk2wb9YVPUqtkV17BEzrfLFllTT3I=
X-Google-Smtp-Source: ABdhPJxJgEt6CmmSUBOcKHFCuoZOzJT13mGgVb/O7JrY8TS5UzkOtn/Sex4SkD1N+fAPcU76GDL/vg==
X-Received: by 2002:a17:906:3a0d:: with SMTP id z13mr432857eje.109.1594891219428;
        Thu, 16 Jul 2020 02:20:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 2/8] tools lib traceevent: Handle strdup() error in parse_option_name()
Date:   Thu, 16 Jul 2020 12:20:08 +0300
Message-Id: <20200716092014.2613403-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Modified internal function parse_option_name() to return error and handle
that error in function callers in case strdup() fails.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-3-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index aa6f43290cd3..a39eeb6ef1f2 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -254,7 +254,7 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
 	}
 }
 
-static void parse_option_name(char **option, char **plugin)
+static int parse_option_name(char **option, char **plugin)
 {
 	char *p;
 
@@ -265,8 +265,9 @@ static void parse_option_name(char **option, char **plugin)
 		*p = '\0';
 		*option = strdup(p + 1);
 		if (!*option)
-			return;
+			return -1;
 	}
+	return 0;
 }
 
 static struct tep_plugin_option *
@@ -325,7 +326,8 @@ int tep_plugin_add_option(const char *name, const char *val)
 	if (!option_str)
 		return -ENOMEM;
 
-	parse_option_name(&option_str, &plugin);
+	if (parse_option_name(&option_str, &plugin) < 0)
+		return -ENOMEM;
 
 	/* If the option exists, update the val */
 	for (op = trace_plugin_options; op; op = op->next) {
-- 
2.26.2

