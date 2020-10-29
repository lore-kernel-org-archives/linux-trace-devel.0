Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C743C55179
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B480207DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esR1CqHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgJ2LSb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgJ2LS3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:29 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127EDC0613D5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:29 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id a72so1967535wme.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cR/a4ScQUiqT2jubpL1+87OUiI0JF+2banXKeyunO+Y=;
        b=esR1CqHCbDMl2C+7d6ul3aK2pz2NapXbN+vLJrN7J281pIowFR5+Wm1eY+kkvKYV5E
         uevevMpDYvKXoQF9Odlzk3HRuiyvY+LOGR89QiA/ydXkGR7W33Kk0z1YcS3tF8n5vwI7
         YCNWBo7thxYXyhCqiGbb/Yej/vKEKT+jucu8h6V2MAK1s83a1fiTrEKepUfT84dtD/WT
         indqIuF3Kyk1ySsZTIrDGPMpjt3FM4BqFe8PZpPyiw+OunLAnJtEDymD3JVpLAm6VZZ6
         EFjMhJl2dEOReAqOWZjOqS0KD9yf5O6hloimKINo+AYSY0wEP9NeNd2AkE6PaRBWds9D
         0svA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cR/a4ScQUiqT2jubpL1+87OUiI0JF+2banXKeyunO+Y=;
        b=uWjOi2HoURhYzCLYf9WTILzjsRvOB6YRu3LPsvFOGm/l5rDYoc5/VRhiJjExgOG6I1
         q8gd45Y/8ENqxKepq2NHDv3zDi4KegheKcnbPSo256k5n0pxclVdHOPKNu8eAlUzpROJ
         YEfzaJuv1Fjy32cFBIUGiQPpBfpAseXWeCqqKxJUXzhhvfZkrMqXDso9op3wYDCkC/Ij
         2UUiMh2i/RxAgZ40+34VpL8ocOUg0x0/Rj5peUlk513Tefe3EGoRcE1UU0+MKZQSAjVD
         p9Hrob+dHoLLQlKxT1/qPrOkEZ7/zzoHmy0lUbbYkqFI73ue0BzmX66EY5YoBC1+IfGg
         Hl4A==
X-Gm-Message-State: AOAM533QMnnEpWRIKK8uEfjdO7p7ZSNDgUHyr6v4M9/ihA8W9/n/uInV
        vE/1mvbY3kQb3Oq+WtTsGww=
X-Google-Smtp-Source: ABdhPJyM0NoNR42AhGxixK8SZkblRMzRI2VbOtdMXMMwE2D+dJfjCdzRpfmhWv1aGXT50Kxw1XM/Lw==
X-Received: by 2002:a7b:c18d:: with SMTP id y13mr3797353wmi.120.1603970307873;
        Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 08/16] trace-cmd: Add guest CPU count PID in tracecmd_time_sync struct
Date:   Thu, 29 Oct 2020 13:18:08 +0200
Message-Id: <20201029111816.247241-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_time_sync struct holds the timestamp synchronization
context, used by the timestamp synchronization plugins. Guest CPU count and
PID of the host task, running the guest, is important information which
may be needed by the plugins.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h | 4 ++++
 tracecmd/trace-tsync.c        | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 1ca2da10..9629d074 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -450,6 +450,10 @@ struct tracecmd_time_sync {
 	char				*clock_str;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
+
+	int				guest_pid;
+	int				vcpu_count;
+
 };
 
 void tracecmd_tsync_init(void);
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index aede3754..bc5c744e 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -77,6 +77,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	cpu_set_t *pin_mask = NULL;
+	struct trace_guest *guest;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
 	int ret;
@@ -84,7 +85,11 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 
 	if (!instance->tsync.proto_name)
 		return -1;
-
+	guest = get_guest_by_cid(instance->cid);
+	if (guest == NULL)
+		return -1;
+	instance->tsync.guest_pid = guest->pid;
+	instance->tsync.vcpu_count = guest->cpu_max;
 	fd = trace_open_vsock(instance->cid, tsync_port);
 	if (fd < 0) {
 		ret = -1;
-- 
2.26.2

