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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB815C55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6428020796
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STpmlZXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgJ2LSb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgJ2LS2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE09CC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id n15so2344233wrq.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cb+oK8tVhUkQDeu14chNKCs2RfwQZkPrbkYZHv9Vey8=;
        b=STpmlZXk2LDlMJsBV8h4JDi5p4FK3tddrYGhawpmmwZMKp/4SZaOedvrVGBfDvzpxo
         Suxv2bWIn/lsbB6rKZTT0XsgO0s+jptt5tyW1na8yzLhwYzlTwZrFJG5DM53ooVCKeS4
         jgmdPUMpeoGhuB9HhH+a9Us2OTCZpury72Cy9Nz9e+Y7fPqA9wgSbhIrpvnz7716xA1u
         QCkL1Xovg8+wf4zOZJX//XvgNmDQi4ozGQAF1hZ26LpvIz5u4ERKmLjOjy8t6WRpGiG+
         gSWiLD5NL2Kfnb+MOUo7NmoWBHBER5GVb7tMRIScjF+ibocVCaBfgKYnZ3rpJv5YQ/mO
         rN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cb+oK8tVhUkQDeu14chNKCs2RfwQZkPrbkYZHv9Vey8=;
        b=HQr4QuxJclaVFnZ4flLg8dTZnCgI35yEza9/6eHPVv3uvZNx2Z/NdMmRspgLr+w+yQ
         tqnTKvvCFIuyVBihZAjG099CL5zdxKH3pfmgD4X4/0BLQlq5eIRxbQix3TjeTFgEom4i
         3+3N9bSSNfIulZgUkPpCn1OsvYKDrE/shOh3goKLlIC5mR8GIYsRkYn1DvtOk42pO4Z6
         H6JoosZWR+RFGOqmY7olkctYlL9GEsmGcq+NxgrWHfRbqAVaCtorF2yzsbS1rgA0UP/z
         aIXVhYmZUXX6kXCUR/TLQO3ZVcdOH0hpu2iplGPlAnOGGfMaQT4HtS9npQrQ6eGugMFe
         vQ6w==
X-Gm-Message-State: AOAM530/XBatXsRxAyBosPkVg9+zICuTRgswyBW7zZk9pJKntLid4bEg
        ooohPKvLOiArspCBUCEHsmSGr8BwG+rZeEAO
X-Google-Smtp-Source: ABdhPJwU39cNZcAGk/yPCPVh67l9l898tgP1tML7GoUhnFf0SW3xq4HveP4rmonU52QHJZJOnkfAoA==
X-Received: by 2002:adf:e643:: with SMTP id b3mr4928041wrn.408.1603970305436;
        Thu, 29 Oct 2020 04:18:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 06/16] trace-cmd: Add role parameter to timestamp synchronization plugins
Date:   Thu, 29 Oct 2020 13:18:06 +0200
Message-Id: <20201029111816.247241-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Defined HOST and GUEST roles in timestamp synchronization context.
Some timestamp synchronization plugins may not support running in both
host and guest roles. This could happen in nested virtualization use
case, where the same plugin can be used as a host and as a guest.
Added logic to timestamp synchronization plugins to declare what roles
they support. Added logic to select plugin depending on supported roles
and currently requested role.

clocks. Added logic to timestamp synchronization plugins to declare what
ftace clocks they support. Added logic to select plugin depending on the
ftrace clock used in the current trace session and supported clocks.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h             | 10 ++++++++--
 lib/trace-cmd/include/trace-tsync-local.h |  2 +-
 lib/trace-cmd/trace-timesync.c            | 17 ++++++++++++++---
 tracecmd/trace-record.c                   |  3 ++-
 tracecmd/trace-tsync.c                    |  3 ++-
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 21028940..1ca2da10 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -437,6 +437,11 @@ enum{
 	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
 };
 
+enum tracecmd_time_sync_role {
+	TRACECMD_TIME_SYNC_ROLE_HOST	= 0x01,
+	TRACECMD_TIME_SYNC_ROLE_GUEST	= 0x02
+};
+
 struct tracecmd_time_sync {
 	char				*proto_name;
 	int				loop_interval;
@@ -448,8 +453,9 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(char ***protos, const char *clock);
-char *tracecmd_tsync_proto_select(char **protos, char *clock);
+int tracecmd_tsync_proto_getall(char ***protos, const char *clock, int role);
+char *tracecmd_tsync_proto_select(char **protos, char *clock,
+				  enum tracecmd_time_sync_role role);
 bool tsync_proto_is_supported(char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 25d5b4e8..33add609 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -26,7 +26,7 @@ struct clock_sync_context {
 	unsigned int			remote_port;
 };
 
-int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
+int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
 				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 8ca47bf6..d461392b 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -25,6 +25,7 @@
 struct tsync_proto {
 	struct tsync_proto *next;
 	char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
+	enum tracecmd_time_sync_role roles;
 	int accuracy;
 	int supported_clocks;
 
@@ -50,7 +51,7 @@ static struct tsync_proto *tsync_proto_find(char *proto_name)
 	return NULL;
 }
 
-int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
+int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
 				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
@@ -66,6 +67,7 @@ int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
 		return -1;
 	strncpy(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH);
 	proto->accuracy = accuracy;
+	proto->roles = roles;
 	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
@@ -141,12 +143,14 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  *
  * @protos: array of pointers to protocol names
  * @clock : trace clock
+ * @role : local time sync role
  *
  * Retuns pointer to a protocol name, that can be used with the peer, or NULL
  *	  in case there is no match with supported protocols.
  *	  The returned string MUST NOT be freed by the caller
  */
-char *tracecmd_tsync_proto_select(char **protos, char *clock)
+char *tracecmd_tsync_proto_select(char **protos, char *clock,
+				  enum tracecmd_time_sync_role role)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
@@ -157,6 +161,8 @@ char *tracecmd_tsync_proto_select(char **protos, char *clock)
 	pname = protos;
 	while (*pname) {
 		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (!(proto->roles & role))
+				continue;
 			if (proto->supported_clocks && clock_id &&
 			    !(proto->supported_clocks & clock_id))
 				continue;
@@ -183,12 +189,13 @@ char *tracecmd_tsync_proto_select(char **protos, char *clock)
  * @protos: return, allocated array of time sync protocol names,
  *	       supported by the peer. Must be freed by free()
  * @clock: selected trace clock
+ * @role: supported protocol role
  *
  * If completed successfully 0 is returned and allocated array in @protos of
  * strings. The last array entry is NULL.  In case of an error, -1 is returned.
  * @protos must be freed with free()
  */
-int tracecmd_tsync_proto_getall(char ***protos, const char *clock)
+int tracecmd_tsync_proto_getall(char ***protos, const char *clock, int role)
 {
 	struct tsync_proto *proto;
 	int clock_id = 0;
@@ -198,6 +205,8 @@ int tracecmd_tsync_proto_getall(char ***protos, const char *clock)
 	if (clock)
 		clock_id =  tracecmd_clock_str2id(clock);
 	for (proto = tsync_proto_list; proto; proto = proto->next) {
+		if (!(proto->roles & role))
+			continue;
 		if (proto->supported_clocks && clock_id &&
 		    !(proto->supported_clocks & clock_id))
 			continue;
@@ -209,6 +218,8 @@ int tracecmd_tsync_proto_getall(char ***protos, const char *clock)
 		return -1;
 
 	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next) {
+		if (!(proto->roles & role))
+			continue;
 		if (proto->supported_clocks && clock_id &&
 		    !(proto->supported_clocks & clock_id))
 			continue;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 41e0dd3a..b4e68234 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3679,7 +3679,8 @@ static void connect_to_agent(struct buffer_instance *instance)
 		instance->clock = tracefs_get_clock(NULL);
 
 	if (instance->tsync.loop_interval >= 0)
-		tracecmd_tsync_proto_getall(&protos, instance->clock);
+		tracecmd_tsync_proto_getall(&protos, instance->clock,
+					    TRACECMD_TIME_SYNC_ROLE_HOST);
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 2c8afe30..aede3754 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -219,7 +219,8 @@ char *tracecmd_guest_tsync(char **tsync_protos, char *clock,
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos, clock);
+	proto = tracecmd_tsync_proto_select(tsync_protos, clock,
+					    TRACECMD_TIME_SYNC_ROLE_GUEST);
 	if (!proto)
 		return NULL;
 #ifdef VSOCK
-- 
2.26.2

