Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0F2C76196
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjC1PEr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:47 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72CFE395
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ew6so50924461edb.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4fDd47LLhqTsrT5hSDb35SyGZAaCyFCDz6PlTpGm68=;
        b=muPJeQ8uWBizUNkhhAkdqEwg8giRh8EiCvR2pnI+zvuKTAgxa2AdE2lWmWFicfyY2c
         YoGVk6zeM6INYtpKwtusngBG/eFaa5Ua3u29KQ9dgduql+5f3/dnCxVCN/6wvjNefMuD
         Rm3tvYRoYHtjv4G01Ill4RkKUbeTZC1Wmu6dxillhMVoCr+9z0Ll12I7BnEROVx8tQjs
         BiAO5O448ce0Z66FtG7cGyjH6oAYfHa1PJAUZ+20r6bXwrM4c2q3lZaeKWuGHOi8KxiU
         q4WYw1AoATAjcPR0v8N3uJVbxfN95+usuBZb/0T8LuSr37TOCaWW++NB54HBMTPWlwnv
         XaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4fDd47LLhqTsrT5hSDb35SyGZAaCyFCDz6PlTpGm68=;
        b=0S+M85jMb4eXgtN0W6ubZbPY3tKj058cdtURzEJ8DpWXuPXbZ1GigVwRkTIKLFNUgU
         6AbkX0wLpJdOIfjeeKfADAt0Ov+nh4I0YkeA7wt+NrHHU797orQusc/UORf7Vt3qqBn0
         DEvhY1wvmIs9Qpp184Gyw4vtrbscTaoj8qQwewJsyuD4Jy3CO0+X8dgvdHnaSq7iGG9S
         5z3gBNZ5pGKvNlRdOcTrGg7cQQh7Zs6crKoD/TkbLwdRaQRICB/KZBoT9qVP5en232Zm
         w7OEt5PFqkfLM+Dv6b0eYAusL1FVObliAaXBDiUgp4LIJV6Bqr8iLXJVVL7MrNr0TtqM
         jBOw==
X-Gm-Message-State: AAQBX9cc92bYwDYkTIvaqHzwFc8Ge4DeygqBc9Rcq5EgsLX4IUPy+SGv
        rhkCLYU0hZ9iA5hVO7TpOlv2axhFMT8=
X-Google-Smtp-Source: AKy350bcIK2lXgLJbXyGBaNNDPRrAufB7uJ8CwURawYFtmpHBHHe4Eh3g8YNRVmBru+khcfvISAtmw==
X-Received: by 2002:a05:6402:10c1:b0:502:3376:46bc with SMTP id p1-20020a05640210c100b00502337646bcmr11002313edu.8.1680015804511;
        Tue, 28 Mar 2023 08:03:24 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id q5-20020a50cc85000000b005024aff3bb5sm1440100edi.80.2023.03.28.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Documentation for tracefs_synth_set_instance
Date:   Tue, 28 Mar 2023 18:03:21 +0300
Message-Id: <20230328150321.34808-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328150321.34808-1-tz.stoyanov@gmail.com>
References: <20230328150321.34808-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly introduced API tracefs_synth_set_instance() should be
described in the man pages of the tracefs library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-synth2.txt | 15 +++++++++++----
 Documentation/libtracefs.txt        |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 7e8e6cc..d94fa7c 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_complete,
-tracefs_synth_trace, tracefs_synth_snapshot, tracefs_synth_save
+tracefs_synth_trace, tracefs_synth_snapshot, tracefs_synth_save,tracefs_synth_set_instance,
 - Creation of synthetic events
 
 SYNOPSIS
@@ -17,6 +17,7 @@ int *tracefs_synth_create*(struct tracefs_synth pass:[*]_synth_);
 int *tracefs_synth_destroy*(struct tracefs_synth pass:[*]_synth_);
 bool *tracefs_synth_complete*(struct tracefs_synth pass:[*]_synth_);
 
+int *tracefs_synth_set_instance*(struct tracefs_synth pass:[*]_synth_, struct tracefs_instance pass:[*]_instance_);
 int *tracefs_synth_trace*(struct tracefs_synth pass:[*]_synth_,
 			enum tracefs_synth_handler _type_, const char pass:[*]_var_);
 int *tracefs_synth_snapshot*(struct tracefs_synth pass:[*]_synth_,
@@ -45,9 +46,11 @@ as a field for both events to calculate the delta in nanoseconds, or use
 *TRACEFS_TIMESTAMP_USECS* as the compare fields for both events to calculate the
 delta in microseconds. This is used as the example below.
 
-*tracefs_synth_create*() creates the synthetic event in the system. The synthetic events apply
-across all instances. A synthetic event must be created with *tracefs_synth_alloc*(3) before
-it can be created.
+*tracefs_synth_create*() creates the synthetic event in the system. By default, the synthetic
+events are created in the top trace instance and apply across all instances.
+The *tracefs_synth_set_instance()* API can be used to set a custom instance, where the synthetic
+event will be created. In that case the event operates only in that instance. A synthetic event
+must be created with *tracefs_synth_alloc*(3) before it can be created.
 
 *tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop the running of it in
 its instance (top by default), but if its running in another instance this may fail as busy.
@@ -74,6 +77,10 @@ then save the given _save_fields_ list. The fields will be stored in the histogr
 "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
 _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
+*tracefs_synth_set_instance()* Set the trace instance, where the synthetic event will be
+created. By default, the top instance is used. This API must be called before the call to
+*tracefs_synth_create()*, in order to use the new instance when creating the event.
+
 RETURN VALUE
 ------------
 All functions return zero on success or -1 on error.
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index c3f448d..daf044f 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -213,6 +213,7 @@ Synthetic events:
 	void *tracefs_synth_free*(struct tracefs_synth pass:[*]_synth_);
 	int *tracefs_synth_create*(struct tracefs_synth pass:[*]_synth_);
 	int *tracefs_synth_destroy*(struct tracefs_synth pass:[*]_synth_);
+	int *tracefs_synth_set_instance*(struct tracefs_synth pass:[*]_synth_, struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_synth_echo_cmd*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
 	bool *tracefs_synth_complete*(struct tracefs_synth pass:[*]_synth_);
 	struct tracefs_hist pass:[*]*tracefs_synth_get_start_hist*(struct tracefs_synth pass:[*]_synth_);
-- 
2.39.2

