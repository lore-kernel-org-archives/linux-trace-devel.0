Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C7BECAAD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 21:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiIVVrv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 17:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiIVVru (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 17:47:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B93EA5B3
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 14:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B24B81CF0
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 21:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA1CC433D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 21:47:44 +0000 (UTC)
Date:   Thu, 22 Sep 2022 17:48:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Add API for mapping between host and 
 guests
Message-ID: <20220922174847.30475299@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

After writing a few applications to analyze host guest interactions, I
found that I was writing the same code. Instead, add helper functions to
do the mapping.

    tracecmd_map_vcpus()
    tracecmd_get_cpu_map()
    tracecmd_map_find_by_host_pid()
    tracecmd_cpu_map()
    tracecmd_map_get_host_pid()
    tracecmd_map_get_guest()
    tracecmd_map_set_private()
    tracecmd_map_set_private()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-maps.txt          | 177 +++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  10 +
 include/trace-cmd/trace-cmd.h                 |  11 ++
 lib/trace-cmd/Makefile                        |   1 +
 lib/trace-cmd/include/trace-cmd-local.h       |   6 +
 lib/trace-cmd/trace-input.c                   |  31 +++
 lib/trace-cmd/trace-maps.c                    | 180 ++++++++++++++++++
 7 files changed, 416 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-maps.txt
 create mode 100644 lib/trace-cmd/trace-maps.c

diff --git a/Documentation/libtracecmd/libtracecmd-maps.txt b/Documentation/libtracecmd/libtracecmd-maps.txt
new file mode 100644
index 000000000000..8c1fb69d04ff
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-maps.txt
@@ -0,0 +1,177 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_map_vcpus, tracecmd_get_cpu_map, tracecmd_map_find_by_host_pid, tracecmd_map_get_host_pid,
+tracecmd_map_get_guest, tracecmd_map_set_private, tracecmd_map_get_private - Mapping host and guest data
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+int *tracecmd_map_vcpus*(struct tracecmd_input pass:[**]handles, int nr_handles);
+struct tracecmd_cpu_map pass:[*]*tracecmd_get_cpu_map*(struct tracecmd_input pass:[*]handle, int cpu);
+struct tracecmd_cpu_map pass:[*]*tracecmd_map_find_by_host_pid*(struct tracecmd_input pass:[*]handle,
+						      int host_pid);
+int *tracecmd_map_get_host_pid*(struct tracecmd_cpu_map pass:[*]map);
+struct tracecmd_input pass:[*]*tracecmd_map_get_guest*(struct tracecmd_cpu_map pass:[*]map);
+void *tracecmd_map_set_private*(struct tracecmd_cpu_map pass:[*]map, void pass:[*]priv);
+void pass:[*]*tracecmd_map_get_private*(struct tracecmd_cpu_map pass:[*]map);
+--
+
+DESCRIPTION
+-----------
+This set of APIs is used to map host and guest trace files for to facilitate
+further tracing analysis.
+
+The *tracecmd_map_vcpus()* takes an array of _handles_ where each item in that
+array was created by one of the *tracecmd_open(3)* functions, and the number
+of handles as _nr_handles_. The first handle in the array of _handles_ is expected
+to be the descriptor for the host tracing file, and the rest are guest trace
+files that run on the host, and were created by the *trace-cmd record(1)* and
+*trace-cmd agent(1)* interactions. It returns the number of guests found in
+_handles_ that were associated with the host, or negative on error.
+
+The *tracecmd_get_cpu_map()* returns a descriptor for a given CPU for a handle.
+If the _handle_ was a guest defined from *tracecmd_map_vcpus()* then the mapping
+created from that function that is associated to this particular vCPU (denoted by
+_cpu_) from _handle_. This destriptor can be used by *tarcecmd_map_get_guest()*,
+*tracecmd_map_set_private()* and *tracecmd_map_get_private()* functions.
+
+The *tracecmd_map_find_by_host_pid()* will return a mapping for a guest virtual
+CPU that is handled by the given _host_pid_. Note, the _handle_ passed in can be
+either the host handle or one of the guest's handles for that host that was
+mapped by *tracecmd_map_vcpus()*, even if the guest handle does not have the vCPU
+that the _host_pid_ represents.
+
+The *tracecmd_map_get_host_pid()* will recturn the host_pid for a given _map_
+that was retrieved by one of the above functions.
+
+The *tracecmd_map_get_guest()* will recturn the guest_handle for a given _map_
+that was retrieved by one of the above functions.
+
+The *tracecmd_map_set_private()* allows the application to assign private data
+for a given guest vCPU to host thread mapping defined by _map_.
+
+The *tracecmd_map_get_private()* retrieves the _priv_ data from _map_ that was
+set by *tracecmd_map_set_private()*.
+
+RETURN VALUE
+------------
+*tracecmd_map_vcpus()* returns the number of guests in the _handles_ array that
+were mapped to the host handle that is the first entry in _handles_. It returns
+-1 on error.
+
+*tracecmd_get_cpu_map()* returns a map created by *tracecmd_map_vcpus()* for
+a given _cpu_ for a given _handle_, or NULL if it is not found.
+
+*tracecmd_map_find_by_host_pid()* returns a map that is associated by the host
+task with _host_pid_ as its process ID. _handle_ can be either a the host
+handle, or one of the guest handles that were mapped to the host via
+*tracecmd_map_vcpus()*, even if the guest handle is another guest than
+the one that the mapping is for. It returns NULL if not found.
+
+*tracecmd_map_get_host_pid()* returns the host process ID for an associated
+mapping defined by _map_.
+
+*tracecmd_map_get_guest()* returns the guest handle for an associated
+mapping defined by _map_.
+
+*tracecmd_map_get_private()* returns the private data of a mapping defined
+by _map_ that was set by *tracecmd_map_set_private()*.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <errno.h>
+#include <trace-cmd.h>
+
+int main(int argc, char **argv)
+{
+	struct tracecmd_input **handles = NULL;
+	int nr_handles;
+	int i;
+
+	if (argc < 2) {
+		printf("usage: host_trace.dat guest1_trace.dat [guest2_trace.dat ...]\n");
+		exit(-1);
+	}
+
+	for (i = 1; i < argc; i++) {
+		handles = realloc(handles, sizeof(*handles) * (nr_handles + 1));
+		if (!handles)
+			exit(-1);
+		handles[nr_handles] = tracecmd_open(argv[i], 0);
+		if (!handles[nr_handles]) {
+			perror(argv[1]);
+			exit(-1);
+		}
+		tracecmd_set_private(handles[nr_handles], argv[i]);
+		nr_handles++;
+	}
+
+	tracecmd_map_vcpus(handles, nr_handles);
+
+	for (i = 1; i < nr_handles; i++) {
+		struct tracecmd_cpu_map *map;
+		struct tep_handle *tep;
+		const char *file = tracecmd_get_private(handles[i]);
+		int cpus, cpu;
+
+		printf("Mappings for guest %s:\n", file);
+		tep = tracecmd_get_tep(handles[i]);
+		cpus = tep_get_cpus(tep);
+		for (cpu = 0; cpu < cpus; cpu++) {
+			printf("  [%03d] ", cpu);
+			map = tracecmd_get_cpu_map(handles[i], cpu);
+			if (!map) {
+				printf("Has no mapping!\n");
+				continue;
+			}
+			printf("host_pid: %d\n", tracecmd_map_get_host_pid(map));
+		}
+	}
+	for (i = 0; i < nr_handles; i++)
+		tracecmd_close(handles[i]);
+	free(handles);
+	exit(0);
+}
+--
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracefs(3)*,
+*libtraceevent(3)*,
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
+
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index d2d17f7cbaba..b1e07df56346 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -63,6 +63,16 @@ Get traceing peer information from a trace file:
 	unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
 	int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
 
+Mapping host and guest trace files:
+	int *tracecmd_map_vcpus*(struct tracecmd_input pass:[**]handles, int nr_handles);
+	struct tracecmd_cpu_map pass:[*]*tracecmd_get_cpu_map*(struct tracecmd_input pass:[*]handle, int cpu);
+	struct tracecmd_cpu_map pass:[*]*tracecmd_map_find_by_host_pid*(struct tracecmd_input pass:[*]handle,
+						      int host_pid);
+	int *tracecmd_map_get_host_pid*(struct tracecmd_cpu_map pass:[*]map);
+	struct tracecmd_input pass:[*]*tracecmd_map_get_guest*(struct tracecmd_cpu_map pass:[*]map);
+	void *tracecmd_map_set_private*(struct tracecmd_cpu_map pass:[*]map, void pass:[*]priv);
+	void pass:[*]*tracecmd_map_get_private*(struct tracecmd_cpu_map pass:[*]map);
+
 Control library logs:
 	int *tracecmd_set_loglevel*(enum tep_loglevel _level_);
 --
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index bc5edb4d695f..c34503ac7de5 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -88,6 +88,17 @@ enum tracecmd_filters {
 struct tracecmd_filter;
 struct tracecmd_filter *tracecmd_filter_add(struct tracecmd_input *handle,
 					    const char *filter_str, bool neg);
+
+struct tracecmd_cpu_map;
+int tracecmd_map_vcpus(struct tracecmd_input **handles, int nr_handles);
+struct tracecmd_cpu_map *tracecmd_get_cpu_map(struct tracecmd_input *handle, int cpu);
+struct tracecmd_cpu_map *tracecmd_map_find_by_host_pid(struct tracecmd_input *handle,
+						      int host_pid);
+struct tracecmd_input *tracecmd_map_get_guest(struct tracecmd_cpu_map *map);
+int tracecmd_map_get_host_pid(struct tracecmd_cpu_map *map);
+void tracecmd_map_set_private(struct tracecmd_cpu_map *map, void *priv);
+void *tracecmd_map_get_private(struct tracecmd_cpu_map *map);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 28b4afc665a6..e9d26b2bb367 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -18,6 +18,7 @@ OBJS += trace-filter-hash.o
 OBJS += trace-filter.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
+OBJS += trace-maps.o
 ifeq ($(PERF_DEFINED), 1)
 OBJS += trace-perf.o
 endif
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index c95ec6530fdd..db0b2c21ee45 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -52,6 +52,12 @@ struct data_file_write {
 enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
 					    struct tep_record *record);
 
+void trace_set_guest_map(struct tracecmd_input *handle, struct tracecmd_cpu_map *map);
+struct tracecmd_cpu_map *trace_get_guest_map(struct tracecmd_input *handle);
+void trace_set_guest_map_cnt(struct tracecmd_input *handle, int count);
+int trace_get_guest_map_cnt(struct tracecmd_input *handle);
+void trace_guest_map_free(struct tracecmd_cpu_map *map);
+
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ce3584eef201..d81918249871 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -171,6 +171,7 @@ struct tracecmd_input {
 	struct tracecmd_input	*parent;
 	struct tracecmd_filter	*filter;
 	struct follow_event	*followers;
+	struct tracecmd_cpu_map *map;
 	unsigned long		file_state;
 	unsigned long long	trace_id;
 	unsigned long long	next_offset;
@@ -191,6 +192,7 @@ struct tracecmd_input {
 	bool			read_zpage; /* uncompress pages in memory, do not use tmp files */
 	bool			cpu_compressed;
 	int			file_version;
+	int			map_cnt;
 	unsigned int		cpustats_size;
 	struct cpu_zdata	latz;
 	struct cpu_data 	*cpu_data;
@@ -320,6 +322,34 @@ static const char *show_records(struct page **pages, int nr_pages)
 }
 #endif
 
+/**
+ * trace_set_guest_map - set map to input handle
+ * @handle: The handle to set the cpu map to
+ * @map: The cpu map for this handle (to the host)
+ *
+ * Assign the mapping of host to guest for a guest handle.
+ */
+__hidden void trace_set_guest_map(struct tracecmd_input *handle,
+				  struct tracecmd_cpu_map *map)
+{
+	handle->map = map;
+}
+
+__hidden struct tracecmd_cpu_map *trace_get_guest_map(struct tracecmd_input *handle)
+{
+	return handle->map;
+}
+
+__hidden void trace_set_guest_map_cnt(struct tracecmd_input *handle, int count)
+{
+	handle->map_cnt = count;
+}
+
+__hidden int trace_get_guest_map_cnt(struct tracecmd_input *handle)
+{
+	return handle->map_cnt;
+}
+
 static int init_cpu(struct tracecmd_input *handle, int cpu);
 
 static ssize_t do_read_fd(int fd, void *data, size_t size)
@@ -4801,6 +4831,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->trace_clock);
 	free(handle->strings);
 	free(handle->version);
+	trace_guest_map_free(handle->map);
 	close(handle->fd);
 	free(handle->latz.chunks);
 	if (handle->latz.fd >= 0) {
diff --git a/lib/trace-cmd/trace-maps.c b/lib/trace-cmd/trace-maps.c
new file mode 100644
index 000000000000..b5808ecb4a66
--- /dev/null
+++ b/lib/trace-cmd/trace-maps.c
@@ -0,0 +1,180 @@
+#include <stdlib.h>
+
+#include "trace-cmd-local.h"
+#include "trace-local.h"
+
+/*
+ * Structure to hold the mapping between host and guest.
+ * @self - A pointer back to the guest's mapping (for the host copy to use)
+ * @host_handle - The handle for the host for this mapping.
+ * @guest_handle - The handle for the guest for this mapping.
+ * @guest_vcpu - The vCPU # for this mapping.
+ * @host_pid - The pid of the task on the host that runs when this vCPU executes.
+ * @private - Private data for applications to use.
+ */
+struct tracecmd_cpu_map {
+	struct tracecmd_cpu_map		*self;
+	struct tracecmd_input		*host_handle;
+	struct tracecmd_input		*guest_handle;
+	int				guest_vcpu;
+	int				host_pid;
+	void				*private;
+};
+
+static int cmp_map(const void *A, const void *B)
+{
+	const struct tracecmd_cpu_map *a = A;
+	const struct tracecmd_cpu_map *b = B;
+
+	if (a->host_pid < b->host_pid)
+		return -1;
+	return a->host_pid > b->host_pid;
+}
+
+int tracecmd_map_vcpus(struct tracecmd_input **handles, int nr_handles)
+{
+	struct tracecmd_input *host_handle = handles[0];
+	unsigned long long traceid;
+	struct tracecmd_cpu_map *vcpu_maps = NULL;
+	struct tracecmd_cpu_map *gmap;
+	struct tracecmd_cpu_map *map;
+	const int *cpu_pids;
+	const char *name;
+	int nr_vcpu_maps = 0;
+	int vcpu_count;
+	int mappings = 0;
+	int ret;
+	int i, k;
+
+	/* handles[0] is the host handle, do for each guest handle */
+	for (i = 1; i < nr_handles; i++) {
+		traceid = tracecmd_get_traceid(handles[i]);
+
+		/*
+		 * Retrieve the host mapping of the guest for this handle.
+		 * cpu_pids is an array of pids that map 1-1 the host vcpus where
+		 * cpu_pids[vCPU_num] = host_task_pid
+		 */
+		ret = tracecmd_get_guest_cpumap(host_handle, traceid,
+						&name, &vcpu_count, &cpu_pids);
+		if (ret)
+			continue;
+
+		mappings++;
+
+		gmap = calloc(sizeof(*gmap), vcpu_count);
+		if (!gmap)
+			goto fail;
+
+		for (k = 0; k < vcpu_count; k++) {
+			gmap[k].host_handle = handles[0];
+			gmap[k].guest_handle = handles[i];
+			gmap[k].guest_vcpu = k;
+			gmap[k].host_pid = cpu_pids[k];
+			gmap[k].self = &gmap[k];
+		}
+
+		trace_set_guest_map(handles[i], gmap);
+		trace_set_guest_map_cnt(handles[i], vcpu_count);
+
+		/* Update the host mapping of all guests to the host */
+		map = realloc(vcpu_maps, sizeof(*map) * (nr_vcpu_maps + vcpu_count));
+		if (!map)
+			goto fail;
+		memset(map + nr_vcpu_maps, 0, sizeof(*map) * (vcpu_count - nr_vcpu_maps));
+
+		vcpu_maps = map;
+		map += nr_vcpu_maps;
+		nr_vcpu_maps += vcpu_count;
+
+		for (k = 0; k < vcpu_count; k++)
+			map[k] = gmap[k];
+	}
+	if (!vcpu_maps)
+		return 0;
+
+	/* We want to do a binary search via host_pid to find these mappings */
+	qsort(vcpu_maps, nr_vcpu_maps, sizeof(*map), cmp_map);
+
+	trace_set_guest_map(handles[0], vcpu_maps);
+	trace_set_guest_map_cnt(handles[0], nr_vcpu_maps);
+
+	return mappings;
+
+ fail:
+	free(vcpu_maps);
+	return -1;
+}
+
+__hidden void trace_guest_map_free(struct tracecmd_cpu_map *map)
+{
+	free(map);
+}
+
+struct tracecmd_cpu_map *tracecmd_map_find_by_host_pid(struct tracecmd_input *handle,
+						       int host_pid)
+{
+	struct tracecmd_cpu_map *map;
+	struct tracecmd_cpu_map key;
+	int nr_maps;
+
+	map = trace_get_guest_map(handle);
+	if (!map)
+		return NULL;
+
+	/* The handle could be from the guest, get the host handle */
+	handle = map->host_handle;
+
+	/* And again, get the mapping of the host, as it has all the mappings */
+	map = trace_get_guest_map(handle);
+	if (!map)
+		return NULL;
+
+	nr_maps = trace_get_guest_map_cnt(handle);
+
+	key.host_pid = host_pid;
+
+	map = bsearch(&key, map, nr_maps, sizeof(*map), cmp_map);
+
+	return map ? map->self : NULL;
+}
+
+void tracecmd_map_set_private(struct tracecmd_cpu_map *map, void *priv)
+{
+	/* Only set the guest private */
+	map = map->self;
+	map->private = priv;
+}
+
+void *tracecmd_map_get_private(struct tracecmd_cpu_map *map)
+{
+	/* Return the guest private */
+	map = map->self;
+	return map->private;
+}
+
+struct tracecmd_input *tracecmd_map_get_guest(struct tracecmd_cpu_map *map)
+{
+	return map->guest_handle;
+}
+
+int tracecmd_map_get_host_pid(struct tracecmd_cpu_map *map)
+{
+	return map->host_pid;
+}
+
+struct tracecmd_cpu_map *tracecmd_get_cpu_map(struct tracecmd_input *handle, int cpu)
+{
+	struct tracecmd_cpu_map *map;
+	int cnt;
+
+	map = trace_get_guest_map(handle);
+	/* Make sure it's for the guest handle, as this could be a host handle */
+	map = map->self;
+	cnt = trace_get_guest_map_cnt(map->guest_handle);
+	if (cnt <= cpu)
+		return NULL;
+
+	return map + cpu;
+}
+
-- 
2.35.1

