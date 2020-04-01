Return-Path: <SRS0=9gE1=5R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C42DC2BA12
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C4A20714
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtQxXQao"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgDAQs6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:48:58 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43424 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389437AbgDAQpD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id g27so133821ljn.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Apr 2020 09:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P5zIt2o5bsqrwBStNHt6WbiT//vKo/fn+Rl7EAUsap4=;
        b=OtQxXQao3uYBJB8kCWgy7IXW6e3s78Ajq/vH3rP4ATe2sni58p+jiZviTg87TU5Mc7
         +k5GKsxp+xtyhFBLLifZjge+sPXURaLc8IlMxaz59Eji7ZlwNhxW/R/Eg3gelbeN8/rF
         g94Ujy/7x8EDbePEDUX6fchGKhBEJcfuj400xPOsR63UrhUqi+htmncBxar7OC7GVc6g
         2GcbiR/TfQdoqKFnsAp4nY9oN5P/+Vsz4977Rv5g0Rqz4Ty5pCrdUaFZroGiWYLgYpvE
         pTAVNTPM0Qo94BQmvnsLkxWAYYqjRgzy+9E528Sva+hW6ZZv6FbwPHFqRsq1v3vjEi9p
         x5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P5zIt2o5bsqrwBStNHt6WbiT//vKo/fn+Rl7EAUsap4=;
        b=jI9tzSkalvmavwhITZ2qeDSa5Fag8bv73iIoWPaBlqWsHaxLdnu8RULh+DlzaQs8pf
         00ujhFMbcstgE62L0LkO39Kr1mNXIDQ9XN+3zqZR65VMec+UYomW6HMlOXRJwk37k2C8
         M3lgcHNKsBgft9I4+HC+v7i+YmNzJ5blrNJEVmkRLcEne3QZiIkC8FIttRqrmE4D6wJc
         5WZ7B2SCWjJnn+yQOmbQ76rjclbiihWTLo8qg9bOEPv14kciNfsay6wJtafi0KpKqMB6
         O5eWoXoSAnXEILJBq5uiUOIY5260hdszfmhLCKw8L36EaTPnT2bN6Br2fTNpRcl7p/r+
         tQ0g==
X-Gm-Message-State: AGi0Pua38D5ut7+cups374Vxknrlas+wactjptskKUFeLEBl888RZ7qv
        Wu14iNNZ3BO/1uD5tIgMp2oPxMPPZzE=
X-Google-Smtp-Source: APiQypJuQn16QLx0wIq4zoBPYymrZ0G51AWcrh6Kwum4m7jlsvdc9abQJrSzZoyCL1cCOVkewpFaTw==
X-Received: by 2002:a2e:3203:: with SMTP id y3mr10929704ljy.54.1585759501024;
        Wed, 01 Apr 2020 09:45:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e4sm1982499lfn.80.2020.04.01.09.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:45:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/5] trace-cmd: Add a define to enable per CPU timestamps synchronization
Date:   Wed,  1 Apr 2020 19:44:50 +0300
Message-Id: <20200401164451.191425-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401164451.191425-1-tz.stoyanov@gmail.com>
References: <20200401164451.191425-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new define TSYNC_PER_CPU, enabled by default, can be used to enable
the per CPU timestamps synchronization. It is mostly for development purposes,
to compare this new logic to the legacy one, where a single CPU is used.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-tsync.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index d44c3850..8de846e1 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -31,6 +31,7 @@ static void *tsync_host_thread(void *data)
 	pthread_exit(0);
 }
 
+#define TSYNC_PER_CPU
 int tracecmd_host_tsync(struct buffer_instance *instance,
 			 unsigned int tsync_port)
 {
@@ -54,9 +55,11 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 		goto out;
 	}
 
+#ifdef TSYNC_PER_CPU
 	ret = trace_get_guest_cpu_mapping(instance->cid,
 					  &instance->tsync.cpu_max,
 					  &instance->tsync.cpu_pid);
+#endif
 
 	instance->tsync.msg_handle = msg_handle;
 	if (top_instance.clock)
-- 
2.25.1

