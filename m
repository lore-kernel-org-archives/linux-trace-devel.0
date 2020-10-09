Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DF8C43457
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7080E222C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEyrIMEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733094AbgJIODw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIODw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:52 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B7EC0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p15so13237090ejm.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m7xHhuDlWK65akferD7vkCI6GxaaW3rgPB+dHtNxTYM=;
        b=TEyrIMEGQmbbRwxukwkcDnwlaknJgR7MqWKijL6WhoLTxQsQrZI2+gWuQ78WRMWWnB
         arH/omim6f77MSdYrmxuHwPeIhfSAqLs3LA+DRmtVbwdnO4aLWkLd5zLyfvnkeX7KHz8
         +A9yEGY1SsAJ3lfCNU/JpM83ZhY8y+VJXFPqgVyNOTP++v0T+SkWYLPS/QWXK4h56zRq
         k6373yKjaqLWGOrBpwbZVGoRMKruMTC+irQuTOUoi+C6Ghclf/PRoRFclRsXo4yWd490
         Xnig6kCiFeIYuidREwcXlsXiV9FZ6mrf7V5LLBkBVM09U8JssUl1jqQwnIvEdDDHhYik
         44qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7xHhuDlWK65akferD7vkCI6GxaaW3rgPB+dHtNxTYM=;
        b=EJNbQI4wKuEZ5araXJCU4XfTEWI4/CELzqKfiep4OVYcYzMVbtuG/4bxpiA4YSW8pF
         tYJ82JOMNwrToaUAWEw4Sea/bRd9GddbJ6/LmaZ8QGS09R/41u5x244mjSMMDgp5wHSh
         fcYWOJBLfo8yUVSNFwJ0TEQwF2rG7iXaliw/sA14AKjWgHeX/mtHxY2eU1QO9D9UPNLy
         d26h4EHwmJgFlWhkwYlnBaRr6Q04vVpcSL215XBUAs/b1I2tVLiVop8sF+f7GSdaHTpr
         Ct1c4AtASSIHR9abNmkTG7Nv9yhxwprPuiUXzcZ1oEd3dTiNMt2SZiiCfF/ne7i13H7t
         Q4AQ==
X-Gm-Message-State: AOAM53194ulcWB8ghF0mec5KxD9Tj4G424omhy7K8TpSdeT18C4OR63V
        i+w6giYhcX/EYH9GtSCZv78JYJNBv8uPPwht
X-Google-Smtp-Source: ABdhPJzEibVfIcEMoNwKcikRTyaZ5kdIvNMgXahvlnbnnNUlAXbIRfHR9wNp6znHwRt6/M8HVzajFw==
X-Received: by 2002:a17:906:f259:: with SMTP id gy25mr13668527ejb.499.1602252230345;
        Fri, 09 Oct 2020 07:03:50 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 05/10] trace-cmd: Add clock parameter to timestamp synchronization plugins
Date:   Fri,  9 Oct 2020 17:03:33 +0300
Message-Id: <20201009140338.25260-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some timestamp synchronization plugins may not support all ftrace
clocks. Added logic to timestamp synchronization plugins to declare what
ftace clocks they support. Added logic to select plugin depending on the
ftrace clock used in the current trace session and supported clocks.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h             |  4 ++--
 lib/trace-cmd/include/trace-tsync-local.h |  1 +
 lib/trace-cmd/trace-timesync-ptp.c        |  1 +
 lib/trace-cmd/trace-timesync.c            | 21 +++++++++++++++++++--
 tracecmd/trace-record.c                   |  4 +++-
 tracecmd/trace-tsync.c                    |  2 +-
 6 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 393a2e7b..66b5d02b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -455,8 +455,8 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(char **proto_mask, int *words);
-unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words);
+int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock);
+unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words, char *clock);
 bool tsync_proto_is_supported(unsigned int proto_id);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 1de9d5e5..37c3597b 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -27,6 +27,7 @@ struct clock_sync_context {
 };
 
 int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
+				  int supported_clocks,
 				int (*init)(struct tracecmd_time_sync *),
 				int (*free)(struct tracecmd_time_sync *),
 				int (*calc)(struct tracecmd_time_sync *,
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 19e2f647..51f17bca 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -678,6 +678,7 @@ int ptp_clock_sync_register(void)
 {
 	return tracecmd_tsync_proto_register(TRACECMD_TIME_SYNC_PROTO_PTP,
 					     TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT,
+					     0,
 					     ptp_clock_sync_init,
 					     ptp_clock_sync_free,
 					     ptp_clock_sync_calc);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index e294698b..47d34e2a 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -26,6 +26,7 @@ struct tsync_proto {
 	struct tsync_proto *next;
 	unsigned int proto_id;
 	int	weight;
+	int supported_clocks;
 
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
@@ -55,6 +56,7 @@ void tracecmd_tsync_init(void)
 }
 
 int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
+				int supported_clocks,
 				int (*init)(struct tracecmd_time_sync *),
 				int (*free)(struct tracecmd_time_sync *),
 				int (*calc)(struct tracecmd_time_sync *,
@@ -69,6 +71,7 @@ int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
 		return -1;
 	proto->proto_id = proto_id;
 	proto->weight = weight;
+	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
 	proto->clock_sync_calc = calc;
@@ -139,19 +142,26 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  *
  * @proto_mask: bitmask array of time sync protocols, supported by the peer
  * @length: size of the @protos array
+ * @clock: selected trace clock
  *
  * Retuns Id of a time sync protocol, that can be used with the peer, or 0
  *	  in case there is no match with supported protocols
  */
-unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
+unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length, char *clock)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
+	int clock_id = 0;
 	int word;
 	int id;
 
+	if (clock)
+		clock_id = tracecmd_clock_str2id(clock);
 	for (word = 0; word < length; word++) {
 		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (proto->supported_clocks && clock_id &&
+			    !(proto->supported_clocks & clock_id))
+				continue;
 			if (proto->proto_id < word * PROTO_MASK_SIZE)
 				continue;
 
@@ -181,18 +191,22 @@ unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
  * @proto_mask: return, allocated bitmask array of time sync protocols,
  *	       supported by the peer. Must be freed by free()
  * @words: return, allocated size of the @protobits array
+ * @clock: selected trace clock
  *
  * If completed successfully 0 is returned and allocated array in @proto_mask of
  * size @words. In case of an error, -1 is returned.
  * @proto_mask must be freed with free()
  */
-int tracecmd_tsync_proto_getall(char **proto_mask, int *words)
+int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock)
 {
 	struct tsync_proto *proto;
 	int proto_max = 0;
+	int clock_id = 0;
 	int count = 0;
 	char *protos;
 
+	if (clock)
+		clock_id =  tracecmd_clock_str2id(clock);
 	for (proto = tsync_proto_list; proto; proto = proto->next)
 		if (proto->proto_id > proto_max)
 			proto_max = proto->proto_id;
@@ -205,6 +219,9 @@ int tracecmd_tsync_proto_getall(char **proto_mask, int *words)
 	for (proto = tsync_proto_list; proto; proto = proto->next) {
 		if ((proto->proto_id / PROTO_MASK_SIZE) >= count)
 			continue;
+		if (proto->supported_clocks && clock_id &&
+		    !(proto->supported_clocks & clock_id))
+			continue;
 		protos[proto->proto_id / PROTO_MASK_SIZE] |=
 				(1 << (proto->proto_id % PROTO_MASK_SIZE));
 	}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9149cf76..08bbc0e0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3677,7 +3677,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to allocate message handle");
 
 	if (instance->tsync.loop_interval >= 0)
-		tracecmd_tsync_proto_getall(&protos, &protos_count);
+		tracecmd_tsync_proto_getall(&protos, &protos_count, instance->clock);
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
@@ -6111,6 +6111,8 @@ static void parse_record_options(int argc,
 						 (char *)top_instance.clock,
 						 true);
 					add_argv(instance, "-C", true);
+					if (!instance->clock)
+						instance->clock = strdup((char *)top_instance.clock);
 				}
 			}
 			instance->tsync.loop_interval = top_instance.tsync.loop_interval;
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index e639788d..832b70c3 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -220,7 +220,7 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size);
+	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size, clock);
 	if (!proto)
 		return 0;
 #ifdef VSOCK
-- 
2.26.2

