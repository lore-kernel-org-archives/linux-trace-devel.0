Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A971C63798
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B22A424655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Flvb0sj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgKQHqD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHqD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:03 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D21C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:03 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id j7so22131205wrp.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJcJgvYRSdG5VdnrgKcTUREPCtdXCjUeB7jITTZMCd4=;
        b=Flvb0sj4lQNk0zo31tJVky1lvXs6RLiJHMAO4CH4qQniCPsu5x5538NTPW0ukHi82Z
         fPpbOQHyC9/G6lTcK6qphhUcnQsN1kIOuWvPV6GhQpVRU5B0s01g/THrYmH4q1QXXMjl
         eNJBYWtXQSlaopqyX5Y9+K9YkEAp2e7Lc77ZbsdPDkkegFfzXDr8Yzydl5Pecr6HT8pL
         r0ITeRFZAbIZgwKg28nrO0TypSjotzItnq6b/W6jyPBPcoO9AocTIKBTPKWK+fE92Rii
         xh0n9oZmc6QeYLPm/i9b74H02lUsjsBB/7VtmuAvZXuaMtvo/X29Tjfyy+vjNVJuj74O
         NKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJcJgvYRSdG5VdnrgKcTUREPCtdXCjUeB7jITTZMCd4=;
        b=j2Opjn9rKEoYjWGncgBf9n968OvjmI1Dj1LZLOsb9113yBdIC8kmZJiLN0Frr+ckhR
         GBJuA0F1/EPxzv+2rYub03/IQXud6ISqmGKcx9KIImpKWUR6qFkSPx7/GW57H+E5g8oU
         khvhUbCx8y8dLnCd3dtErNN1RD23/Ro4YQyL2dt70lai+pglfBTboBkXnvtIf58U6Quw
         pR7AlFOOPdAA5zW6j2+KVaTys+LePLF4VEjfi7F5vGj6ejBMvdXJ/5LGhpzG8tOEicXm
         1m9o+dEDnw7w1s+oHKck2S2J9gpbGKQWr/04Ui3AnLN13dP19ROAtICOk2VwIUpNSFTP
         i3UQ==
X-Gm-Message-State: AOAM533IC8QHdsSMLyWW35q0trrnM3Qz0tfMpC6GkpGoijUNw/8CgbRb
        1fMDGkIu0ZTbJE7JQMtn79ilK7mHBb2fpShn
X-Google-Smtp-Source: ABdhPJzR2TzvMk9BH1xmcV48ZgUqAVvfwyVwO/1E1dNgj405yImShyCv7C1ivsLtt71/wGYL0TiUbw==
X-Received: by 2002:adf:f40a:: with SMTP id g10mr25030164wro.58.1605599161829;
        Mon, 16 Nov 2020 23:46:01 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/8] libtracefs: Change get name API to return constant string
Date:   Tue, 17 Nov 2020 09:45:51 +0200
Message-Id: <20201117074557.180602-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs_instance_get_name() API returns a pointer to internal
string. This string is not meant to be changed by the API callers,
that's why it should be constant.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      | 2 +-
 lib/tracefs/tracefs-instance.c | 2 +-
 tracecmd/trace-record.c        | 2 +-
 utest/tracefs-utest.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8ee7ba6e..1cf8de48 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -24,7 +24,7 @@ struct tracefs_instance *tracefs_instance_alloc(const char *name);
 void tracefs_instance_free(struct tracefs_instance *instance);
 int tracefs_instance_create(struct tracefs_instance *instance);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
-char *tracefs_instance_get_name(struct tracefs_instance *instance);
+const char *tracefs_instance_get_name(struct tracefs_instance *instance);
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 50e88534..e37d93d1 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -169,7 +169,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
  * Returns the name of the given @instance.
  * The returned string must *not* be freed.
  */
-char *tracefs_instance_get_name(struct tracefs_instance *instance)
+const char *tracefs_instance_get_name(struct tracefs_instance *instance)
 {
 	if (instance)
 		return instance->name;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 72a5c8c9..8cd44dd0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3861,7 +3861,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
-	char *name;
+	const char *name;
 
 	name = tracefs_instance_get_name(instance->tracefs);
 	if (!no_fifos) {
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1c146576..b5296963 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -180,7 +180,7 @@ static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
 	const char *name = get_rand_str();
-	char *inst_name = NULL;
+	const char *inst_name = NULL;
 	const char *tdir;
 	char *inst_file;
 	char *inst_dir;
-- 
2.28.0

