Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF379C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 763096143A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhD1Nsf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbhD1Nse (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10290C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so6355578edb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3r8eNFkztcMlCX8qzMWGg+VALgmQ4KRwk/KbIF3CT6A=;
        b=shs+gEzBtaWmM21h8xFh8RKT8Bao192VPcWUkKSJPWKOZKLfSeSVG8YNzWjXqDJ+4L
         d61J5/lIUzdtFkV5+dQVAL6ONK6HuUs820D6Euq3yaWsf+SEF47jG4G9/YZXywwWU584
         lK0wOoeUAwrIJ8TiM/AmWiDp9dsomW6JatpaCk4xbMpiqVuN3PG3pwp5BMLt/iEzcjI/
         agnDGXtDSQKmmuCMis6rTORDFwEhLJnDmO/f1E3xd43FCghXPEaHdeOi9qt1UbqJI8sf
         vMiiZ9j13aFDXOrUmcCubaltSvTiEXkVXhqiUgojzSb5sJQT7jVsc9+01MAEGrMjbrxf
         JaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3r8eNFkztcMlCX8qzMWGg+VALgmQ4KRwk/KbIF3CT6A=;
        b=r1MPxSmyo+4fwfR2bGbae0pdivMLxci7RYMSAHdB1WlFUFRbthuxPVJ8mrejUlkmDI
         /LgJ2p4fCB395vWvJnkFoMSYkkf9rQ5FtxS+r1EIsxK53tGymb/qskLj4ADvOv4Q2d9f
         84llPliYzqQGWFLlXqJCPvKYjusKvz66UgvfnV1DUJz3ODlguyJ5U7MmZFignZPPzSPP
         fZhKeWhfTUYDmkCc0MYTZDUEyc+QT0x2/RC72OUcuVZhFFCRVhnvIgOgwbMT0nJEknAu
         Me1zrQkNOVgrzuPhdwsazjni924rMtDNJwERF3jir990dJhgHNiaWk3ClGjR8rUSJgz1
         Y3FQ==
X-Gm-Message-State: AOAM533GJnfX5pCcVyyCu6+o7h2/BRdWJqsVGQjWavS8RPn98Wtlcb5h
        FGvfCpWw25P+yhLdNXPIca6Q4mu7taA=
X-Google-Smtp-Source: ABdhPJyZ5gMEL7Ppt3ty4ZQvfL5eWbJ2m7Ch3qZyenT8QhxDuSY+sNYGcf8at6q2l4JvDwm1HOq1Ag==
X-Received: by 2002:aa7:d594:: with SMTP id r20mr2988311edq.242.1619617667681;
        Wed, 28 Apr 2021 06:47:47 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:47 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 9/9] kernel-shark: Hide all plugin internals
Date:   Wed, 28 Apr 2021 16:47:30 +0300
Message-Id: <20210428134730.187533-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Nothing except the plugin's interface must be visible outside.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/plugins/MissedEvents.cpp | 2 +-
 src/plugins/SchedEvents.cpp  | 5 +++--
 src/plugins/sched_events.c   | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/plugins/MissedEvents.cpp b/src/plugins/MissedEvents.cpp
index cf0ed34..fdd47c8 100644
--- a/src/plugins/MissedEvents.cpp
+++ b/src/plugins/MissedEvents.cpp
@@ -89,7 +89,7 @@ static PlotObject *makeShape(std::vector<const Graph *> graph,
  * @param val: Process or CPU Id value.
  * @param draw_action: Draw action identifier.
  */
-void draw_missed_events(kshark_cpp_argv *argv_c,
+__hidden void draw_missed_events(kshark_cpp_argv *argv_c,
 			int sd, int val, int draw_action)
 {
 	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
index a81182e..b73e45f 100644
--- a/src/plugins/SchedEvents.cpp
+++ b/src/plugins/SchedEvents.cpp
@@ -30,7 +30,7 @@ static KsMainWindow *ks_ptr;
  * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
  * itself) such that the plugin can manipulate the GUI.
  */
-void *plugin_set_gui_ptr(void *gui_ptr)
+__hidden void *plugin_set_gui_ptr(void *gui_ptr)
 {
 	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
 	return nullptr;
@@ -152,7 +152,8 @@ static void secondPass(plugin_sched_context *plugin_ctx)
  * @param pid: Process Id.
  * @param draw_action: Draw action identifier.
  */
-void plugin_draw(kshark_cpp_argv *argv_c, int sd, int pid, int draw_action)
+__hidden void plugin_draw(kshark_cpp_argv *argv_c,
+			  int sd, int pid, int draw_action)
 {
 	plugin_sched_context *plugin_ctx;
 
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 64dff8d..659ecc3 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -47,7 +47,7 @@ static void plugin_sched_set_pid(ks_num_field_t *field,
  *
  * @param field: Input location for the data field.
  */
-int plugin_sched_get_pid(ks_num_field_t field)
+__hidden int plugin_sched_get_pid(ks_num_field_t field)
 {
 	return field & PID_MASK;
 }
@@ -67,7 +67,7 @@ static void plugin_sched_set_prev_state(ks_num_field_t *field,
  *
  * @param field: Input location for the data field.
  */
-int plugin_sched_get_prev_state(ks_num_field_t field)
+__hidden int plugin_sched_get_prev_state(ks_num_field_t field)
 {
 	tep_num_field_t mask = PREV_STATE_MASK << PREV_STATE_SHIFT;
 	return (field & mask) >> PREV_STATE_SHIFT;
-- 
2.27.0

