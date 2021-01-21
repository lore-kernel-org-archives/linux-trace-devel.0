Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD2AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D04B221F7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbhAUHrA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbhAUHqu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:46:50 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00262C061786
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:05 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m4so726069wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5AAAU2KuAwiS3y+C6rroB9X9yFzrMkMjZzsI+OdnWqM=;
        b=P6/JD0qHl51bGO8ku603PheTdRs8jhwxmKccwGeB2lABLmTdPB8t7r27dw973oF2i2
         v3Euxf8RHhgLnE8ZtfIrxYret5xEBa1VxStkBJ0MF/cu9GMT74ff4PuzVj5leYTwirYo
         ObPfnSBqT3aYuKzhUS9Cvbo3/tzQ3tsb2BpYBeGfy/qSSNuisF2twHXJW5gIKdwSAkWu
         RyEunMjP+J6g5wf/HCZuOfcD+ab8VDR4B1Vfbx7N5TyVS+84Z+XEngnUI/E6qGthN3cc
         00h9HykpipEko+A1lnQGTPQRzLrUVzPGhDvfQJd5F6FrwcYkjgnbnMUKaMnqX8xYeXxc
         cAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5AAAU2KuAwiS3y+C6rroB9X9yFzrMkMjZzsI+OdnWqM=;
        b=qup32bMvERFdz27fGHFR17COfGL97TJ50cotfz/8cCiRxdhlDezLKearkqtSLq/TNH
         pReM30HiFe8dgaGNMZxrcGKzC4bVlowii4n7wEGm4wKNrJkUluxA0SMVNoSUy4LBYK/L
         vGqbqNah76iDUXz2bGTrh1pqb24g9OL5nE3XvLe5oTqM32lrI4UsZcAVQREGHJLhysEa
         OxzHCQbW+6SLXrOSDhnZJU0VBAoewXJqn8h6AseJ4tnLor0YAlJwEHDEtQHmzG2m8k03
         JH3uDpDpVvg2NmNiZZiCz8Z495pTx+Dj6qOwYYt2SLsfQ5eGHCQUAmMjcTDhS9vWip08
         PifA==
X-Gm-Message-State: AOAM531idVZrbgvuEMx0ylI+h/FS+LvXHw64wySFfK1hc0oZNa6hpzLL
        Knf+qxbNcoo8xcAetHv+S9zP0Qspb75ci/Uw
X-Google-Smtp-Source: ABdhPJwEVg9tcJsybX4mrwvJYB2+/Ty4StPAR6Uex6ml8eP9FngUmUZlf17M3TqhKMhm46pYSySXUA==
X-Received: by 2002:adf:b1da:: with SMTP id r26mr13479782wra.198.1611215104752;
        Wed, 20 Jan 2021 23:45:04 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 05/15] trace-cmd: Add role parameter to timestamp synchronization plugins
Date:   Thu, 21 Jan 2021 09:44:46 +0200
Message-Id: <20210121074456.157658-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
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

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h        | 10 ++++++++--
 lib/trace-cmd/include/trace-tsync-local.h      |  2 +-
 lib/trace-cmd/trace-timesync.c                 | 18 +++++++++++++++---
 tracecmd/trace-record.c                        |  3 ++-
 tracecmd/trace-tsync.c                         |  3 ++-
 5 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ff700e44..685abf13 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -419,6 +419,11 @@ enum{
 	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
 };
 
+enum tracecmd_time_sync_role {
+	TRACECMD_TIME_SYNC_ROLE_HOST	= (1 << 0),
+	TRACECMD_TIME_SYNC_ROLE_GUEST	= (1 << 1),
+};
+
 struct tracecmd_time_sync {
 	const char			*proto_name;
 	int				loop_interval;
@@ -430,8 +435,9 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock);
-const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock);
+int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
+const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock,
+					enum tracecmd_time_sync_role role);
 bool tsync_proto_is_supported(const char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 96ec89e9..a99725e2 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -26,7 +26,7 @@ struct clock_sync_context {
 	unsigned int			remote_port;
 };
 
-int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
+int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
 				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 0d46d294..def703f6 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -25,6 +25,7 @@
 struct tsync_proto {
 	struct tsync_proto *next;
 	char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
+	enum tracecmd_time_sync_role roles;
 	int accuracy;
 	int supported_clocks;
 
@@ -50,7 +51,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
 	return NULL;
 }
 
-int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
+int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
 				  int supported_clocks,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
@@ -66,6 +67,7 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
 		return -1;
 	strncpy(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH);
 	proto->accuracy = accuracy;
+	proto->roles = roles;
 	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
@@ -141,12 +143,14 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  *
  * @protos: list of tsync protocol names
  * @clock : trace clock
+ * @role : local time sync role
  *
  * Retuns pointer to a protocol name, that can be used with the peer, or NULL
  *	  in case there is no match with supported protocols.
  *	  The returned string MUST NOT be freed by the caller
  */
-const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock)
+const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock,
+				  enum tracecmd_time_sync_role role)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
@@ -160,6 +164,8 @@ const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, ch
 	pname = protos->names;
 	while (*pname) {
 		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (!(proto->roles & role))
+				continue;
 			if (proto->supported_clocks && clock_id &&
 			    !(proto->supported_clocks & clock_id))
 				continue;
@@ -186,12 +192,13 @@ const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, ch
  * @protos: return, allocated list of time sync protocol names,
  *	       supported by the peer. Must be freed by free()
  * @clock: selected trace clock
+ * @role: supported protocol role
  *
  * If completed successfully 0 is returned and allocated list of strings in @protos.
  * The last list entry is NULL. In case of an error, -1 is returned.
  * @protos must be freed with free()
  */
-int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock)
+int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role)
 {
 	struct tracecmd_tsync_protos *plist = NULL;
 	struct tsync_proto *proto;
@@ -202,6 +209,8 @@ int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const cha
 	if (clock)
 		clock_id =  tracecmd_clock_str2id(clock);
 	for (proto = tsync_proto_list; proto; proto = proto->next) {
+		if (!(proto->roles & role))
+			continue;
 		if (proto->supported_clocks && clock_id &&
 		    !(proto->supported_clocks & clock_id))
 			continue;
@@ -215,11 +224,14 @@ int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const cha
 		return -1;
 
 	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next) {
+		if (!(proto->roles & role))
+			continue;
 		if (proto->supported_clocks && clock_id &&
 		    !(proto->supported_clocks & clock_id))
 			continue;
 		plist->names[i++] = proto->proto_name;
 	}
+
 	*protos = plist;
 	return 0;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 51b8562b..3bcb2403 100644
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
index 55e9857f..ef20651b 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -223,7 +223,8 @@ const char *tracecmd_guest_tsync(struct tracecmd_tsync_protos *tsync_protos,
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos, clock);
+	proto = tracecmd_tsync_proto_select(tsync_protos, clock,
+					    TRACECMD_TIME_SYNC_ROLE_GUEST);
 	if (!proto)
 		return NULL;
 #ifdef VSOCK
-- 
2.29.2

