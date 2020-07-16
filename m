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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8A9C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C38F20656
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPFB2J+g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgGPJTa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgGPJTa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:30 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E130C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:30 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a8so4261822edy.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SFz3sEn/yFAbwIBTv6Et2mRPYvPo+5gNotXAyS3/YMA=;
        b=mPFB2J+gSSrFLW/guhw1VHsYjXYZZxNBgKQ06rbKP8+X4x5U7UlAliGHmV1o72OCNG
         /TDObNEkpE2XRKtNJkIa9JsOsHqohmkPSxK1c/iPZT1aIVMnggORY1llvVFlN2m2an7Y
         pr5h9Wgqbcbp1hx5bvo3+8F8VmjFtsmLN/ROaJknqyvhCGOTc+nNLSBtOojm1xNUubbQ
         M60u3YFhVpDURjb+gk9WJxWLSibYutTzuT4IAxdEsrhATzaHoyqpOx6mWbS6pGNGFLZk
         J7+DXABI1g2W2Wz/zgzuTXSmpfRGuvihsMoebNQnqQjF+WvOcE3hEJQh6KwalTkr7voU
         yNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SFz3sEn/yFAbwIBTv6Et2mRPYvPo+5gNotXAyS3/YMA=;
        b=IWIHpUs5yGIuhM/LZmruRbetFr0nsEHYaUTmg2/6lokQrtCPZet/ginw1GV9BxJ+ZZ
         pH78f97ttw+pmoVXiFigw1pr6795FsfckXC40BKwMspVSh/tmTNseJ2kZzLWDofCBJek
         t14kZMnNnxfnA6r7/eZ7sItv6JhrYZayQs6JgDzPhYc56EShNSg0OfS/D+OAjZPvP+Nm
         8cdCBRV4LUxk2x0ypHpfewK3M4i5hYSNmxEnK7XAgnT1syw1y4SZ0HB/hUNbhbVLRJbg
         pWh6Q76S1B/R4pqJNVpyF1hiia3YepWR8byVDjIhbkBHflZ3tYmv549QgAWgJZdvby96
         bUow==
X-Gm-Message-State: AOAM532B3UVCIZJYoHr36qgR80JlGQP5yFBtbHOzjasrnzh5QuUkYbls
        Yce+juCZ/IRVh2S7VSHjFG0Xb5/nGwc=
X-Google-Smtp-Source: ABdhPJyX+Qjch+vX3bGZvm8TJB26zx86zgM2krgUNw22Mk3oaxFhSCv6oM7sRecobQ17qNtJKHn7aw==
X-Received: by 2002:aa7:cdca:: with SMTP id h10mr3660864edw.285.1594891168846;
        Thu, 16 Jul 2020 02:19:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/8] tools lib traceevent: Handle strdup() error in parse_option_name()
Date:   Thu, 16 Jul 2020 12:19:17 +0300
Message-Id: <20200716091923.2613228-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
References: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
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

