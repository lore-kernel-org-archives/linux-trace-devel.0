Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90F058137
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941834; cv=none; b=rRKcoGPp8HfcXyxjC75ByMfv1bmn5YkwscoMz2XizDJCNU0GjckEmHMCq+NU6/LRW0Itiy1jqAk2Ty0OzhkCPmlfrb6vmY4cWpMmIlkkZfPHgZKE1nMJvz6xJ0+jgCa+c9Pi7XjpQGLYEFhJJ+GH1BJsZ/TA80jmGs35pGoD0mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941834; c=relaxed/simple;
	bh=iZXaWAOQqHDReQYBp9p5x3xhSD1q2J+D5UqufRhqJnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eobgEx2/lgt4JRhTttsHbNhXCS67v8Jumn+TeEnPqO0xrJX33mqt1Gl7s7k1JQXRUX88w5keL/46DdN4Pol0K7Q9rcHueSNNpNMufCZIw6byli0NiHRbr2FbM/mi4W7ENH98lj6RJ9Pm1Q6DFFVFUlP1dmMG+sEUQ2jKXquO+Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BEE8113E;
	Mon, 22 Jan 2024 08:44:38 -0800 (PST)
Received: from e126645.nice.arm.com (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9F9B63F5A1;
	Mon, 22 Jan 2024 08:43:51 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2 3/7] trace-cmd split: Store instances in local list
Date: Mon, 22 Jan 2024 17:43:32 +0100
Message-Id: <20240122164336.167256-4-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122164336.167256-1-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare handling of multiple instances, store instance
handles in a local list, similarly to what is currently
done in tracecmd/trace-read.c.

To help achieve this goal, add a 'struct handle_list' and
add_handle()/free_handles() functions. 'struct handle' elements
are added to the static list, but not used in this patch.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index b6c056b5..f46813d1 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -19,10 +19,12 @@
 #include <ctype.h>
 #include <errno.h>
 
+#include "list.h"
 #include "trace-local.h"
 
 static unsigned int page_size;
 static const char *default_input_file = DEFAULT_INPUT_FILE;
+static const char *default_top_instance_name = "top";
 static const char *input_file;
 
 enum split_types {
@@ -49,6 +51,46 @@ struct cpu_data {
 	char				*file;
 };
 
+struct handle_list {
+	struct list_head		list;
+	const char			*name;
+	int				index;
+
+	/* Identify the top instance in the input trace. */
+	bool				was_top_instance;
+
+	/* Identify the top instance in each output trace. */
+	bool				is_top_instance;
+};
+
+static struct list_head handle_list;
+
+static void add_handle(const char *name, int index, bool was_top_instance)
+{
+	struct handle_list *item;
+
+	item = calloc(1, sizeof(*item));
+	if (!item)
+		die("Failed to allocate handle item");
+
+	item->name = strdup(name);
+	item->index = index;
+	item->was_top_instance = was_top_instance;
+	list_add_tail(&item->list, &handle_list);
+}
+
+static void free_handles(struct list_head *list)
+{
+	struct handle_list *item;
+
+	while (!list_empty(list)) {
+		item = container_of(list->next, struct handle_list, list);
+		list_del(&item->list);
+		free((char*)item->name);
+		free(item);
+	}
+}
+
 static int create_type_len(struct tep_handle *pevent, int time, int len)
 {
 	static int bigendian = -1;
@@ -450,6 +492,7 @@ void trace_split (int argc, char **argv)
 	char *output_file;
 	enum split_types split_type = SPLIT_NONE;
 	enum split_types type = SPLIT_NONE;
+	int instances;
 	int count;
 	int repeat = 0;
 	int percpu = 0;
@@ -457,6 +500,8 @@ void trace_split (int argc, char **argv)
 	int ac;
 	int c;
 
+	list_head_init(&handle_list);
+
 	if (strcmp(argv[1], "split") != 0)
 		usage(argv);
 
@@ -561,6 +606,20 @@ void trace_split (int argc, char **argv)
 		die("Failed to allocate for %s", output);
 	c = 1;
 
+	add_handle(default_top_instance_name, -1, true);
+	instances = tracecmd_buffer_instances(handle);
+	if (instances) {
+		const char *name;
+		int i;
+
+		for (i = 0; i < instances; i++) {
+			name = tracecmd_buffer_instance_name(handle, i);
+			if (!name)
+				die("error in reading buffer instance");
+			add_handle(name, i, false);
+		}
+	}
+
 	do {
 		if (repeat)
 			sprintf(output_file, "%s.%04d", output, c++);
@@ -579,6 +638,7 @@ void trace_split (int argc, char **argv)
 	free(output_file);
 
 	tracecmd_close(handle);
+	free_handles(&handle_list);
 
 	return;
 }
-- 
2.25.1

