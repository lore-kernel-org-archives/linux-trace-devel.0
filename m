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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AAEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C530619F2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhCXNFF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbhCXNEg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8381C0613DE
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o16so24392203wrn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qshlzDiqvkw9WgYjrZrIZ2GCvYgKoctVCVPSsN0HRY0=;
        b=fOFdCivTqUQJliJXKRxUQYTF8paOEQTIeJFafyqp/SQu4KXvznwLTblZV0edaJH92l
         Bp+6AxXwxGfuyj5uwtTFd3qBQwwJxU8wwZPJ/Hnb6wixIDG2TO5pVA/cKMlbqW1/mqM2
         o0JeqHp8BIyC/akwQgxQ1P0dHjdfLXB02qzjYV5pCPWZt/MWf3qwAkQAusovFUbydIEd
         VPFrzOJQgB0/wUKtHAvVPC8TJob7WR1S+TZA/lO6WnaivFphQOiDGSoHWfNSot9UmVA5
         v5ovSJLIwcoJiml0QHNSWkaX1RvJQMtPEr9CgLX4NEC9kZOvy0IpFHxnsXIIdSWbgGOV
         n2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qshlzDiqvkw9WgYjrZrIZ2GCvYgKoctVCVPSsN0HRY0=;
        b=EPt/RPu3G/Son3ni8j8hRrjcESbRYalFinvu4Mraw+V418WFsJMmbO6gqI+Pi+Mt+l
         viDOPbIBM1ppmNk7XOeCxCXczXXReowiZv8GljiFEstUWsRF5e4T81a7gYfwlxD9vwg+
         1Mypw1L/dr0wJbiryIIAx0lXTlwzbANLgj0K48qXNy0bRgPASR8gyUU9CT6ixh2NfTbK
         /1vRSCRAzpFbpHJrtu239UDPpm4D/0lb4UtU1m7kewbGCNvhAoh7jCUEfly98psfxOU0
         yjEwsJQPXc5OPvpkLW9IvJ8OYlOuUrh8j2eRQBQrNXomS3fZjsgz8rQzidyqz+K698mD
         WReQ==
X-Gm-Message-State: AOAM532WBso1kLu0jG8JGFLywnynCSCg/8WbGjNm2AlQRHibdWAuopJ+
        dqbFfBaOxCUq6XQCiXTfnvQ=
X-Google-Smtp-Source: ABdhPJzzyrFjHg6f3tA2cPUsha9KDyDkb9cMNFtAtsCBr+TYL10FRPW52aAfHPV7qknUMhH3qrZOfA==
X-Received: by 2002:a5d:6587:: with SMTP id q7mr3389667wru.282.1616591074449;
        Wed, 24 Mar 2021 06:04:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 08/23] trace-cmd: Save information for tsc to nanoseconds conversion in trace file
Date:   Wed, 24 Mar 2021 15:04:03 +0200
Message-Id: <20210324130418.436206-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Store multiplier and shift, required for TSC clock to nanosecond
conversion in the metadata of the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2a594736..9b652c64 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -668,7 +668,24 @@ static void delete_thread_data(void)
 	}
 }
 
-static void host_tsync_complete(struct buffer_instance *instance)
+static void
+add_tsc2nsec(struct tracecmd_output *handle, struct tsc_nsec *tsc2nsec)
+{
+	/* multiplier, shift, offset */
+	struct iovec vector[3];
+
+	vector[0].iov_len = 4;
+	vector[0].iov_base = &tsc2nsec->mult;
+	vector[1].iov_len = 4;
+	vector[1].iov_base = &tsc2nsec->shift;
+	vector[2].iov_len = 8;
+	vector[2].iov_base = &tsc2nsec->offset;
+
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TSC2NSEC, vector, 3);
+}
+
+static void host_tsync_complete(struct common_record_context *ctx,
+				struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle = NULL;
 	int fd = -1;
@@ -682,6 +699,10 @@ static void host_tsync_complete(struct buffer_instance *instance)
 		handle = tracecmd_get_output_handle_fd(fd);
 		if (!handle)
 			die("cannot create output handle");
+
+		if (ctx->tsc2nsec.mult)
+			add_tsc2nsec(handle, &ctx->tsc2nsec);
+
 		tracecmd_write_guest_time_shift(handle, instance->tsync);
 		tracecmd_output_close(handle);
 	}
@@ -690,7 +711,7 @@ static void host_tsync_complete(struct buffer_instance *instance)
 	instance->tsync = NULL;
 }
 
-static void tell_guests_to_stop(void)
+static void tell_guests_to_stop(struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
 
@@ -702,7 +723,7 @@ static void tell_guests_to_stop(void)
 
 	for_all_instances(instance) {
 		if (is_guest(instance))
-			host_tsync_complete(instance);
+			host_tsync_complete(ctx, instance);
 	}
 
 	/* Wait for guests to acknowledge */
@@ -4269,6 +4290,9 @@ static void record_data(struct common_record_context *ctx)
 				add_guest_info(handle, instance);
 		}
 
+		if (ctx->tsc2nsec.mult)
+			add_tsc2nsec(handle, &ctx->tsc2nsec);
+
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
@@ -6582,7 +6606,7 @@ static void record_trace(int argc, char **argv,
 			trace_or_sleep(type, pwait);
 	}
 
-	tell_guests_to_stop();
+	tell_guests_to_stop(ctx);
 	tracecmd_disable_tracing();
 	if (!latency)
 		stop_threads(type);
-- 
2.30.2

