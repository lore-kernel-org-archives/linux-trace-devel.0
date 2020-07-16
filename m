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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CB4C433EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C8A206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pJiC0xIR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgGPJU1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgGPJU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:27 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B13DC061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:27 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so5787088ejb.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Afnm1XJPghycfFBTXXC1c4C7hw4aUgP2Ne/OsI1KDuU=;
        b=pJiC0xIR3E/Yhq8I4gA03BzoIcP5QjV3BtEIxK6jDsrhz3nUcVfSClYrJp+VQplB7B
         140FGiX5Q8CaHLLn6E33/hEifoWZEzXCleaD26qAE6bIG6BdtYYILv0maPX4r3EYam3g
         9SniQGT4n83BGAmYytQAH+mP5ufOGLUWEi5aNT4VkmMaQqIeEuWI81W7rYKkSbdsaJ2h
         dIPMNVtzaXY6OsxgiwDhLw1s28AQDd9km1ujTI/qxLi74p/oH28KMXCFWGmGgHwqJkui
         QtHT/DdTqxmf01hCtGXO8wscJzATFVqlv89/MzlDW5q5Zm4Bb1zb/q/s8Ku3nPcZTlME
         DWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Afnm1XJPghycfFBTXXC1c4C7hw4aUgP2Ne/OsI1KDuU=;
        b=Odzd1rnaJMA3ucXwp9XvHowuwIlNheJaedVgvGlExpTm9cywhkoJ/GHcY/hagrc4Gl
         /BJc247ZmS8NMtp/+m6xQij29Fp9TQNjN/7+i9cc8/7YL1e+fFV+0tw5w3HHkJIwG2Me
         51eTu1mbeVb7xzoUHmaWEzqZ3thu6Uqe1CyaYpTF+M/OyGwPAr7egxMH0osoZbJRjb1G
         k/XSWrKWi6OdOrIynyb1GmrojEiLiEK2lnd5dZEyG7bvPGpMVJR8kqJYzhvfKOR5Wkgn
         zeM8VN2ES8oqrcqCw8XTMXhTtUFVEFP2ACInwsP3DUhIOSr63y4ktLU0wX90tWRnVNxR
         HBTA==
X-Gm-Message-State: AOAM530XOGgTF5SGWwJcej5YT8aB/X8FhZZ5jqjAad+2vGPXlzq1dTg6
        lK3QZ+LjWKUc3Vdrf9hSxWxea07Vi88=
X-Google-Smtp-Source: ABdhPJwqfRYMz2evtdc5dTOqQRIHbgbYXYn8Rex4lsywmrxtN5ohKnt23PUXdgkIsdoxq1T5Gbv8kA==
X-Received: by 2002:a17:906:1499:: with SMTP id x25mr2774266ejc.406.1594891225932;
        Thu, 16 Jul 2020 02:20:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 7/8] tools lib traceevent: Fixed description of tep_add_plugin_path() API
Date:   Thu, 16 Jul 2020 12:20:13 +0300
Message-Id: <20200716092014.2613403-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the description of tep_add_plugin_path() API to reflect the
logic of the function. The suffix of plugin files is not hardcoded
to ".so", it depends on the custom plugin loader callback.

Link: https://lore.kernel.org/CAM9d7cgMgqFDvKhs6xwdBSMsaG=3ZG0RtxwgQDCTLGkML1MY4Q@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-8-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 6b84b9c4e6ba..f0877a7e3e8d 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -646,8 +646,8 @@ tep_load_plugins(struct tep_handle *tep)
 /**
  * tep_add_plugin_path - Add a new plugin directory.
  * @tep: Trace event handler.
- * @path: Path to a directory. All files with extension .so in that
- *	  directory will be loaded as plugins.
+ * @path: Path to a directory. All plugin files in that
+ *	  directory will be loaded.
  *@prio: Load priority of the plugins in that directory.
  *
  * Returns -1 in case of an error, 0 otherwise.
-- 
2.26.2

