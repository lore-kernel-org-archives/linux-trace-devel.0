Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0924C33CAF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C61CB2465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sWUfPnCt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAVPAL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:11 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36131 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPAL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:11 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so7168041ljg.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oiz0tIFJTUyp9BFc+W4zhPg/52E3kMlWtCBQ4cLOvso=;
        b=sWUfPnCtqvAPsMjHA/Tdzgn6DCQ84kcu2ZEBYyCPeu/nfKDa0ETiaurf/qux0dNxY9
         pNH7DtXGLokk33ntRnFui73r82XdmC1fwuZ8abDb+VjtrFLzBZ5Me5OXegI30hnUu/xQ
         StD6BLXaSdXPzg/VYTv/HhjbCAp0cKNm3c9XMT5KwAFY1xvCoGCcvSPQDQTQmhvxla8j
         f1vIcGr/1mj02thOpw6rNzeYDGHb3wXA23UtUBxAh6qSBqScXmEAbTKDbrQ9n0swycmZ
         RHn19XroiWE3HQbfSmYFS9G60EGzQXzikEWod84xX+cGIGKC+SaDtzQzEnvFR07V2r/t
         C2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oiz0tIFJTUyp9BFc+W4zhPg/52E3kMlWtCBQ4cLOvso=;
        b=IIJJi3RFGIo3XNAplHpCB5/tHHiGd069SYu/B/+wfk4av0vgfvIXgB0Gd5RiJcgwHs
         dQHilxev/TTdk3UivmzrZjyQ7EyeagEEAVV/n/ft2XjkYppivjWVYyMlTI0xoxttBrwM
         ehjZDTty5lCEwAH2qme2R841QQQq65Q0jH7nxkaEmq76PK2+RCmWstQDk3Nj07YshTuf
         vrM/MRIiJXS/dJ88oA6ZWbyFrCnvhYa0q+2S41h8W4Cnv8CmGUem1KQ0wG5PiFgNI7K9
         75n63Yyc5EpNrNR4STTy8/zHKRHGfXV84+/ybUUTzRt1c4w21TI5kX4KpM2K6kOMvpe1
         yMtQ==
X-Gm-Message-State: APjAAAVwIUzW7iXlAv9vOn6aYPaHNQlHMyHrdinzMEXLcrEivODOi4ow
        xFhyeLN9XUjojXqRX/uHdIphZIoH
X-Google-Smtp-Source: APXvYqz1bF1AOMy+Ytlta/v9gvca9efDThfg7qJKKfP1MdAf/6mZMlfq9ebm29ziCVd64VVXvsJBnA==
X-Received: by 2002:a2e:3a0c:: with SMTP id h12mr19929510lja.200.1579705209408;
        Wed, 22 Jan 2020 07:00:09 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/7] trace-cmd,libtraceevent: Check for plugin options duplication
Date:   Wed, 22 Jan 2020 16:59:58 +0200
Message-Id: <20200122150002.763233-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When loading new plugin options, check is an option with the same
name and plugin is already registered. The API
 tep_plugin_add_options()
is modified to return errors is these cases:
  - The "plugin" field in the option's description is not set,
    return -EINVAL
  - An option with the same name and plugin is already registered
    return -EBUSY

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 50 +++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 8c48ccf..e53b09c 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -202,6 +202,26 @@ update_option(const char *file, struct tep_plugin_option *option)
 	return ret;
 }
 
+static struct tep_plugin_option *
+find_registered_option(const char *plugin, const char *option)
+{
+	struct registered_plugin_options *reg;
+	struct tep_plugin_option *op;
+
+	for (reg = registered_options; reg; reg = reg->next) {
+		for (op = reg->options; op->name; op++) {
+			if (plugin && strcmp(plugin, op->plugin) != 0)
+				continue;
+			if (strcmp(option, op->name) != 0)
+				continue;
+
+			return op;
+		}
+	}
+
+	return NULL;
+}
+
 /**
  * tep_plugin_add_options - Add a set of options by a plugin
  * @name: The name of the plugin adding the options
@@ -213,6 +233,16 @@ int tep_plugin_add_options(const char *name,
 			   struct tep_plugin_option *options)
 {
 	struct registered_plugin_options *reg;
+	struct tep_plugin_option *option;
+
+	option = options;
+	while (option && option->name) {
+		if (!option->plugin)
+			return -EINVAL;
+		if (find_registered_option(name, option->name))
+			return -EBUSY;
+		option++;
+	}
 
 	reg = malloc(sizeof(*reg));
 	if (!reg)
@@ -262,26 +292,6 @@ static void parse_option_name(char **option, char **plugin)
 	}
 }
 
-static struct tep_plugin_option *
-find_registered_option(const char *plugin, const char *option)
-{
-	struct registered_plugin_options *reg;
-	struct tep_plugin_option *op;
-
-	for (reg = registered_options; reg; reg = reg->next) {
-		for (op = reg->options; op->name; op++) {
-			if (plugin && strcmp(plugin, op->plugin) != 0)
-				continue;
-			if (strcmp(option, op->name) != 0)
-				continue;
-
-			return op;
-		}
-	}
-
-	return NULL;
-}
-
 static int process_option(const char *plugin, const char *option, const char *val)
 {
 	struct tep_plugin_option *op;
-- 
2.24.1

