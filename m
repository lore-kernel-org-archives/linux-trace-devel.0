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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42B8C433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B07022267
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0+0HBTC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733299AbgJIODy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIODx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:53 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E47FC0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u21so13263927eja.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3b6GesA4qqHSKQfIqEOtQ3vY0naf0NLQ1PKjVpfa4lc=;
        b=j0+0HBTCS6+dnIVFDJ1DGaSwIiaZHQWrU+qRRKGiTz3ryaEnvjVhVM/97GuOIANLmI
         xpwPlQk23DgjIDukxUAxfJO70JFWhbyC4twf2fOJRE1Jvq3trPs3/cn8ErgPtQV7e/A7
         Ti7cPamGZA7Tv82ghImSDRLTMvTno0ondCcmQCwysjmd94tkxtjO8JL3IUFHk7TEoGh+
         qQZevBNEDcgfT2D5kJQZLGoYM7ivZ2nHTH63RdKZw5S5Sn8ZfqXQ+aIyO8gC9+Qplrfc
         ddk2fDmv58NYeWkJp4A7qTJJjNMhyJ67tPNvLEILDzSGH66eVPvkXHKyGUDxINnp7IxL
         1AxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3b6GesA4qqHSKQfIqEOtQ3vY0naf0NLQ1PKjVpfa4lc=;
        b=P/BzKQ71bucen8MtnrwZnnF35Zm1jhjdcrmLi8hxhJU4ccagXbAf5gGybOiFUvEHnJ
         KUwSDHZg+t1bIlRmBZJ/5KNPrRW4dgUVXxtgJNRQ0WBcqJ94JCn0FbqB1muqqcal4+dC
         tSBzgulqDCjEOZgRDSSlVmwPM9LGceeJMsigRgEiOfxYdyqIdUQBdW3ifigxhXDxqkYC
         JkyQ0uNxOWe/RikFBVHrx6LmjQHUw9BgQ8FwHlE6rUuTVdZ/iLD+41SpWgnQV6ruyNWe
         TW/WMASoSwwds8vW509rz3rkJ7FEajNPl2BXFxn3rFJx43VQTNBdYzdfEbMuZg7JW04T
         bkqA==
X-Gm-Message-State: AOAM532As17SeF29mu1RvoNuEj1kqM1HP3bazzeIrOAtdYXw3j5DPQGf
        QWqAUgaJOxebGZ25cmpEuXLKbqpiE2umNnue
X-Google-Smtp-Source: ABdhPJynOOc44Rg37jgY4q92TRJXdiKalG42yKrSfhlC+k38dDqkcRYFYbxoRaHC8ReocGBJQIfhSw==
X-Received: by 2002:a17:906:28db:: with SMTP id p27mr14808992ejd.424.1602252231880;
        Fri, 09 Oct 2020 07:03:51 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 06/10] trace-cmd: Add role parameter to timestamp synchronization plugins
Date:   Fri,  9 Oct 2020 17:03:34 +0300
Message-Id: <20201009140338.25260-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/include/trace-tsync-local.h | 10 +++++-----
 lib/trace-cmd/trace-timesync-ptp.c        |  2 ++
 lib/trace-cmd/trace-timesync.c            | 16 ++++++++++++----
 tracecmd/trace-record.c                   |  3 ++-
 tracecmd/trace-tsync.c                    |  3 ++-
 6 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 66b5d02b..f1068c49 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -442,6 +442,11 @@ enum{
 	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
 };
 
+enum tracecmd_time_sync_role {
+	TRACECMD_TIME_SYNC_ROLE_HOST	= 0x01,
+	TRACECMD_TIME_SYNC_ROLE_GUEST	= 0x02
+};
+
 #define TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT	10
 
 struct tracecmd_time_sync {
@@ -455,8 +460,9 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock);
-unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words, char *clock);
+int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock, int role);
+unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words, char *clock,
+					 enum tracecmd_time_sync_role role);
 bool tsync_proto_is_supported(unsigned int proto_id);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 37c3597b..b79b102c 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -26,12 +26,12 @@ struct clock_sync_context {
 	unsigned int			remote_port;
 };
 
-int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
+int tracecmd_tsync_proto_register(unsigned int proto_id, int weight, int roles,
 				  int supported_clocks,
-				int (*init)(struct tracecmd_time_sync *),
-				int (*free)(struct tracecmd_time_sync *),
-				int (*calc)(struct tracecmd_time_sync *,
-					    long long *, long long *));
+				  int (*init)(struct tracecmd_time_sync *),
+				  int (*free)(struct tracecmd_time_sync *),
+				  int (*calc)(struct tracecmd_time_sync *,
+					      long long *, long long *));
 int tracecmd_tsync_proto_unregister(unsigned int proto_id);
 
 int ptp_clock_sync_register(void);
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 51f17bca..07ce3b6e 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -678,6 +678,8 @@ int ptp_clock_sync_register(void)
 {
 	return tracecmd_tsync_proto_register(TRACECMD_TIME_SYNC_PROTO_PTP,
 					     TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT,
+					     TRACECMD_TIME_SYNC_ROLE_GUEST |
+					     TRACECMD_TIME_SYNC_ROLE_HOST,
 					     0,
 					     ptp_clock_sync_init,
 					     ptp_clock_sync_free,
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 47d34e2a..807fb6f5 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -25,6 +25,7 @@
 struct tsync_proto {
 	struct tsync_proto *next;
 	unsigned int proto_id;
+	enum tracecmd_time_sync_role roles;
 	int	weight;
 	int supported_clocks;
 
@@ -55,7 +56,7 @@ void tracecmd_tsync_init(void)
 	ptp_clock_sync_register();
 }
 
-int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
+int tracecmd_tsync_proto_register(unsigned int proto_id, int weight, int roles,
 				int supported_clocks,
 				int (*init)(struct tracecmd_time_sync *),
 				int (*free)(struct tracecmd_time_sync *),
@@ -71,6 +72,7 @@ int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
 		return -1;
 	proto->proto_id = proto_id;
 	proto->weight = weight;
+	proto->roles = roles;
 	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
@@ -142,12 +144,13 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  *
  * @proto_mask: bitmask array of time sync protocols, supported by the peer
  * @length: size of the @protos array
- * @clock: selected trace clock
+ * @role : local time sync role
  *
  * Retuns Id of a time sync protocol, that can be used with the peer, or 0
  *	  in case there is no match with supported protocols
  */
-unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length, char *clock)
+unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length, char *clock,
+					 enum tracecmd_time_sync_role role)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
@@ -159,6 +162,8 @@ unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length, char *clo
 		clock_id = tracecmd_clock_str2id(clock);
 	for (word = 0; word < length; word++) {
 		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (!(proto->roles & role))
+				continue;
 			if (proto->supported_clocks && clock_id &&
 			    !(proto->supported_clocks & clock_id))
 				continue;
@@ -192,12 +197,13 @@ unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length, char *clo
  *	       supported by the peer. Must be freed by free()
  * @words: return, allocated size of the @protobits array
  * @clock: selected trace clock
+ * @role: supported protocol role
  *
  * If completed successfully 0 is returned and allocated array in @proto_mask of
  * size @words. In case of an error, -1 is returned.
  * @proto_mask must be freed with free()
  */
-int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock)
+int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock, int role)
 {
 	struct tsync_proto *proto;
 	int proto_max = 0;
@@ -219,6 +225,8 @@ int tracecmd_tsync_proto_getall(char **proto_mask, int *words, const char *clock
 	for (proto = tsync_proto_list; proto; proto = proto->next) {
 		if ((proto->proto_id / PROTO_MASK_SIZE) >= count)
 			continue;
+		if (!(proto->roles & role))
+			continue;
 		if (proto->supported_clocks && clock_id &&
 		    !(proto->supported_clocks & clock_id))
 			continue;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 08bbc0e0..ff70df43 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3677,7 +3677,8 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to allocate message handle");
 
 	if (instance->tsync.loop_interval >= 0)
-		tracecmd_tsync_proto_getall(&protos, &protos_count, instance->clock);
+		tracecmd_tsync_proto_getall(&protos, &protos_count, instance->clock,
+					    TRACECMD_TIME_SYNC_ROLE_HOST);
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 832b70c3..051b1003 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -220,7 +220,8 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size, clock);
+	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size,
+					    clock, TRACECMD_TIME_SYNC_ROLE_GUEST);
 	if (!proto)
 		return 0;
 #ifdef VSOCK
-- 
2.26.2

