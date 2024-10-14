Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90ADC19340F
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909110; cv=none; b=cLXGFaFmVozm89ugu/m9ayGqUIKX4Pk9X4Yv4vDMHglN7buZRjESvsqS3KIH03i0zRLco2/HTuWCh0DNKm9/rO7NjyNg8wwwE2wV8jiXQo7miqXsx8vMXMNkTSafPEd0ociKhHXkVt0C8xOAtqG1YYNXiEkM+ezvm3Bynw8wop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909110; c=relaxed/simple;
	bh=sacAeAuODOwBlaD9AF61394SmgCzkKDrVoA7kynMOqc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ORB9VrM3tgQMO+A2Ts120Hoc4SHjbxqCPruCTG1rlVq3BJd57Z9FxsBBY6IOE2Oea5gjoIsshYtWaK43KXVsYw++0zynCanuiAfATltD7Aank7IGE7yAnNdmlMwjFgCxWEm54mrcQJUZZ6JHax9OQMl38G8goUiTrNtzQoNlrR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48A431684;
	Mon, 14 Oct 2024 05:32:17 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1C2603F71E;
	Mon, 14 Oct 2024 05:31:46 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 2/4] trace-cmd reset: Add option to preserve specific dynamic events
Date: Mon, 14 Oct 2024 13:31:34 +0100
Message-Id: <20241014123136.3890807-3-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241014123136.3890807-1-metin.kaya@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One may want to preserve some of the dynamic events (e.g., kprobes)
during a trace-cmd reset. Thus, provide -k command line option for
trace-cmd reset to allow keeping specified events untouched during the
reset operation.

For example, it's possible to prevent kprobes & kretprobes from being
destroyed in trace-cmd reset with this patch:

    # Add kprobe and kretprobe for sys_open():
    $ echo 'p do_sys_open' > /sys/kernel/tracing/kprobe_events
    $ echo 1 > /sys/kernel/tracing/events/kprobes/p_do_sys_open_0/enable
    $ echo 'r do_sys_open' >> /sys/kernel/tracing/kprobe_events
    $ echo 1 > /sys/kernel/tracing/events/kprobes/r_do_sys_open_0/enable
    $ cat /sys/kernel/tracing/kprobe_events
    p:kprobes/p_do_sys_open_0 do_sys_open
    r128:kprobes/r_do_sys_open_0 do_sys_open

    # Issue reset, but keep kprobes and kretprobes ('-k all' would keep
    # all existing dynamic events):
    $ trace-cmd reset -k kprobe -k kretprobe
    $ cat /sys/kernel/tracing/kprobe_events
    p:kprobes/p_do_sys_open_0 do_sys_open
    r128:kprobes/r_do_sys_open_0 do_sys_open

    # Issue reset, but this time only keep kretprobes:
    $ trace-cmd reset -k kretprobe
    $ cat /sys/kernel/tracing/kprobe_events
    r128:kprobes/r_do_sys_open_0 do_sys_open

    # Don't preserve any dynamic event:
    $ trace-cmd reset
    $ cat /sys/kernel/tracing/kprobe_events
    $

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219302
Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 tracecmd/trace-record.c | 59 ++++++++++++++++++++++++++++++++++++-----
 tracecmd/trace-usage.c  |  6 ++++-
 2 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8c0039d4..a008cdfd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5399,11 +5399,15 @@ static void clear_error_log(void)
 		clear_instance_error_log(instance);
 }
 
-static void clear_all_dynamic_events(void)
+static void clear_all_dynamic_events(unsigned int excluded_types)
 {
-	/* Clear event probes first, as they may be attached to other dynamic event */
-	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
-	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true);
+	/*
+	 * Clear event probes first (if they are not excluded), as they may be
+	 * attached to other dynamic event.
+	 */
+	if (!(excluded_types & TRACEFS_DYNEVENT_EPROBE))
+		tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
+	tracefs_dynevent_destroy_all(~excluded_types & TRACEFS_DYNEVENT_ALL, true);
 }
 
 static void clear_func_filters(void)
@@ -6036,11 +6040,51 @@ void trace_restart(int argc, char **argv)
 	exit(0);
 }
 
+/**
+ * find_dynevent_type - Find string formatted dynamic event type
+ *			in "enum tracefs_dynevent_type".
+ *
+ * @type: Dynamic event type in string format.
+ *
+ * Returns an unsigned int value for the event specified in @type.
+ */
+static unsigned int find_dynevent_type(const char *type)
+{
+	/* WARN: Should be kept in sync with "enum tracefs_dynevent_type". */
+	if (!strcmp(type, "kprobe"))
+		return TRACEFS_DYNEVENT_KPROBE;
+	else if (!strcmp(type, "kretprobe"))
+		return TRACEFS_DYNEVENT_KRETPROBE;
+	else if (!strcmp(type, "uprobe"))
+		return TRACEFS_DYNEVENT_UPROBE;
+	else if (!strcmp(type, "uretprobe"))
+		return TRACEFS_DYNEVENT_URETPROBE;
+	else if (!strcmp(type, "eprobe"))
+		return TRACEFS_DYNEVENT_EPROBE;
+	else if (!strcmp(type, "synth"))
+		return TRACEFS_DYNEVENT_SYNTH;
+	else if (!strcmp(type, "all"))
+		/*
+		 * Unfortunately TRACEFS_DYNEVENT_ALL does not work here.
+		 * Because tracefs_dynevent_destroy_all() assumes 0 means all
+		 * and destroys all dynamic events.
+		 */
+		return TRACEFS_DYNEVENT_KPROBE |
+		       TRACEFS_DYNEVENT_KRETPROBE |
+		       TRACEFS_DYNEVENT_UPROBE |
+		       TRACEFS_DYNEVENT_URETPROBE |
+		       TRACEFS_DYNEVENT_EPROBE |
+		       TRACEFS_DYNEVENT_SYNTH;
+	else
+		die("Invalid event type '%s'!\n", type);
+}
+
 void trace_reset(int argc, char **argv)
 {
 	int c;
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
+	unsigned int excluded_types = 0;
 
 	init_top_instance();
 
@@ -6048,7 +6092,7 @@ void trace_reset(int argc, char **argv)
 	int last_specified_all = 0;
 	struct buffer_instance *inst; /* iterator */
 
-	while ((c = getopt(argc-1, argv+1, "hab:B:td")) >= 0) {
+	while ((c = getopt(argc-1, argv+1, "hab:B:tdk:")) >= 0) {
 
 		switch (c) {
 		case 'h':
@@ -6102,6 +6146,9 @@ void trace_reset(int argc, char **argv)
 				instance->flags &= ~BUFFER_FL_KEEP;
 			}
 			break;
+		case 'k':
+			excluded_types |= find_dynevent_type(optarg);
+			break;
 		default:
 			usage(argv);
 			break;
@@ -6112,7 +6159,7 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
-	clear_all_dynamic_events();
+	clear_all_dynamic_events(excluded_types);
 	clear_error_log();
 	/* set clock to "local" */
 	reset_clock();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 8bbf2e3e..7d61a371 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -193,7 +193,7 @@ static struct usage_help usage_help[] = {
 	{
 		"reset",
 		"disable all kernel tracing and clear the trace buffers",
-		" %s reset [-b size][-B buf][-a][-d][-t]\n"
+		" %s reset [-b size][-B buf][-k event][-a][-d][-t]\n"
 		"          Disables the tracer (may reset trace file)\n"
 		"          Used in conjunction with start\n"
 		"          -b change the kernel buffer size (in kilobytes per CPU)\n"
@@ -201,6 +201,10 @@ static struct usage_help usage_help[] = {
 		"          -B reset the given buffer instance (may specify multiple -B)\n"
 		"          -a reset all instances (except top one)\n"
 		"          -t reset the top level instance (useful with -B or -a)\n"
+		"          -k keep dynamic event during reset (can be specified multiple times).\n"
+		"              Valid values are:\n"
+		"              'kprobe', 'kretprobe', 'uprobe', 'uretprobe',\n"
+		"              'eprobe', 'synth' and 'all'.\n"
 	},
 	{
 		"clear",
-- 
2.34.1

