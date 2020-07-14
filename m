Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80970C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56ACD20BED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8LAX6x3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgGNKaf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgGNKae (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:34 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BB1C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:34 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w6so20947105ejq.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQVzp6ogLcKmVGQ9tTwvk42nFHeOUxX0/DQRElNehRc=;
        b=P8LAX6x3MzP+nfS8nhL4LZyUzHy8n9QfpqgDZFFEAxJlhmQl2FgJQL/C7/mEJ2YGJz
         86zkXoHMO5ukkV5gkzgXYWgeu9559J8/rcFe4xxjnwQQCmZCbwyAM6yV3wd1NFr1gpph
         jYI+fkJAxaSfWnIpsdQma+Y81ChNhegaWUoLR7K/Jt3Y8YaEP8Pz0uGxEudlJdKmlo1G
         ciYKCRaUQTiXwGLp6NJI+PVDNqFhRWSJTr4VniSUBCZQUZ1SnCRjvjXAZppFFSIIyl8N
         5rsBUL265BGA0BFghJhmlrCN9E8lZPJF+CHqA5qP2yjkyrzIoRxYOTp44TtOcjMLjZVw
         51+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQVzp6ogLcKmVGQ9tTwvk42nFHeOUxX0/DQRElNehRc=;
        b=HAU7W17cU3KO9lVcB+RoQXlFByBtOL6ddNB7qgjQG10bIWlbLoKXYMZ1bmib6/aR+n
         1a/x9DhSACvO1X7lOs+fNobWiJTjm3ZpdfXARyb3qXQyGBE6h1x4a7IqzV86SM31qRSn
         ebDtRCACyRB+UI7A0c5UQCXIUn1DAPEXeF0SIrqDB+3oCCqogmNJOGgZFd202ZeNWXva
         Bx5GbH8ZHQIxiVQdMBiaRR+J/Vnl+H/bhFQEPBL56iix5wNzdE3nM0MF4l+6uRALf/dF
         zYgI8BkjELvc31HkAC7RkQpBFA+IxLWMVzOiv0L8UKYqgnJ1NORdcN5WJALHZmMd7vvR
         SETw==
X-Gm-Message-State: AOAM532PsN1H4oc/gdi/UsE93bsM4PjRjHs4zMDeWN+J2v/pa+x/LYEI
        o8cTfGr5ssD/qn/gDhx90Ugmv3DtQhU=
X-Google-Smtp-Source: ABdhPJyLV/hPyLbJFpzF5oBeJI7o2JkEAORZz0XciEemcr+1D/qQ4Rtz8qElWE6095sRX3viR8Bocw==
X-Received: by 2002:a17:906:3146:: with SMTP id e6mr3828324eje.2.1594722633092;
        Tue, 14 Jul 2020 03:30:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 2/8] trace-cmd: Handle strdup() error in parse_option_name()
Date:   Tue, 14 Jul 2020 13:30:21 +0300
Message-Id: <20200714103027.2477584-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Modified internal function parse_option_name() to return error and handle
that error in function callers in case strdup() fails.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index c11636ce..b97d0c7e 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
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

