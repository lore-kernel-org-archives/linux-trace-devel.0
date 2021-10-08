Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4887C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979B761073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhJHEN1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhJHEN0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4565FC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v18so31485479edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JB0N+IkxI3DjSH8Wryu9y893rxRfI/Ah/FsE+7MF/JQ=;
        b=AoWkIM0Z7/NE1dmYyC6+dqeatulUHWk0Ej4fwvWKlC9jXPbabZfVyE0iMyla6q33jV
         SQZTXTMFOm6SsvrmiE/GwqIN2kzThUZ6PG3TiRo4vOjoVk+t0lE/Mj0txVImaMGIMUXO
         oxw0CNBSkUY74C/sejgw7oL6Yfg5e6T/VaWhsFCKgXeRfxRDNDHD8RRx7SgQF3H9WR17
         mqSJPu4DNt/iMlKY6d3w6546WMe2qLPVdVDDr+IDYHQxOwMoFJQ8SiUytZfQJWA1zB0F
         dQfsvtwJBqyTpQX+QchNdKkvfAa2dTlcGE8ms/uZCrS5UFQbz7dV5scA33saX02fQp+D
         lNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JB0N+IkxI3DjSH8Wryu9y893rxRfI/Ah/FsE+7MF/JQ=;
        b=X9VoGVznojp+m8log6USTywjEHtGXujzEN0GbvcF6SiSggEmlsMTKn6ajqiOiOShtq
         bgy/x6m6BorBedbplNx5MDb2JQOadI3AjsFBf9SIDRPgDpN0n80A3Nzd1U7EK+hHHIvJ
         7Mx4KUmgKukeRgkUazaPWNJntEm+q2kP4SEh09D72naj4IPi33pFFwtw29V7Jvn10vmE
         xMFUCqnwcmFrJORDoBbV3j+2KCT+CPWXmJoQHROuXuqGYaJwHUkB0MY6rtMseLIT9huE
         jeEioarjXDmTFzXoG+bVZ+6EEpjubjVx82qzIdsk1DZsBcMxzKFWf20EchaS5P996Loo
         sMfg==
X-Gm-Message-State: AOAM532zkjq5+Qu6NcG9zfTsSlnHOoD36MBzO+2s0CUguHIIMbdQLDOH
        8396jyOg0UIVbzwoZSNEomZrdeak+oGsBw==
X-Google-Smtp-Source: ABdhPJzHKg1021nhcDk2oTwfsM4qA+vWXH1/ki5v02LoLlpevtS0YIReAmjkzzNh55FWD5QddSbLiw==
X-Received: by 2002:a17:906:3685:: with SMTP id a5mr1293332ejc.144.1633666289931;
        Thu, 07 Oct 2021 21:11:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/6] trace-cmd library: Track maximum CPUs count in input handler
Date:   Fri,  8 Oct 2021 07:11:20 +0300
Message-Id: <20211008041124.972956-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041124.972956-1-tz.stoyanov@gmail.com>
References: <20211008041124.972956-1-tz.stoyanov@gmail.com>
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
index b4af783b..aaafe3a4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -125,6 +125,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -826,6 +827,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2780,6 +2782,9 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			if (handle->cpus > handle->max_cpu)
+				handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4054,7 +4059,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.31.1

