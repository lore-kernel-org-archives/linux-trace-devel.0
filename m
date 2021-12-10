Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3BFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhLJK6q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbhLJK6q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:46 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A14C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:11 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id e3so29035504edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pf3TMtFR79SXc3JMOiDIkxB0gBfpyE9Aea8WqjpE2Fk=;
        b=DMe/i80BIT4rt8Wrx365WV45E1AmcIk9osTNo2WWF/Tu4FDcRldUstmZzHGR6Wa3oQ
         joBBa1IHUY+mXxAR0LTmqMz/kR4nbyvx107oFGEqBtKQoCW22DAmkUP475Kqs6lZMHQC
         PnLW58vkbW36k0j8ucr+BHF4jqjMuibL+Vwv9kF//rehmvweVwwdg7Xdak21xEQMDtdP
         HtwgJyO52PLv6xnA3sjz1vYfEAzz2FwVyCXUYqB6EOrW6PlswHVxp9AmXxZjxFaxkE3w
         /grkeLFybAtxKMHx3Q10jWlgxgoimqj9XXR+6ZPs2EZRD5FjaMtMMfWzK2vz0RDq6fOK
         gFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pf3TMtFR79SXc3JMOiDIkxB0gBfpyE9Aea8WqjpE2Fk=;
        b=6xoA1yKXPil8RO7ad+f2gauKQFLWYxa5setlOOPCWB18QVDdg0kS0nJFMLxQSX5jRX
         j6CvCowaYpQRSLbUlAX/OdOm3jBvKtqI9Y1yLb7qqhm1ovvLqGyLQi6WKagbcUh6gF1C
         oJqaOhLek5kYciidy+1fswwvUzFVV0vkNrOXt7iQF25KjFuspLOLkIWsl4bJpIJSRn88
         xO6wD1rSpxHVOVsuXIm2JGkx7L7iNg2OX56wgcg4hx+nRKwuIM0D+4GZBPxUUxaji6eZ
         +k6K+zzZNU1nCk6pImyU27u9Y5XPNHXBRwr3uLP+dpI5/Uj8El7pqTseugrDn3g+oUSE
         5X0A==
X-Gm-Message-State: AOAM5334x8VOouAiEjleVIUgiM6Pv4Y31pLWkguLTIxfrI5kBgzSmTAT
        87uGJ449ExIWxYiUwjxSwznr4Lm81+s=
X-Google-Smtp-Source: ABdhPJzNsGbyPGKy2fYNnmaqHS0BktUCKOt4JFwx5tRSf2WzoXyCL81+J4JRYVgqSk6sdqs7L0CMHw==
X-Received: by 2002:a17:906:9f20:: with SMTP id fy32mr23800159ejc.459.1639133710105;
        Fri, 10 Dec 2021 02:55:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Fri, 10 Dec 2021 12:54:45 +0200
Message-Id: <20211210105448.97850-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

CPU data initialization is different for trace files version 6 and 7.
When a new input handler to trace buffer is created, initialize the CPU
data according to the file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 55 +++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5c900e94..bc4e2885 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4522,34 +4522,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (!HAS_SECTIONS(handle)) {
+		/* Save where we currently are */
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-	/* Save where we currently are */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to buffer %s offset %ld\n",
-				  buffer->name, buffer->offset);
-		goto error;
-	}
-
-	/*
-	 * read_options_type() is called right after the CPU count so update
-	 * file state accordingly.
-	 */
-	new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
-	ret = read_options_type(new_handle);
-	if (!ret)
-		ret = read_cpu_data(new_handle);
-	if (ret < 0) {
-		tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
-		goto error;
-	}
+		ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
+		if (ret == (off64_t)-1) {
+			tracecmd_warning("could not seek to buffer %s offset %ld\n",
+					  buffer->name, buffer->offset);
+			goto error;
+		}
+		/*
+		 * read_options_type() is called right after the CPU count so update
+		 * file state accordingly.
+		 */
+		new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+		ret = read_options_type(new_handle);
+		if (!ret)
+			ret = read_cpu_data(new_handle);
 
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to back to offset %ld\n", offset);
-		goto error;
+		if (ret < 0) {
+			tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
+			goto error;
+		}
+		ret = lseek64(handle->fd, offset, SEEK_SET);
+		if (ret < 0) {
+			tracecmd_warning("could not seek to back to offset %ld\n", offset);
+			goto error;
+		}
+	} else {
+		if (init_buffer_cpu_data(new_handle, buffer) < 0)
+			goto error;
 	}
 
 	return new_handle;
-- 
2.33.1

