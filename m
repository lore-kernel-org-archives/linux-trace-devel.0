Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF391C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357984AbhLBM0V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346844AbhLBMZi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:38 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B84AC0613F3
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:15 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so115416501edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Emtpjjs9jn/xi1VIoLxN5FIRvZMh/MVnlSCLamHrc80=;
        b=iw9sZirB8bH9O0+RUE+T/Hvjm6gZ9e81WjmTEt8s1oFVosGyBSDMVt7bDPvmJwKDoJ
         jgS0OGyIEA9SXrNpQnaxh4kRYWCfk40dLrXpA3AlGi1NpkCPnlCCYE0mCmZhpJifbhY4
         w+c+PohD1fz+B8XZ3O/Z41h7cF7C2q2PKXml9CMpQPL/7N0wxZT2JgMJhenmRC64HRSq
         8s4C2PgxWXIhFTEUSNchhfoobfVMRkfJJkZ4MvpKPixofHgktRHC+qJXJNzv327VyCHp
         lW5zbRyNjnzkuUm//tm0E1HsOcskh7GM0J+da8vRM7huD2cBj67fDgTD5LR1gEPV7b7b
         yk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Emtpjjs9jn/xi1VIoLxN5FIRvZMh/MVnlSCLamHrc80=;
        b=FnbvPmO+HHJrZ4hdIZlEf792lXp8DsYb7JgjUnDJLEAZeBJz1R/35mlurwf2dAq6GO
         k8gY3kd1jnQlJAIsia5g69h64yZhbbO+NgEUyKX9snoGFoAR9zsZSCig7+OEq3kZbGdk
         NiK0mt+bdSyv6AHkYhYskAG9uFacpD5G1WsbKQAHEnHQgpNrf/7gFBR6SRr2FHLtGK4T
         chMXVuEgHjP4MHTZx9RDjpNidYRI22hqkmqnd43RAw0X70ftvelECbyInWBBrEIPR+Yd
         FRCiXQ8O/L+F9ivPV3bKQrRcK48DyF2bjpn6OVqrvjByBTDRVUIaul06SQ/Hj9dc/F7E
         M2Vg==
X-Gm-Message-State: AOAM532zkmPJDjHx5Z2wF+pu59Dpy1XiOHlmRxp41VZSEcl+mw396TNo
        25E1M93E2rayxSfiDrciWGZ1UE5m5WY40g==
X-Google-Smtp-Source: ABdhPJwPtIxS3KZmCxnAWQ9o7I2O9wSbs53lsPPDgusyULtcx2Ye+gSuGHfU6hycC/tulUW53vPj/g==
X-Received: by 2002:a17:907:d07:: with SMTP id gn7mr15276270ejc.272.1638447734178;
        Thu, 02 Dec 2021 04:22:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 20/23] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Thu,  2 Dec 2021 14:21:49 +0200
Message-Id: <20211202122152.43275-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 896f4214..5b8f5c93 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4466,34 +4466,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
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

