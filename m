Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997E35F544
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706017357; cv=none; b=pad2HRgZZ/0Czx+yU7JsqmHC7SsvjqzJoewYcyjvEaDCZsVYoEM2MOXBbVwhwF0ui3njhvnhaeEk4e9JXtNMX4p9UFHu0t0he8jr0OBkU4K3sg5RpjW0qrV/PKP+L35gkIQGIDDdRFKYKz/+1kQaIrUGkRngkk9yioKR9fRwaKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706017357; c=relaxed/simple;
	bh=GAx2bRdrHbj7QR3k8vLkNnkwc/bW4AXtT3WADmfqroE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BtV/P7UbW6YshBSbxZdm7k09ozXNBqqoyw6Xcc+H5FX1I43J1Up6w3R58gaV597ZkkRVojL24RIe2u2dKXjAaOierR92tEViHw0uGgTTnI4gEeH2ugAy2HXXu3pOO3iPTwfgJgi+i51MCdm5pH5imLHdiscMVG8NsJL3uVHiY7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A143106F;
	Tue, 23 Jan 2024 05:43:20 -0800 (PST)
Received: from e126645.home (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 197D23F7CE;
	Tue, 23 Jan 2024 05:42:33 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v3 1/5] trace-cmd split: Store instances in local list
Date: Tue, 23 Jan 2024 14:42:11 +0100
Message-Id: <20240123134215.385415-2-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240123134215.385415-1-pierre.gondois@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
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
 tracecmd/trace-split.c | 89 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index b6c056b5..d5b77ab7 100644
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
@@ -49,6 +51,75 @@ struct cpu_data {
 	char				*file;
 };
 
+struct handle_list {
+	struct list_head		list;
+	const char			*name;
+	int				index;
+	struct tracecmd_input 		*handle;
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
+/**
+ * get_handle - Obtain a handle that must be closed once finished.
+ */
+static struct tracecmd_input *get_handle(struct handle_list *item)
+{
+	struct tracecmd_input *top_handle, *handle;
+
+	top_handle = tracecmd_open(input_file, 0);
+	if (!top_handle)
+		die("Error reading %s", input_file);
+
+	if (item->was_top_instance) {
+		return top_handle;
+	} else {
+		handle = tracecmd_buffer_instance_handle(top_handle, item->index);
+		if (!handle)
+			warning("Could not retrieve handle %s", item->name);
+
+		tracecmd_close(top_handle);
+		return handle;
+	}
+}
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
+	if (!item->name)
+		die("Failed to duplicate %s", name);
+
+	item->index = index;
+	item->was_top_instance = was_top_instance;
+	item->handle = get_handle(item);
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
+		free((char *)item->name);
+		tracecmd_close(item->handle);
+		free(item);
+	}
+}
+
 static int create_type_len(struct tep_handle *pevent, int time, int len)
 {
 	static int bigendian = -1;
@@ -450,6 +521,7 @@ void trace_split (int argc, char **argv)
 	char *output_file;
 	enum split_types split_type = SPLIT_NONE;
 	enum split_types type = SPLIT_NONE;
+	int instances;
 	int count;
 	int repeat = 0;
 	int percpu = 0;
@@ -457,6 +529,8 @@ void trace_split (int argc, char **argv)
 	int ac;
 	int c;
 
+	list_head_init(&handle_list);
+
 	if (strcmp(argv[1], "split") != 0)
 		usage(argv);
 
@@ -561,6 +635,20 @@ void trace_split (int argc, char **argv)
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
@@ -579,6 +667,7 @@ void trace_split (int argc, char **argv)
 	free(output_file);
 
 	tracecmd_close(handle);
+	free_handles(&handle_list);
 
 	return;
 }
-- 
2.25.1

