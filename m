Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA37C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 23:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbiAQXWQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 18:22:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59198 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiAQXWQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 18:22:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B20B81141
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 23:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5361EC36AF3;
        Mon, 17 Jan 2022 23:22:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n9bKG-006fZ0-Ao;
        Mon, 17 Jan 2022 18:22:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs/Documentation: Referencing commands should be bold not underlined
Date:   Mon, 17 Jan 2022 18:22:10 -0500
Message-Id: <20220117232210.1589656-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220117232210.1589656-1-rostedt@goodmis.org>
References: <20220117232210.1589656-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When referencing other commands "trace-cmd(3)", the command name should be
bold and not underlined, and the "(3)" should be normal text.

Update all the man pages to use this format. This mostly affects the "SEE
ALSO" section.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/libtracefs-dynevents.txt        |  6 +-
 Documentation/libtracefs-eprobes.txt          |  6 +-
 Documentation/libtracefs-error.txt            |  6 +-
 Documentation/libtracefs-events-tep.txt       |  8 +--
 Documentation/libtracefs-events.txt           |  6 +-
 Documentation/libtracefs-files.txt            |  6 +-
 Documentation/libtracefs-filter.txt           | 28 ++++-----
 Documentation/libtracefs-function-filter.txt  |  6 +-
 Documentation/libtracefs-hist-cont.txt        | 28 ++++-----
 Documentation/libtracefs-hist-mod.txt         | 12 ++--
 Documentation/libtracefs-hist.txt             | 12 ++--
 .../libtracefs-instances-affinity.txt         |  8 +--
 .../libtracefs-instances-file-manip.txt       |  6 +-
 Documentation/libtracefs-instances-files.txt  |  6 +-
 Documentation/libtracefs-instances-manage.txt |  6 +-
 Documentation/libtracefs-instances-utils.txt  |  6 +-
 Documentation/libtracefs-kprobes.txt          |  6 +-
 Documentation/libtracefs-log.txt              |  6 +-
 Documentation/libtracefs-marker.txt           |  6 +-
 Documentation/libtracefs-marker_raw.txt       |  6 +-
 Documentation/libtracefs-option-get.txt       |  6 +-
 Documentation/libtracefs-option-misc.txt      |  6 +-
 Documentation/libtracefs-options.txt          |  6 +-
 Documentation/libtracefs-sql.txt              | 52 ++++++++--------
 Documentation/libtracefs-stream.txt           |  6 +-
 Documentation/libtracefs-synth-info.txt       | 56 ++++++++---------
 Documentation/libtracefs-synth.txt            | 62 +++++++++----------
 Documentation/libtracefs-synth2.txt           | 60 +++++++++---------
 Documentation/libtracefs-traceon.txt          |  6 +-
 Documentation/libtracefs-tracer.txt           |  6 +-
 Documentation/libtracefs-utils.txt            |  6 +-
 Documentation/libtracefs.txt                  |  4 +-
 32 files changed, 228 insertions(+), 228 deletions(-)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index bec31f10c904..b8cb8d40bf7a 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -253,9 +253,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-eprobes.txt b/Documentation/libtracefs-eprobes.txt
index 4155544c174a..a96ad1b81783 100644
--- a/Documentation/libtracefs-eprobes.txt
+++ b/Documentation/libtracefs-eprobes.txt
@@ -157,9 +157,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-error.txt b/Documentation/libtracefs-error.txt
index 60e755421eaa..a45332dc742e 100644
--- a/Documentation/libtracefs-error.txt
+++ b/Documentation/libtracefs-error.txt
@@ -108,9 +108,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
index af5f1d63db6f..22d3dd5fdfd0 100644
--- a/Documentation/libtracefs-events-tep.txt
+++ b/Documentation/libtracefs-events-tep.txt
@@ -59,7 +59,7 @@ RETURN VALUE
 ------------
 The *tracefs_local_events()* and *tracefs_local_events_system()* functions
 return pointer to allocated and initialized _tep_ handler, or NULL in
-case of an error. The returned _tep_ handler must be freed with *tep_free(3)*.
+case of an error. The returned _tep_ handler must be freed with *tep_free*(3).
 
 The *tracefs_fill_local_events()* function returns -1 in case of an error or
 0 otherwise.
@@ -119,9 +119,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index eabce96404d3..a3d7a11acf4b 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -160,9 +160,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index 00f12c37611e..13e251ddd465 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -73,9 +73,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 0bb88e2a6df4..501f093134df 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -304,20 +304,20 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_alloc(3)_,
-_tracefs_hist_alloc_2d(3)_,
-_tracefs_hist_alloc_nd(3)_,
-_tracefs_hist_free(3)_,
-_tracefs_hist_add_key(3)_,
-_tracefs_hist_add_value(3)_,
-_tracefs_hist_add_name(3)_,
-_tracefs_hist_start(3)_,
-_tracefs_hist_destory(3)_,
-_tracefs_hist_add_sort_key(3)_,
-_tracefs_hist_sort_key_direction(3)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 1a77d778bfab..d12f61406448 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -208,9 +208,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index b32a2cc9165e..651aa0efe1f7 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -180,20 +180,20 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_alloc(3)_,
-_tracefs_hist_alloc_2d(3)_,
-_tracefs_hist_alloc_nd(3)_,
-_tracefs_hist_free(3)_,
-_tracefs_hist_add_key(3)_,
-_tracefs_hist_add_value(3)_,
-_tracefs_hist_add_name(3)_,
-_tracefs_hist_start(3)_,
-_tracefs_hist_destory(3)_,
-_tracefs_hist_add_sort_key(3)_,
-_tracefs_hist_sort_key_direction(3)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-hist-mod.txt b/Documentation/libtracefs-hist-mod.txt
index 732ae2b62e88..1f4587b50903 100644
--- a/Documentation/libtracefs-hist-mod.txt
+++ b/Documentation/libtracefs-hist-mod.txt
@@ -507,12 +507,12 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_pause(3)_,
-_tracefs_hist_continue(3)_,
-_tracefs_hist_reset(3)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_pause*(3),
+*tracefs_hist_continue*(3),
+*tracefs_hist_reset*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 9a86df52923a..858782b70dc2 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -459,12 +459,12 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_pause(3)_,
-_tracefs_hist_continue(3)_,
-_tracefs_hist_reset(3)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_pause*(3),
+*tracefs_hist_continue*(3),
+*tracefs_hist_reset*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index f3e16d972812..c5fa2d8b820c 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -35,7 +35,7 @@ The numbers do not need to be in order except for ranges, where the second numbe
 must be equal to or greater than the first.
 
 The *tracefs_instance_set_affinity_set()* function takes a CPU set defined by
-*CPU_SET(3)*. The size of the set defined by _set_size_ is the size in bytes of
+*CPU_SET*(3). The size of the set defined by _set_size_ is the size in bytes of
 _set_. If _set_ is NULL then all the CPUs on the system will be set, and _set_size_
 is ignored.
 
@@ -140,9 +140,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-instances-file-manip.txt b/Documentation/libtracefs-instances-file-manip.txt
index 369059482a56..8c04240523d3 100644
--- a/Documentation/libtracefs-instances-file-manip.txt
+++ b/Documentation/libtracefs-instances-file-manip.txt
@@ -170,9 +170,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index c289c82bc4e8..e2985578a5a5 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -144,9 +144,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 2b0b662f7730..31e77a39c594 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -109,9 +109,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index 8a2b6149073f..a79cc3447d80 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -98,9 +98,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index e488f9a151b8..593ef9ee11fb 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -243,9 +243,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-log.txt b/Documentation/libtracefs-log.txt
index 7b562c77d11d..4b72df115e50 100644
--- a/Documentation/libtracefs-log.txt
+++ b/Documentation/libtracefs-log.txt
@@ -47,9 +47,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-marker.txt b/Documentation/libtracefs-marker.txt
index fdab4a46030f..adc5419c44dc 100644
--- a/Documentation/libtracefs-marker.txt
+++ b/Documentation/libtracefs-marker.txt
@@ -86,9 +86,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
 Documentation/trace/ftrace.rst from the Linux kernel tree
 
 AUTHOR
diff --git a/Documentation/libtracefs-marker_raw.txt b/Documentation/libtracefs-marker_raw.txt
index e4ebadc2b655..9682f2088592 100644
--- a/Documentation/libtracefs-marker_raw.txt
+++ b/Documentation/libtracefs-marker_raw.txt
@@ -72,9 +72,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
 Documentation/trace/ftrace.rst from the Linux kernel tree
 
 AUTHOR
diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index 815e77f84505..dce5afab4894 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -105,9 +105,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-option-misc.txt b/Documentation/libtracefs-option-misc.txt
index 552aaed56ce3..c690bfdf503b 100644
--- a/Documentation/libtracefs-option-misc.txt
+++ b/Documentation/libtracefs-option-misc.txt
@@ -71,9 +71,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-options.txt b/Documentation/libtracefs-options.txt
index b8f0edff52b4..2c720f2fc220 100644
--- a/Documentation/libtracefs-options.txt
+++ b/Documentation/libtracefs-options.txt
@@ -129,9 +129,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
 _Documentation/trace/ftrace.rst_ from the Linux kernel tree.
 
 AUTHOR
diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index b7ddbb206b2a..ba4271ee99bb 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -565,32 +565,32 @@ FILES
 
 SEE ALSO
 --------
-_sqlhist(1)_,
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_synth_init(3)_,
-_tracefs_synth_add_match_field(3)_,
-_tracefs_synth_add_compare_field(3)_,
-_tracefs_synth_add_start_field(3)_,
-_tracefs_synth_add_end_field(3)_,
-_tracefs_synth_append_start_filter(3)_,
-_tracefs_synth_append_end_filter(3)_,
-_tracefs_synth_create(3)_,
-_tracefs_synth_destroy(3)_,
-_tracefs_synth_free(3)_,
-_tracefs_synth_echo_cmd(3)_,
-_tracefs_hist_alloc(3)_,
-_tracefs_hist_alloc_2d(3)_,
-_tracefs_hist_alloc_nd(3)_,
-_tracefs_hist_free(3)_,
-_tracefs_hist_add_key(3)_,
-_tracefs_hist_add_value(3)_,
-_tracefs_hist_add_name(3)_,
-_tracefs_hist_start(3)_,
-_tracefs_hist_destory(3)_,
-_tracefs_hist_add_sort_key(3)_,
-_tracefs_hist_sort_key_direction(3)_
+*sqlhist*(1),
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_synth_init*(3),
+*tracefs_synth_add_match_field*(3),
+*tracefs_synth_add_compare_field*(3),
+*tracefs_synth_add_start_field*(3),
+*tracefs_synth_add_end_field*(3),
+*tracefs_synth_append_start_filter*(3),
+*tracefs_synth_append_end_filter*(3),
+*tracefs_synth_create*(3),
+*tracefs_synth_destroy*(3),
+*tracefs_synth_free*(3),
+*tracefs_synth_echo_cmd*(3),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index d8c61c6b2993..8008be810a33 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -96,9 +96,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
 Documentation/trace/ftrace.rst from the Linux kernel tree
 
 AUTHOR
diff --git a/Documentation/libtracefs-synth-info.txt b/Documentation/libtracefs-synth-info.txt
index 1bfee20608d3..6ee0320b61a5 100644
--- a/Documentation/libtracefs-synth-info.txt
+++ b/Documentation/libtracefs-synth-info.txt
@@ -243,34 +243,34 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_alloc(3)_,
-_tracefs_hist_alloc_2d(3)_,
-_tracefs_hist_alloc_nd(3)_,
-_tracefs_hist_free(3)_,
-_tracefs_hist_add_key(3)_,
-_tracefs_hist_add_value(3)_,
-_tracefs_hist_add_name(3)_,
-_tracefs_hist_start(3)_,
-_tracefs_hist_destory(3)_,
-_tracefs_hist_add_sort_key(3)_,
-_tracefs_hist_sort_key_direction(3)_
-_tracefs_synth_alloc(3)_
-_tracefs_synth_add_match_field(3)_
-_tracefs_synth_add_compare_field(3)_
-_tracefs_synth_add_start_field(3)_
-_tracefs_synth_add_end_field(3)_
-_tracefs_synth_append_start_filter(3)_
-_tracefs_synth_append_end_filter(3)_
-_tracefs_synth_free(3)_
-_tracefs_synth_create(3)_
-_tracefs_synth_destroy(3)_
-_tracefs_synth_complete(3)_
-_tracefs_synth_trace(3)_
-_tracefs_synth_snapshot(3)_
-_tracefs_synth_save(3)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3),
+*tracefs_synth_alloc*(3),
+*tracefs_synth_add_match_field*(3),
+*tracefs_synth_add_compare_field*(3),
+*tracefs_synth_add_start_field*(3),
+*tracefs_synth_add_end_field*(3),
+*tracefs_synth_append_start_filter*(3),
+*tracefs_synth_append_end_filter*(3),
+*tracefs_synth_free*(3),
+*tracefs_synth_create*(3),
+*tracefs_synth_destroy*(3),
+*tracefs_synth_complete*(3),
+*tracefs_synth_trace*(3),
+*tracefs_synth_snapshot*(3),
+*tracefs_synth_save*(3),
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index e847d6d3e9d7..c57725d5ebaf 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -310,37 +310,37 @@ FILES
 
 SEE ALSO
 --------
-_tracefs_synth_create_(3),
-_tracefs_synth_destroy_(3),
-_tracfes_synth_echo_cmd(3),
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_alloc(3)_,
-_tracefs_hist_alloc_2d(3)_,
-_tracefs_hist_alloc_nd(3)_,
-_tracefs_hist_free(3)_,
-_tracefs_hist_add_key(3)_,
-_tracefs_hist_add_value(3)_,
-_tracefs_hist_add_name(3)_,
-_tracefs_hist_start(3)_,
-_tracefs_hist_destory(3)_,
-_tracefs_hist_add_sort_key(3)_,
-_tracefs_hist_sort_key_direction(3)_
-_tracefs_synth_create(3)_
-_tracefs_synth_destroy(3)_
-_tracefs_synth_complete(3)_
-_tracefs_synth_trace(3)_
-_tracefs_synth_snapshot(3)_
-_tracefs_synth_save(3)_
-_tracefs_synth_echo_cmd(3)_
-_tracefs_synth_get_start_hist(3)_
-_tracefs_synth_get_name(3)_
-_tracefs_synth_raw_fmt(3)_
-_tracefs_synth_show_event(3)_
-_tracefs_synth_show_start_hist(3)_
-_tracefs_synth_show_end_hist(3)_
-_tracefs_synth_get_event(3)_
+*tracefs_synth_create*(3),
+*tracefs_synth_destroy*(3),
+*tracfes_synth_echo_cmd*(3),
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3),
+*tracefs_synth_create*(3),
+*tracefs_synth_destroy*(3),
+*tracefs_synth_complete*(3),
+*tracefs_synth_trace*(3),
+*tracefs_synth_snapshot*(3),
+*tracefs_synth_save*(3),
+*tracefs_synth_echo_cmd*(3),
+*tracefs_synth_get_start_hist*(3),
+*tracefs_synth_get_name*(3),
+*tracefs_synth_raw_fmt*(3),
+*tracefs_synth_show_event*(3),
+*tracefs_synth_show_start_hist*(3),
+*tracefs_synth_show_end_hist*(3),
+*tracefs_synth_get_event*(3),
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index c7da04872668..7e8e6cc84882 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -224,36 +224,36 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_,
-_tracefs_hist_alloc(3)_,
-_tracefs_hist_alloc_2d(3)_,
-_tracefs_hist_alloc_nd(3)_,
-_tracefs_hist_free(3)_,
-_tracefs_hist_add_key(3)_,
-_tracefs_hist_add_value(3)_,
-_tracefs_hist_add_name(3)_,
-_tracefs_hist_start(3)_,
-_tracefs_hist_destory(3)_,
-_tracefs_hist_add_sort_key(3)_,
-_tracefs_hist_sort_key_direction(3)_
-_tracefs_synth_alloc(3)_
-_tracefs_synth_add_match_field(3)_
-_tracefs_synth_add_compare_field(3)_
-_tracefs_synth_add_start_field(3)_
-_tracefs_synth_add_end_field(3)_
-_tracefs_synth_append_start_filter(3)_
-_tracefs_synth_append_end_filter(3)_
-_tracefs_synth_free(3)_
-_tracefs_synth_echo_cmd(3)_
-_tracefs_synth_get_start_hist(3)_
-_tracefs_synth_get_name(3)_
-_tracefs_synth_raw_fmt(3)_
-_tracefs_synth_show_event(3)_
-_tracefs_synth_show_start_hist(3)_
-_tracefs_synth_show_end_hist(3)_
-_tracefs_synth_get_event(3)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3),
+*tracefs_synth_alloc*(3),
+*tracefs_synth_add_match_field*(3),
+*tracefs_synth_add_compare_field*(3),
+*tracefs_synth_add_start_field*(3),
+*tracefs_synth_add_end_field*(3),
+*tracefs_synth_append_start_filter*(3),
+*tracefs_synth_append_end_filter*(3),
+*tracefs_synth_free*(3),
+*tracefs_synth_echo_cmd*(3),
+*tracefs_synth_get_start_hist*(3),
+*tracefs_synth_get_name*(3),
+*tracefs_synth_raw_fmt*(3),
+*tracefs_synth_show_event*(3),
+*tracefs_synth_show_start_hist*(3),
+*tracefs_synth_show_end_hist*(3),
+*tracefs_synth_get_event*(3),
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
index 2b720c2ce368..8f64928e3b60 100644
--- a/Documentation/libtracefs-traceon.txt
+++ b/Documentation/libtracefs-traceon.txt
@@ -122,9 +122,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-tracer.txt b/Documentation/libtracefs-tracer.txt
index cca0e33af6ca..ea57962d9163 100644
--- a/Documentation/libtracefs-tracer.txt
+++ b/Documentation/libtracefs-tracer.txt
@@ -191,9 +191,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index aa8284a1ab1e..9478911afbae 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -79,9 +79,9 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 0123c0bbf47f..e7eb090b8268 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -237,8 +237,8 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_
-_trace-cmd(1)_
+*libtraceevent*(3),
+*trace-cmd*(1)
 
 AUTHOR
 ------
-- 
2.33.0

