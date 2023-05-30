Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773A6C7EE23
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 06:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjE3GCj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 02:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjE3GCi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 02:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B53CD
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 23:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4031A62940
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 06:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EA0C433EF;
        Tue, 30 May 2023 06:02:35 +0000 (UTC)
Date:   Tue, 30 May 2023 02:02:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtracefs: Clarify the tracefs_synth_create() man page
Message-ID: <20230530020232.5ad0376c@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man page for tracefs_synth_create() and tracefs_synth_set_instance()
suggests that if a synthetic event is created in a specific instance, then
it can only be used by that instance. This is incorrect. Synthetic events
created anywhere are global, and can be used by all instances. Update the
man pages to explicitly express this.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth2.txt | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index d94fa7ce88a2..77cdd0199a58 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -46,11 +46,14 @@ as a field for both events to calculate the delta in nanoseconds, or use
 *TRACEFS_TIMESTAMP_USECS* as the compare fields for both events to calculate the
 delta in microseconds. This is used as the example below.
 
-*tracefs_synth_create*() creates the synthetic event in the system. By default, the synthetic
-events are created in the top trace instance and apply across all instances.
-The *tracefs_synth_set_instance()* API can be used to set a custom instance, where the synthetic
-event will be created. In that case the event operates only in that instance. A synthetic event
-must be created with *tracefs_synth_alloc*(3) before it can be created.
+*tracefs_synth_create*() creates the synthetic event in the system. By default,
+the histogram triggers are created in the top trace instance, as any synthetic
+event can be used globally across all instances. In case an application wants
+to keep the histogram triggers out of the top level instance, it can use
+*tracefs_synth_set_instance()* to have the histograms used for creating the
+synthetic event in an instance other than the top level.  A synthetic event
+descriptor must be created with *tracefs_synth_alloc*(3) before this can be
+used to create it on the system.
 
 *tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop the running of it in
 its instance (top by default), but if its running in another instance this may fail as busy.
@@ -77,9 +80,14 @@ then save the given _save_fields_ list. The fields will be stored in the histogr
 "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
 _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
-*tracefs_synth_set_instance()* Set the trace instance, where the synthetic event will be
-created. By default, the top instance is used. This API must be called before the call to
-*tracefs_synth_create()*, in order to use the new instance when creating the event.
+*tracefs_synth_set_instance()* Set the trace instance, where the histogram
+triggers that create the synthetic event will be created. By default, the top
+instance is used. This API must be called before the call to
+*tracefs_synth_create()*, in order to use the new instance when creating the
+event.  Note, that even if the synthetic event is created in an instance, it is
+still visible by all other instances including the top level. That is, other
+instances can enable the created synthetic event and have it traced in the
+buffers that belong to the instance that enabled it.
 
 RETURN VALUE
 ------------
-- 
2.39.2

