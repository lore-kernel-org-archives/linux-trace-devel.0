Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995A9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC3F61284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKKPGB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbhKKPGB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:01 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7F7C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:11 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so25363470edd.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FjyGq3J6UVgmNzFWTIa2KGHfOJEWj12W0YtEc1ZQcrs=;
        b=itENR7gcLMggFKrIlzO+Peio7KKivljhFQCq/X+Z8beOH+PrrC64VTxqJLUs7cFla4
         Y3VxPaa9+1tcVDmAJzDongQOVhPHJ5E30SsvxtCeMoEcrtPTia3Ddm5Z9PBJafqM4UFw
         mnd/UtzGZa+VRbQ9L1norXXrmBWNyOrrnra6YANwBTBGZfSMq9ojvNgby0EwDDn5WdfI
         sJAp+4RPcMaj6MUMR7cjUi4rvjahGs3YdEFK8Nfn1XzgVj/R7NyeOhOZXge6/6yUAzLS
         HadasztDXlvwUqoN66FBvwO500+Jj81yqn3BkQUlfPy7Gn4R3OiBUvqSkmtf60u0jAil
         waZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FjyGq3J6UVgmNzFWTIa2KGHfOJEWj12W0YtEc1ZQcrs=;
        b=tfesmsvqGfrNI77aQhMCUUgoXlwEDvKKH32m2KYSaAL9dNFBzgGTuVP1OP+GEAVJ7g
         A0AfwPaw5KguvvDgAsbguEAB8T17JpJHxt28xYT0rE6mmA7ebOW6fkkD0e8eBA+/JU8T
         hTgznvUT7yf3SrMj8oVsIy8qcNizO7DNlbwBU8igd7n9WZlBbaDzyuY44JVqic1oixum
         fRo/TnFnCbgw4hPmH0vSWIfRaiswttFihhO2ZeSYDr0OZebktRHM+RkQ5EVWZHz5Dfff
         YT/W4JGDd/2qtM7K24SmvIFFPfm3jSWjYxPYfnTp29IXc3zOmRcoxrRtBlePFqJJL4ho
         NzEw==
X-Gm-Message-State: AOAM5312APaFtasMZJDLXj+pJZdinI7V7yonYq8yn88sp5AsOSWv7G5P
        03UqnAS2pVBhDg6+cbvF/2aHXrHlkjsrmw==
X-Google-Smtp-Source: ABdhPJwQIata68S07aWxnLusmIqP5U/pX+UTTJGbUIAGd98TcBfIOhpyng5/JRy3VIa6J1zS1JzWyw==
X-Received: by 2002:a17:907:6e10:: with SMTP id sd16mr10537735ejc.158.1636642990396;
        Thu, 11 Nov 2021 07:03:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm1737826edj.63.2021.11.11.07.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 2/6] trace-cmd library: Track maximum CPUs count in input handler
Date:   Thu, 11 Nov 2021 17:03:01 +0200
Message-Id: <20211111150305.85943-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150305.85943-1-tz.stoyanov@gmail.com>
References: <20211111150305.85943-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next trace file version,
where only CPUs with trace data could be stored in the file. Each trace
instance may have its own CPU count, depending on collected traces.
As the main input handler is used by the top trace instance, the
CPU count there is for the top trace instance and may differ with cpu
counts of the other instances. Added a new "max_cpu" member of the input
handler, that tracks the maximum CPU count of all instances, recorded in
the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e890f246..2b936ddc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -126,6 +126,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -827,6 +828,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2779,6 +2781,9 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			if (handle->cpus > handle->max_cpu)
+				handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4053,7 +4058,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.33.1

