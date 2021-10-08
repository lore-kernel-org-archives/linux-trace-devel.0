Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4307AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF526023E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhJHENa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJHEN2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FBAC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:33 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p13so31714333edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v+CAzJJfh4/oXFeHTwKdVd7sPZBrXixlS+1sARKxW5s=;
        b=UDl7sTTrXtBP6GbXWzgAv5MPp/h9TF9F+j6RGdj/TT87h2l6t6IHWPErFer2mxAD9m
         9kAXZbnrl2J+n/Uvbev3V3K7NMKgU5f9GVcanRlG8PXG6PEVBWTiup99/QJVOfihYI/S
         c2IAUMXwu4up8lYe3dkXeiwqAP3+tQpag/DJmE16c6RJW2QPPwTZz6yutiRbmlmIad4R
         SlWPbotFQ6gnEjQP0zVN11gIiwXPJfZJ5LvCEj7C5+b0PQfXe8t835/x4dIZXm+WDAvq
         +nfQroFPqRdu8A28m+ojNygVq7cD4lb9qjlECP/VJRGW6y+AEz7KcOUEaJfgWkqv5zLC
         BTFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+CAzJJfh4/oXFeHTwKdVd7sPZBrXixlS+1sARKxW5s=;
        b=spbXWNbZpaThfGwtfAYT2RNLzkX6xs6Pj6Hx4hgetmEqZ1T4cHAFTNChv7Qc9MhQ8w
         g80qgDhpiIzACwl0jgqXGcl6rxjeL8H7Zmietke0Dimw9nLQ+6DjX1EzUVU72SvjNCto
         BgMF8ZZclyaS6TJVIMXd6wr8QxTe+RRvOZd+v+PVye6ZS5SrSA26Lfp+9QrG0FmoOB6v
         A31624oa37VrOiQvVBDsa34zaFfe3P3sjy1vKeTbbm6lxs+nMRMU9qHKGt5cRfLAwODh
         fMDDRa/p0pMv5kOs5PFAqi7yg9Eea1bdzyJYQBR1Vse/jUm+izz3Byfw5rKMn3ee5e8t
         p0wQ==
X-Gm-Message-State: AOAM5315/YLY1kDs25gn1inbgEi4V0u/NkgQ0WnxTAD/UFA63X2jgnxi
        cqiMf0UqNTuQeZ5bSFPpiDVkTejtss4wSA==
X-Google-Smtp-Source: ABdhPJwbQKmXW7r0GL9ZqncztLWa5up8hNxg4YIQBpxhEryIcpA9hSRgOyQNuc68yrJXm18R29Tqsg==
X-Received: by 2002:a17:907:a061:: with SMTP id ia1mr1188977ejc.372.1633666292335;
        Thu, 07 Oct 2021 21:11:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/6] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Fri,  8 Oct 2021 07:11:22 +0300
Message-Id: <20211008041124.972956-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041124.972956-1-tz.stoyanov@gmail.com>
References: <20211008041124.972956-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_ftrace_files() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0a42ca4e..43491c5b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -617,28 +617,30 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 		}
 	}
 
-	if (read4(handle, &count) < 0)
-		return -1;
+	ret = read4(handle, &count);
+	if (ret < 0)
+		goto out;
 
 	for (i = 0; i < count; i++) {
-		if (read8(handle, &size) < 0)
-			return -1;
+		ret = read8(handle, &size);
+		if (ret < 0)
+			goto out;
 		ret = read_ftrace_file(handle, size, print_all, ereg);
 		if (ret < 0)
-			return -1;
+			goto out;
 	}
 
 	handle->event_files_start =
 		lseek64(handle->fd, 0, SEEK_CUR);
-
+	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+	ret = 0;
+out:
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
 
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-
-	return 0;
+	return ret;
 }
 
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
-- 
2.31.1

