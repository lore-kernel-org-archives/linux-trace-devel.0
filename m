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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9A3C4332D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930F323356
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbhAUHry (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbhAUHpp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:45:45 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD019C0613ED
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id g10so747558wrx.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pqhAbFPGd3uhm9st1v+lpphhcpVExohF68ZE+q552hI=;
        b=lwrrHw0B5eLEILi+FJLfYwM2Eetan7quk7rn9h1/G4hVlUMqAvo3wEu7nChijFL2B0
         JGGfxiLNRDPGKWRLdbujqjbf+aBQC2RQuokSy0o5GTYxP1DK4zhAHe6EZfGryaSEbXqU
         3BnTanoxj9Rt0d+48Zs/sm80tq32u9z75396yOBw9Qh4YlIqCK+IJC+G6ax1O7r3hgMZ
         Ki0P31QYMZ7wz9JKBZY2U/Js9w21/hPLmdcCMIg4xL+OW9rVUqqqu86jT5/8t9SyCxSN
         SvVi7rmN5LvBo4dcX7fxW1X0lfdArBVOiE+RUrlmLMOsEbLRJI/q7lJbIvSPjrt9Eyxm
         48zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pqhAbFPGd3uhm9st1v+lpphhcpVExohF68ZE+q552hI=;
        b=DEvdVbllQaBKNntsltixPwfqI5xFXrLloY6dSersK6zCQoqc2UTIylrZDP0NhJeoeM
         hfpQdXwPoro5bV7xxlMkk8DOOuIM/diIX+zKwhVw2aWmXfz0z5n1OLHJyRZwSpLOLZde
         sy7bjIMCIobwubycmtdqQ09R/Qt7N+nwRTNbldOjXb/S2kNC29vky97xh9I0zlKC+tlX
         PLo2Iq4mHuBSKWFdt7p9BiiJOKExpbNsW2/KZvrTU9tVFX3usNXQS3+EswJLJ8fmDZKX
         A43pWDG3AofokGA02oPT7NKRPueXm84yLqBlIcvlp9Y9gzVkAZIV4a22buWozBkRSMFu
         TiyA==
X-Gm-Message-State: AOAM530XOCBEdTBbAM4dxdMC10uEsfXfXKjCbxT3d03mSlfJvJWMSdwW
        nfzTv77XqQzFtwMvXj6fUe/rfeSnlSwEGayV
X-Google-Smtp-Source: ABdhPJw0O3rVyX4ttZ3egKlEXNTcVgYojjSCCTx+Rb7bO9CvX46VE+z9I3vsm6mfJ8cblsvCjlm28Q==
X-Received: by 2002:adf:fe04:: with SMTP id n4mr9424452wrr.115.1611215103632;
        Wed, 20 Jan 2021 23:45:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 04/15] trace-cmd: Add clock parameter to timestamp synchronization plugins
Date:   Thu, 21 Jan 2021 09:44:45 +0200
Message-Id: <20210121074456.157658-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some timestamp synchronization plugins may not support all ftrace
clocks. Added logic to timestamp synchronization plugins to declare what
ftrace clocks they support. Added logic to select plugin depending on the
ftrace clock used in the current trace session and supported clocks.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  4 +--
 lib/trace-cmd/include/trace-tsync-local.h     |  1 +
 lib/trace-cmd/trace-timesync.c                | 30 +++++++++++++++----
 tracecmd/trace-record.c                       | 10 ++++++-
 tracecmd/trace-tsync.c                        |  2 +-
 5 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0d323947..ff700e44 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -430,8 +430,8 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos);
-const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos);
+int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock);
+const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock);
 bool tsync_proto_is_supported(const char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 58841a4c..96ec89e9 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -27,6 +27,7 @@ struct clock_sync_context {
 };
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
+				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index c9fde0fa..0d46d294 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -26,6 +26,7 @@ struct tsync_proto {
 	struct tsync_proto *next;
 	char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
 	int accuracy;
+	int supported_clocks;
 
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
@@ -50,6 +51,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
 }
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
+				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
@@ -64,6 +66,7 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
 		return -1;
 	strncpy(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH);
 	proto->accuracy = accuracy;
+	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
 	proto->clock_sync_calc = calc;
@@ -137,23 +140,29 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  *		timestamp synchronization with a peer
  *
  * @protos: list of tsync protocol names
+ * @clock : trace clock
  *
  * Retuns pointer to a protocol name, that can be used with the peer, or NULL
  *	  in case there is no match with supported protocols.
  *	  The returned string MUST NOT be freed by the caller
  */
-const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos)
+const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
 	char **pname;
+	int clock_id = 0;
 
 	if (!protos)
 		return NULL;
 
+	clock_id = tracecmd_clock_str2id(clock);
 	pname = protos->names;
 	while (*pname) {
 		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (proto->supported_clocks && clock_id &&
+			    !(proto->supported_clocks & clock_id))
+				continue;
 			if (strncmp(proto->proto_name, *pname, TRACECMD_TSYNC_PNAME_LENGTH))
 				continue;
 			if (selected) {
@@ -176,20 +185,28 @@ const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos)
  *				 time sync protocols
  * @protos: return, allocated list of time sync protocol names,
  *	       supported by the peer. Must be freed by free()
+ * @clock: selected trace clock
  *
  * If completed successfully 0 is returned and allocated list of strings in @protos.
  * The last list entry is NULL. In case of an error, -1 is returned.
  * @protos must be freed with free()
  */
-int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos)
+int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock)
 {
 	struct tracecmd_tsync_protos *plist = NULL;
 	struct tsync_proto *proto;
+	int clock_id = 0;
 	int count = 1;
 	int i;
 
-	for (proto = tsync_proto_list; proto; proto = proto->next)
+	if (clock)
+		clock_id =  tracecmd_clock_str2id(clock);
+	for (proto = tsync_proto_list; proto; proto = proto->next) {
+		if (proto->supported_clocks && clock_id &&
+		    !(proto->supported_clocks & clock_id))
+			continue;
 		count++;
+	}
 	plist = calloc(1, sizeof(struct tracecmd_tsync_protos));
 	if (!plist)
 		goto error;
@@ -197,9 +214,12 @@ int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos)
 	if (!plist->names)
 		return -1;
 
-	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next)
+	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next) {
+		if (proto->supported_clocks && clock_id &&
+		    !(proto->supported_clocks & clock_id))
+			continue;
 		plist->names[i++] = proto->proto_name;
-
+	}
 	*protos = plist;
 	return 0;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a0e128d6..51b8562b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3675,8 +3675,11 @@ static void connect_to_agent(struct buffer_instance *instance)
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
+	if (!instance->clock)
+		instance->clock = tracefs_get_clock(NULL);
+
 	if (instance->tsync.loop_interval >= 0)
-		tracecmd_tsync_proto_getall(&protos);
+		tracecmd_tsync_proto_getall(&protos, instance->clock);
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
@@ -6098,6 +6101,11 @@ static void parse_record_options(int argc,
 						 (char *)top_instance.clock,
 						 true);
 					add_argv(instance, "-C", true);
+					if (!instance->clock) {
+						instance->clock = strdup((char *)top_instance.clock);
+						if (!instance->clock)
+							die("Could not allocate instance clock");
+					}
 				}
 			}
 			instance->tsync.loop_interval = top_instance.tsync.loop_interval;
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 5781cfd2..55e9857f 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -223,7 +223,7 @@ const char *tracecmd_guest_tsync(struct tracecmd_tsync_protos *tsync_protos,
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos);
+	proto = tracecmd_tsync_proto_select(tsync_protos, clock);
 	if (!proto)
 		return NULL;
 #ifdef VSOCK
-- 
2.29.2

