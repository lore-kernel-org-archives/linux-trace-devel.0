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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED4EC433C1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2716196C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 14:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhCVO3c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 10:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhCVO32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 10:29:28 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AF3C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 07:29:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id j3so19562744edp.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 07:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HujGx2QmQCsVQwa9Y+UhDqEh1aPh9K9EkrW8iHcW3A=;
        b=SvMVosFVscLhSrZGk8IRIudImIwWF4nJLTbF48vaIB0RVOM12jU0/UOpWU0AzbFIvK
         n++Jm8uA/5RG40lMsLbR9GhQ7C92LUR3V9mORg3pBeQ5iLvTkEJmA96r+Ij6KdXcdArS
         ou42ig8ivYSVWkWCmmhlDj+DBNUFt0AzJ5LppunMuWJqU+PTgxEIDOgrgJm6SemD0ef1
         bw2vnTLwFmh8vTl5t0ZNTaMb+jKFg95p0Ma16Mm0zP9V+YLtCBIE5ineIMx+1ZkwoO9d
         rMmaRnX1XiAI1Wuk6x4hal6b6f7Y70Cx7ocQfYnoY4uZ9p7L4kSpAc+nBPJpW2hC8tgi
         hbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/HujGx2QmQCsVQwa9Y+UhDqEh1aPh9K9EkrW8iHcW3A=;
        b=QUir9rYXjbQY6W9QYHD3xZkSRREu6IMXlZdAnnl66Gc5M72h0Y15HKKKFMIH7/o14f
         Uo+MmpgdLjTQ0goMdEiwiN9fdAcr5CxqJqVbW1z6IBB1YtF46L57rWsOyo0Hl+If86bG
         9zvY7SfjHV5thyI9LsRAe+Rh3wf+9uLbUKbZkdqa9lMOQO6nDYHvqZjq4WAF0U5M7QJT
         HD1JyAbCbf8fLVahUmKMfazZk3WMQluVEYRk2o/IwWh5LnEd3wl80KYtueG28DM2KsJ9
         GC7T0dq3YYgh8a/yrvtu0BJrTx1CxrbAEPYdZVq/pOkrsidItEHvIxAk5Bvvl9ninY1f
         k9Cg==
X-Gm-Message-State: AOAM531Un5lpXPuuf4YB52vhy1/bggC4eqCq23jwvzg7WsZTvEuZzl8X
        lWeWIQW9u9elf+zAjZTmbNQ=
X-Google-Smtp-Source: ABdhPJznsNtcHnA5kVqOUawnJG7KOpL4iipq50cUf8n1sZv1w/XGRF8ZU/Nf93sqA/qJJMuhfPc63Q==
X-Received: by 2002:a05:6402:3096:: with SMTP id de22mr26030711edb.141.1616423365975;
        Mon, 22 Mar 2021 07:29:25 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.22])
        by smtp.gmail.com with ESMTPSA id cf4sm11413789edb.19.2021.03.22.07.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 07:29:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Prefer using const pointer arguments
Date:   Mon, 22 Mar 2021 16:29:12 +0200
Message-Id: <20210322142912.26521-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All functions should receive const pointer arguments, except in the
cases when the argument object itself needs to be modified.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h      | 15 ++++++++-------
 src/tracefs-instance.c | 17 +++++++++--------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index f3eec62..e54f791 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -25,12 +25,13 @@ struct tracefs_instance *tracefs_instance_create(const char *name);
 struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
 						const char *name);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
-bool tracefs_instance_is_new(struct tracefs_instance *instance);
-const char *tracefs_instance_get_name(struct tracefs_instance *instance);
-const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);
+bool tracefs_instance_is_new(const struct tracefs_instance *instance);
+const char *tracefs_instance_get_name(const struct tracefs_instance *instance);
+const char *tracefs_instance_get_trace_dir(const struct tracefs_instance *instance);
 char *
-tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
-char *tracefs_instance_get_dir(struct tracefs_instance *instance);
+tracefs_instance_get_file(const struct tracefs_instance *instance,
+			  const char *file);
+char *tracefs_instance_get_dir(const struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
@@ -42,8 +43,8 @@ int tracefs_instance_file_open(struct tracefs_instance *instance,
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_instance_exists(const char *name);
-bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
-bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
+bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
+bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name);
 
 int tracefs_trace_is_on(struct tracefs_instance *instance);
 int tracefs_trace_on(struct tracefs_instance *instance);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 0df4e13..ba467a8 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -100,7 +100,7 @@ out:
  * Returns true, if the ftrace instance is newly created by the library or
  * false otherwise.
  */
-bool tracefs_instance_is_new(struct tracefs_instance *instance)
+bool tracefs_instance_is_new(const struct tracefs_instance *instance)
 {
 	if (instance && (instance->flags & FLAG_INSTANCE_NEWLY_CREATED))
 		return true;
@@ -229,7 +229,8 @@ int tracefs_instance_destroy(struct tracefs_instance *instance)
  * Must use tracefs_put_tracing_file() to free the returned string.
  */
 char *
-tracefs_instance_get_file(struct tracefs_instance *instance, const char *file)
+tracefs_instance_get_file(const struct tracefs_instance *instance,
+			  const char *file)
 {
 	char *path = NULL;
 	int ret;
@@ -255,7 +256,7 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file)
  *
  * Must use tracefs_put_tracing_file() to free the returned string.
  */
-char *tracefs_instance_get_dir(struct tracefs_instance *instance)
+char *tracefs_instance_get_dir(const struct tracefs_instance *instance)
 {
 	char *path = NULL;
 	int ret;
@@ -283,7 +284,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
  * Returns the name of the given @instance.
  * The returned string must *not* be freed.
  */
-const char *tracefs_instance_get_name(struct tracefs_instance *instance)
+const char *tracefs_instance_get_name(const struct tracefs_instance *instance)
 {
 	if (instance)
 		return instance->name;
@@ -297,7 +298,7 @@ const char *tracefs_instance_get_name(struct tracefs_instance *instance)
  * Returns the top trace directory where the given @instance is configured.
  * The returned string must *not* be freed.
  */
-const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance)
+const char *tracefs_instance_get_trace_dir(const struct tracefs_instance *instance)
 {
 	if (instance)
 		return instance->trace_dir;
@@ -436,7 +437,7 @@ int tracefs_instance_file_open(struct tracefs_instance *instance,
 }
 
 static bool check_file_exists(struct tracefs_instance *instance,
-			     char *name, bool dir)
+			     const char *name, bool dir)
 {
 	char file[PATH_MAX];
 	struct stat st;
@@ -482,7 +483,7 @@ bool tracefs_instance_exists(const char *name)
  *
  * If a directory with the given name exists, false is returned.
  */
-bool tracefs_file_exists(struct tracefs_instance *instance, char *name)
+bool tracefs_file_exists(struct tracefs_instance *instance, const char *name)
 {
 	return check_file_exists(instance, name, false);
 }
@@ -494,7 +495,7 @@ bool tracefs_file_exists(struct tracefs_instance *instance, char *name)
  *
  * Returns true if the directory exists, false otherwise
  */
-bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
+bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name)
 {
 	return check_file_exists(instance, name, true);
 }
-- 
2.25.1

