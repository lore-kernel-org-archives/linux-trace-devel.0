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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBD9C55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0E720796
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rcfq/8Rg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgJ2LS0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgJ2LS0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97570C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id n18so2316790wrs.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QYaNTjkzM/NU4fiSxZjBlvOYiFYCZJuXfOaHoIjd6MY=;
        b=rcfq/8Rg0LAwa5NQpQqkPZYX8XjCCClXNC7z2Zo2lqO5SmNCxe9AXmuFwGVGf2ag/V
         ugRBzAR3gan7Pc6MJacmGhkyvhq6sJqnZ4ulCN3bKY2/We/SVnyS6VpffaeJri6DCPPs
         0qTOgGI1lwgkM9+dhTW7c1mV0RoazxNh+VOLChvRcF44fdphwRYc5YdKGN/sl4DHWx+4
         d+p/xZkr2AQaFkyQ9LdEeNcBYklzfdGkWFbbd58iqx/TiIKxm2MMvEEeU6n5shkvS+y1
         jpOZWig8aRsEQLFwCozNG4bNYFTd9BPCCIIrHOPon6cfdMp35udvxuVhu0sOI3syuwIF
         bg6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYaNTjkzM/NU4fiSxZjBlvOYiFYCZJuXfOaHoIjd6MY=;
        b=StbfuZLf/vN4xTjvvAidq5Z1Bvktp9cYEt8JQS/qKr/I24hvbsAvRAo5vMonunH8TL
         o1FiWtTcH2k2TJnT120U+kYTFrMVkr6Xj/10Hnbg7yOxV+pYfOObpnSassQmsFpx5Zvo
         DdUeLxO1dLxtHRb/PIgmsT3nwZaabu1BsX80YdtmyVmFPQ9+WjpKD+p65q2tbcGeRWeJ
         PBcvp3cheMokgNMU/lIUMaTXOJKkeDo3vnmcAPUFNI/Jlj/fR4cWbePiHAJvlXsEpeeU
         yhdd4YvM6qmxRmDg/Al1Z8rHENVi9i9tcPuRXhwJYiBAW+9lFsV5fEkRtFpCqO/k+vu9
         63uQ==
X-Gm-Message-State: AOAM530j/C7KI10vIt46s5H2+E1qG61vnE85JzozMypdYcedJ+FDd+et
        QaWeAHD6sgANPWtIrABsPOOnBPS+Ha8kGyLn
X-Google-Smtp-Source: ABdhPJx3hOeQDoPjJOmTjQcm0jlC8dzkfiKHYI6drW00PiRzs2JHTwuFUxtkpKfV21FZ//DYHbcbnQ==
X-Received: by 2002:adf:fe4b:: with SMTP id m11mr4678316wrs.98.1603970304313;
        Thu, 29 Oct 2020 04:18:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 05/16] trace-cmd: Add clock parameter to timestamp synchronization plugins
Date:   Thu, 29 Oct 2020 13:18:05 +0200
Message-Id: <20201029111816.247241-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-timesync.c            | 29 +++++++++++++++++++----
 tracecmd/trace-record.c                   | 10 +++++++-
 tracecmd/trace-tsync.c                    |  2 +-
 5 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index b48381cd..21028940 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -448,8 +448,8 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(char ***protos);
-char *tracecmd_tsync_proto_select(char **protos);
+int tracecmd_tsync_proto_getall(char ***protos, const char *clock);
+char *tracecmd_tsync_proto_select(char **protos, char *clock);
 bool tsync_proto_is_supported(char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 1f3bc443..25d5b4e8 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -27,6 +27,7 @@ struct clock_sync_context {
 };
 
 int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
+				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 58c92ef3..8ca47bf6 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -26,6 +26,7 @@ struct tsync_proto {
 	struct tsync_proto *next;
 	char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
 	int accuracy;
+	int supported_clocks;
 
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
@@ -50,6 +51,7 @@ static struct tsync_proto *tsync_proto_find(char *proto_name)
 }
 
 int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
+				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
@@ -64,6 +66,7 @@ int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
 		return -1;
 	strncpy(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH);
 	proto->accuracy = accuracy;
+	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
 	proto->clock_sync_calc = calc;
@@ -137,20 +140,26 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  *		timestamp synchronization with a peer
  *
  * @protos: array of pointers to protocol names
+ * @clock : trace clock
  *
  * Retuns pointer to a protocol name, that can be used with the peer, or NULL
  *	  in case there is no match with supported protocols.
  *	  The returned string MUST NOT be freed by the caller
  */
-char *tracecmd_tsync_proto_select(char **protos)
+char *tracecmd_tsync_proto_select(char **protos, char *clock)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
 	char **pname;
+	int clock_id = 0;
 
+	clock_id = tracecmd_clock_str2id(clock);
 	pname = protos;
 	while (*pname) {
 		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (proto->supported_clocks && clock_id &&
+			    !(proto->supported_clocks & clock_id))
+				continue;
 			if (strncmp(proto->proto_name, *pname, TRACECMD_TSYNC_PNAME_LENGTH))
 				continue;
 			if (selected) {
@@ -173,26 +182,38 @@ char *tracecmd_tsync_proto_select(char **protos)
  *				 time sync protocols
  * @protos: return, allocated array of time sync protocol names,
  *	       supported by the peer. Must be freed by free()
+ * @clock: selected trace clock
  *
  * If completed successfully 0 is returned and allocated array in @protos of
  * strings. The last array entry is NULL.  In case of an error, -1 is returned.
  * @protos must be freed with free()
  */
-int tracecmd_tsync_proto_getall(char ***protos)
+int tracecmd_tsync_proto_getall(char ***protos, const char *clock)
 {
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
 
 	*protos = calloc(count, sizeof(char *));
 	if (!protos)
 		return -1;
 
-	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next)
+	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next) {
+		if (proto->supported_clocks && clock_id &&
+		    !(proto->supported_clocks & clock_id))
+			continue;
 		(*protos)[i++] = proto->proto_name;
+	}
 
 	return 0;
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1149aaaa..41e0dd3a 100644
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
@@ -6112,6 +6115,11 @@ static void parse_record_options(int argc,
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
index bd96110d..2c8afe30 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -219,7 +219,7 @@ char *tracecmd_guest_tsync(char **tsync_protos, char *clock,
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos);
+	proto = tracecmd_tsync_proto_select(tsync_protos, clock);
 	if (!proto)
 		return NULL;
 #ifdef VSOCK
-- 
2.26.2

