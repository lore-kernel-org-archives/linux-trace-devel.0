Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70F7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349538AbiARDNS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:13:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352564AbiARDAK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 22:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B561DB811CE
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 03:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A71C36AEF;
        Tue, 18 Jan 2022 03:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n9ej8-006jFy-CG;
        Mon, 17 Jan 2022 22:00:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Add tracefs_instance_get_affinity() APIs
Date:   Mon, 17 Jan 2022 22:00:04 -0500
Message-Id: <20220118030005.1603821-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220118030005.1603821-1-rostedt@goodmis.org>
References: <20220118030005.1603821-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add the APIs:

  tracefs_instance_get_affinity()
  tracefs_instance_get_affinity_set()
  tracefs_instance_get_affinity_raw()

These functions can retrieve the CPU affinity that denotes what an
instance (or toplevel) has for CPUs that are enabled for tracing.

The first API returns a nice human readable list of CPUs:

 "1,4,6-8"

To denote CPUs 1,4,6,7,8

The _set() version uses CPU_SETS and the _raw() version just reads
directly from the tracing_cpumask file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../libtracefs-instances-affinity.txt         |  39 +++-
 include/tracefs.h                             |   4 +
 src/tracefs-instance.c                        | 192 ++++++++++++++++++
 3 files changed, 231 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index c5fa2d8b820c..22994f877e30 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -3,8 +3,9 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw -
-Sets the affinity for an instance or top level for what CPUs enable tracing.
+tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw,
+tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_get_affinity_raw,
+Sets or retrieves the affinity for an instance or top level for what CPUs enable tracing.
 
 SYNOPSIS
 --------
@@ -16,11 +17,14 @@ int *tracefs_instance_set_affinity*(struct tracefs_instance pass:[*]_instance_,
 int *tracefs_instance_set_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
 int *tracefs_instance_set_affinity_raw*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_mask_);
 
+char pass:[*]*tracefs_instance_get_affinity*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instance_get_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
+char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*]_instance_);
 --
 
 DESCRIPTION
 -----------
-These functions set the CPU affinity that limits what CPUs will have tracing enabled
+These functions set or retrieves the CPU affinity that limits what CPUs will have tracing enabled
 for a given instance defined by the _instance_ parameter. If _instance_ is NULL, then
 the top level instance is affected.
 
@@ -47,9 +51,32 @@ machine with more that 32 CPUs, to set CPUS 1-10 and CPU 40:
 
 Where the above is a hex representation of bits 1-10 and bit 40 being set.
 
+The *tracefs_instance_get_affinity()* will retrieve the affinity in a human readable
+form.
+
+For example: "1,4,6-8"
+
+The string returned must be freed with *free*(3).
+
+The *tracefs_instance_get_affinity_set()* will set all the bits in the passed in
+cpu set (from *CPU_SET*(3)). Note it will not clear any bits that are already set
+in the set but the CPUs are not. If only the bits for the CPUs that are enabled
+should be set, a CPU_ZERO_S() should be performed on the set before calling this
+function.
+
+The *tracefs_instance_get_affinity_raw()* will simply read the instance tracing_cpumask
+and return that string. The returned string must be freed with *free*(3).
+
 RETURN VALUE
 ------------
-All of these functions return 0 on success and -1 on error.
+All the set functions return 0 on success and -1 on error.
+
+The functinos *tracefs_instance_get_affinity()* and *tracefs_instance_get_affinity_raw()*
+returns an allocated string that must be freed with *free*(3), or NULL on error.
+
+The function *tracefs_instance_get_affinity_set()* returns the number of CPUs that
+were found set, or -1 on error.
+
 
 ERRORS
 ------
@@ -88,6 +115,10 @@ int main (int argc, char **argv)
 	int cpu2;
 	int i;
 
+	c = tracefs_instance_get_affinity(NULL);
+	printf("The affinity was %s\n", c);
+	free(c);
+
 	if (argc < 2) {
 		tracefs_instance_set_affinity(NULL, NULL);
 		exit(0);
diff --git a/include/tracefs.h b/include/tracefs.h
index 9c53b8413795..1848ad0aa668 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -49,6 +49,10 @@ int tracefs_instance_set_affinity_raw(struct tracefs_instance *instance,
 				      const char *mask);
 int tracefs_instance_set_affinity(struct tracefs_instance *instance,
 				  const char *cpu_str);
+char *tracefs_instance_get_affinity(struct tracefs_instance *instance);
+char *tracefs_instance_get_affinity_raw(struct tracefs_instance *instance);
+int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
+				      cpu_set_t *set, size_t set_size);
 char **tracefs_instances(const char *regex);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index fab615eb49ca..2d825b0e3bd0 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -10,6 +10,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <ctype.h>
 #include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -974,3 +975,194 @@ int tracefs_instance_set_affinity(struct tracefs_instance *instance,
 	CPU_FREE(set);
 	return ret;
 }
+
+/**
+ * tracefs_instance_get_affinity_raw - read the affinity instance file
+ * @instance: The instance to get affinity of (NULL for top level)
+ *
+ * Reads the affinity file for @instance (or the top level if @instance
+ * is NULL) and returns it. The returned string must be freed with free().
+ *
+ * Returns the affinity mask on success, and must be freed with free()
+ *   or NULL on error.
+ */
+char *tracefs_instance_get_affinity_raw(struct tracefs_instance *instance)
+{
+	return tracefs_instance_file_read(instance, "tracing_cpumask", NULL);
+}
+
+static inline int update_cpu_set(int cpus, int cpu_set, int cpu,
+				 cpu_set_t *set, size_t set_size)
+{
+	int bit = 1 << cpu;
+
+	if (!(cpus & bit))
+		return 0;
+
+	CPU_SET_S(cpu_set + cpu, set_size, set);
+	return 1;
+}
+
+/**
+ * tracefs_instance_get_affinity_set - Retrieve the cpuset of an instance affinity
+ * @instance: The instance to get affinity of (NULL for top level)
+ * @set: A CPU set to put the affinity into.
+ * @set_size: The size in bytes of @set (use CPU_ALLOC_SIZE() to get this value)
+ *
+ * Reads the affinity of a given instance and updates the CPU set by the
+ * instance.
+ *
+ * Returns the number of CPUS that are set, or -1 on error.
+ */
+int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
+				      cpu_set_t *set, size_t set_size)
+{
+	char *affinity;
+	int cpu_set;
+	int cpus;
+	int cnt = 0;
+	int ch;
+	int i;
+
+	if (!set || !set_size) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	affinity = tracefs_instance_get_affinity_raw(instance);
+	if (!affinity)
+		return -1;
+
+	/*
+	 * The returned affinity should be a comma delimited
+	 * hex string. Work backwards setting the values.
+	 */
+	cpu_set = 0;
+	i = strlen(affinity);
+	for (i--; i >= 0; i--) {
+		ch = affinity[i];
+		if (isalnum(ch)) {
+			ch = tolower(ch);
+			if (isdigit(ch))
+				cpus = ch - '0';
+			else
+				cpus = ch - 'a' + 10;
+
+			cnt += update_cpu_set(cpus, cpu_set, 0, set, set_size);
+			cnt += update_cpu_set(cpus, cpu_set, 1, set, set_size);
+			cnt += update_cpu_set(cpus, cpu_set, 2, set, set_size);
+			cnt += update_cpu_set(cpus, cpu_set, 3, set, set_size);
+			/* Next nibble */
+			cpu_set += 4;
+		}
+	}
+
+	free(affinity);
+
+	return cnt;
+}
+
+static inline int update_cpu(int cpus, int cpu_set, int cpu, int s, char **set)
+{
+	char *list;
+	int bit = 1 << cpu;
+	int ret;
+
+	if (*set == (char *)-1)
+		return s;
+
+	if (cpus & bit) {
+		/* If the previous CPU is set just return s */
+		if (s >= 0)
+			return s;
+		/* Otherwise, return this cpu */
+		return cpu_set + cpu;
+	}
+
+	/* If the last CPU wasn't set, just return s */
+	if (s < 0)
+		return s;
+
+	/* Update the string */
+	if (s == cpu_set + cpu - 1) {
+		ret = asprintf(&list, "%s%s%d",
+			       *set ? *set : "", *set ? "," : "", s);
+	} else {
+		ret = asprintf(&list, "%s%s%d-%d",
+			       *set ? *set : "", *set ? "," : "",
+			       s, cpu_set + cpu - 1);
+	}
+	free(*set);
+	/* Force *set to be a failure */
+	if (ret < 0)
+		*set = (char *)-1;
+	else
+		*set = list;
+	return -1;
+}
+
+/**
+ * tracefs_instance_get_affinity - Retrieve a string of CPUs for instance affinity
+ * @instance: The instance to get affinity of (NULL for top level)
+ *
+ * Reads the affinity of a given instance and returns a CPU count of the
+ * instance. For example, if it reads "eb" it will return:
+ *      "0-1,3,5-7"
+ *
+ * If no CPUs are set, an empty string is returned "\0", and it too needs
+ * to be freed.
+ *
+ * Returns an allocate string containing the CPU affinity in "human readable"
+ *  format which needs to be freed with free(), or NULL on error.
+ */
+char *tracefs_instance_get_affinity(struct tracefs_instance *instance)
+{
+	char *affinity;
+	char *set = NULL;
+	int cpu_set;
+	int cpus;
+	int ch;
+	int s = -1;
+	int i;
+
+	affinity = tracefs_instance_get_affinity_raw(instance);
+	if (!affinity)
+		return NULL;
+
+	/*
+	 * The returned affinity should be a comma delimited
+	 * hex string. Work backwards setting the values.
+	 */
+	cpu_set = 0;
+	i = strlen(affinity);
+	for (i--; i >= 0; i--) {
+		ch = affinity[i];
+		if (isalnum(ch)) {
+			ch = tolower(ch);
+			if (isdigit(ch))
+				cpus = ch - '0';
+			else
+				cpus = ch - 'a' + 10;
+			s = update_cpu(cpus, cpu_set, 0, s, &set);
+			s = update_cpu(cpus, cpu_set, 1, s, &set);
+			s = update_cpu(cpus, cpu_set, 2, s, &set);
+			s = update_cpu(cpus, cpu_set, 3, s, &set);
+
+			if (set == (char *)-1) {
+				set = NULL;
+				goto out;
+			}
+			/* Next nibble */
+			cpu_set += 4;
+		}
+	}
+	/* Clean up in case the last CPU is set */
+	s = update_cpu(0, cpu_set, 0, s, &set);
+
+	if (!set)
+		set = strdup("");
+ out:
+	free(affinity);
+
+	return set;
+}
-- 
2.33.0

