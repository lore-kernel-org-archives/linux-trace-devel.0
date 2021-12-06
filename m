Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8042C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 15:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349535AbhLFPTY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 10:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358323AbhLFPQe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 10:16:34 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CF2C08EACD
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 07:09:12 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q3so23076131wru.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Dec 2021 07:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R+nEydAK1dzYxRBMivuniekVKeQIralV5GkyLM6IaIA=;
        b=B7fWPxS1H0SGSL0pyJ4S5oX6yCIGkxkrQPxdZwxrqfn/l5yatsu8ofrWzaC5gnMonx
         7cdLYgEVwvGPPeX/Ut+185EzAmLQEywA1ufQ6/z6MA76+Xh1RLC3DmZzqYOSCXhgFxgl
         7YWd55PEQa/UFm6HHRBuzGHxuTPPyoZ+zS1n7yikphPfXEWQY+7Nn/Eb3oqh9UuomrYD
         WX4y/dKoS0Dz06lJLj9rsoSCtNCEFVKllGHuyTCvCGq0JLTiojfLx4oR6/kSJUr71RIq
         RBj7lIloJsuN2g0jTohEBjVXMqvztgw/qCAaImW1QV8FdHlgV8zpq1ucAcZsJaeXPmZ0
         XWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R+nEydAK1dzYxRBMivuniekVKeQIralV5GkyLM6IaIA=;
        b=KRnZrMHNT8WdxQcJQIXu/wOe3VTC68T6xejVzaExcAOgws4XvSAachNJ6weqeeeST9
         DbRtu9vMjHS8gNAax+VKJtExv/MnGXPfHGYb0oULdAOa8zemi6cB+vZzw2fuh7hv3OxV
         zMb5k+ErrPiCW2uJnsOY2ry9U/Q3D/xg9GFsWrsTE+bWcFmWxFuaykhz6pYaigKm/Bky
         8A98Zd67E4IiXdJptLAHS0LQjCwNxofAkueoG9LMgKhOAxOjYsyPNrsfmZIDdWcoy6hn
         GHtlhFXZZ3tJH7KnBr8ETBmyViMYErYdYG15DGvmOpd+J0AvPJ4tJVYazq3hQPHqQeEE
         jE/Q==
X-Gm-Message-State: AOAM533yvFxtotnP1CP8LeB6MgKv8ZOjVQ0yOKcGpLAyJBRS7n69Sywh
        uhtx5Fz3KmXoKsEgEnZ/C5Oxw8WwAP8=
X-Google-Smtp-Source: ABdhPJyu4zI33tNMFnYxgSUN9jwJyKAXC57V2vJybM6jZUlXLHMIzm8hfNBzmGJW4xbWC35sLfKgCQ==
X-Received: by 2002:a5d:456e:: with SMTP id a14mr43039388wrc.256.1638803350451;
        Mon, 06 Dec 2021 07:09:10 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d6sm11782668wrn.53.2021.12.06.07.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:09:10 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] libtracefs: Add new API for getting synth event name WiP
Date:   Mon,  6 Dec 2021 17:08:55 +0200
Message-Id: <20211206150855.361202-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206150855.361202-1-y.karadz@gmail.com>
References: <20211206150855.361202-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-synth2.txt |  8 ++++++--
 include/tracefs.h                   |  1 +
 src/tracefs-hist.c                  | 11 +++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 1cb07c8..2439a54 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -3,8 +3,9 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd,tracefs_synth_complete,
-tracefs_synth_get_start_hist,tracefs_synth_trace,tracefs_synth_snapshot - Creation of synthetic events
+tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
+tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
+tracefs_synth_get_name - Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -25,6 +26,7 @@ int tracefs_synth_snapshot(struct tracefs_synth pass:[*]synth,
 int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
 		       enum tracefs_synth_handler type, const char pass:[*]var,
 		       char pass:[**]save_fields);
+tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);
 --
 
 DESCRIPTION
@@ -87,6 +89,8 @@ then saven the given _save_fields_ list. The fields will be stored in the histog
 "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
 _var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
+*tracefs_synth_get_name*() get the name of the synthetic event.
+
 RETURN VALUE
 ------------
 Returns zero on success or -1 on error.
diff --git a/include/tracefs.h b/include/tracefs.h
index 7c03086..804d738 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -505,6 +505,7 @@ enum tracefs_synth_handler {
 	TRACEFS_SYNTH_HANDLE_CHANGE,
 };
 
+const char *tracefs_synth_get_name(struct tracefs_synth *synth);
 struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
 					  const char *name,
 					  const char *start_system,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 837d4e1..41c88d1 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -736,6 +736,17 @@ struct tracefs_synth {
 	int			arg_cnt;
 };
 
+ /*
+ * tracefs_synth_get_name - get the name of the synthetic event
+ * @synth: The synthetic event to get the name for
+ *
+ * Returns name string on succes or NULL on error.
+ */
+const char *tracefs_synth_get_name(struct tracefs_synth *synth)
+{
+	return synth ? synth->name : NULL;
+}
+
 static void action_free(struct action *action)
 {
 	free(action->handle_field);
-- 
2.32.0

