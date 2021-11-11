Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1E7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0954161354
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhKKPGC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhKKPGC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:02 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4B2C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b15so25116718edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ElJcGpfmhsho78B9+WLz1UILTdptIZq/XBsK8PQj/3I=;
        b=G8ckgeN9S7SoSeWCUvKzZ6MJznBC56RXc+mqJSxpnia3Y7hQJLxLiO8kroARExWeJz
         9wDFS72AxZ93C8go1FYyRKNDCxw7jAx9gTA8MIVABBgPaj3et/3n1lTprWImSj3IvCq8
         BT8/d+jNF0FmUbZaTNImQplFYrlvbnWZNW4eHCzT2fZM4KDACdEhspabQt3U+PcLZKuZ
         Dzunc1kYfWOmyJsI1UkcHybIL47Y6y7vAQxtd1A+Nu4CckUjquKHquU/BlNUzwa9Fs0y
         9zT8GwrZjdx8IrsF3uK8BCvHIgE+WsuvlGwIlbt9XTjJxnkBvmAs3Nu1jURQRrrhoh5O
         zlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ElJcGpfmhsho78B9+WLz1UILTdptIZq/XBsK8PQj/3I=;
        b=YfKSkMbXzHL/eDjberVkS1/TYWhxA02EbKkYtXDZI/6RQ5BYz05uNagw2FKmxcBSMu
         LM7HkVyH7Es4a77LEI1mWfOFJ3PnjsyN/yhPtNT6s7Y2IQdZAlOjw9CDZuMY0OU+H3KS
         fkZ7z/BwK/sAXa5fvVrvM4uAKm8lS0b/0gDynZ9/DWXzLaOCvHmkw9cz3Oj6rqOgk28c
         J2qfRli02u6baQk9nO/E0gwnlaNWK2NCeY4V0JPqa/qClNDgDpkHs+5EKaxu/3ydVaXr
         lVZ3AXrUp8DF/PT9feoVOpSdbGTOWuwLttWO3SOBErLREd9F8wQQWZi8jg9V7IWXhRmj
         qkAQ==
X-Gm-Message-State: AOAM530ommAFBCO5qxHCyL6Z5wlyuqtnfD4RK3Snf0eWphml7REg437y
        sizw4jFZVBm/2joYs1rWTB4=
X-Google-Smtp-Source: ABdhPJzbC7pgKMVtcKb2SsdWt847dtjRLl+fUvWGNz1nZrZBpE++wreA4sWz+58vkG9OuS4BhEaxEA==
X-Received: by 2002:a05:6402:557:: with SMTP id i23mr10802189edx.176.1636642991372;
        Thu, 11 Nov 2021 07:03:11 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm1737826edj.63.2021.11.11.07.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 3/6] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Thu, 11 Nov 2021 17:03:02 +0200
Message-Id: <20211111150305.85943-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150305.85943-1-tz.stoyanov@gmail.com>
References: <20211111150305.85943-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_event_files() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 39 ++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2b936ddc..f9dd0784 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -645,7 +645,7 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
 {
 	unsigned long long size;
-	char *system;
+	char *system = NULL;
 	regex_t spreg;
 	regex_t epreg;
 	regex_t *sreg = NULL;
@@ -670,13 +670,16 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	if (read4(handle, &systems) < 0)
-		return -1;
+	ret = read4(handle, &systems);
+	if (ret < 0)
+		goto out;
 
 	for (i = 0; i < systems; i++) {
 		system = read_string(handle);
-		if (!system)
-			return -1;
+		if (!system) {
+			ret = -1;
+			goto out;
+		}
 
 		sys_printed = 0;
 		print_all = 0;
@@ -703,39 +706,35 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			}
 		}
 
-		if (read4(handle, &count) < 0)
-			goto failed;
+		ret = read4(handle, &count);
+		if (ret < 0)
+			goto out;
 
 		for (x=0; x < count; x++) {
-			if (read8(handle, &size) < 0)
-				goto failed;
+			ret = read8(handle, &size);
+			if (ret < 0)
+				goto out;
 
 			ret = read_event_file(handle, system, size,
 					      print_all, &sys_printed,
 					      reg);
 			if (ret < 0)
-				goto failed;
+				goto out;
 		}
 		free(system);
 	}
-
-	if (sreg) {
-		regfree(sreg);
-		regfree(ereg);
-	}
+	system = NULL;
 
 	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
-
-	return 0;
-
- failed:
+	ret = 0;
+ out:
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
 
 	free(system);
-	return -1;
+	return ret;
 }
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
-- 
2.33.1

