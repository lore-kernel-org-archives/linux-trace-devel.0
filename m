Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FADCC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385B461019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbhG1Ndx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbhG1Ndw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:52 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E283C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oz16so4629203ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=47Pzs+ATiqoPuLETfhXTruxPGN0Os8mWtLd6tVkPeVY=;
        b=fsV7jDe0EL9W1AOdoJBK89krqGQq1GE7yWnlbUPOdzMQ62B9YsJ1lXJw/8bz6+yp5u
         cAPskntYw9wFwog7MfIoNspV5uq8Lq4PC/3Nt44h4cdIhGEkAScOGsncdzDPBqReoTgA
         zlLgrK9+k33EyMRyA9kHsr7vXOt9Bsqjlt6zuM3uhH060qJiqBSuWsIFE/AN+GY5chrY
         lK/tLEPHv8PjcH1pE1aLrhRFOJXe8bukMr1zNIyLjdYzSqM36TQu+jCsD0LNJjekELEa
         1U1AhmSpF+9uQZPv5AYpFZePRBy9O+bz53UZEkII0kyN5t5JtFr/BuKAERKpi5fEUQod
         ls0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=47Pzs+ATiqoPuLETfhXTruxPGN0Os8mWtLd6tVkPeVY=;
        b=Ul3MNBvWK7UqHcAesDCnbS3ZIgaFiH0D1AsCB4cMtgA8eSZcLT7XgMB5+61O5hiP9o
         h/4hEtO39jJF5yHIGcK2h/TznBn76rBLrCn677OfMF93zgDolxm4bvAT5OBMX7sL/f0y
         AqtwHhSrXmSUYmp6yPCmGk23w1JjqhBBYX9OdIKCL71cs5BZcYbQnCQwnmtT2ZIpImps
         MYXz7Hi5gnmar4o+8GA7WBkArq1De/Vp/YXOxAcvIQbD7KOS1NQo0VYGqGmHdKxbHebs
         INQZxdhmIQIcCHAf4CL82Aq1rrxI2IHCnfTzgNaEf+Xc+r2UXhWSMok6JKky3z3qgu0n
         Y7pg==
X-Gm-Message-State: AOAM532d3dKD2jrbsREKirHWP4iR3ZfYxgdps0qcvBMEcLtU7PKcgovo
        /xjNYTHNJ0uZFKUy/l3tXY8=
X-Google-Smtp-Source: ABdhPJxlyEvs5aoxE0xLZD+Yhe7Ujf4AykHkk2TSXm2mTH17RYH1eJXSSdpIUyIq0FeLe4nLvQF++w==
X-Received: by 2002:a17:907:1b29:: with SMTP id mp41mr27370677ejc.459.1627479228980;
        Wed, 28 Jul 2021 06:33:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 56/87] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Wed, 28 Jul 2021 16:32:19 +0300
Message-Id: <20210728133250.234140-57-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index c0e8187c..95be9e6a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4810,34 +4810,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (handle->file_version < 7) {
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
2.31.1

