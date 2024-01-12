Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6622482F7
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 08:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD44A1424;
	Fri, 12 Jan 2024 00:40:46 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.77.163])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 82AEB3F64C;
	Fri, 12 Jan 2024 00:39:59 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH 3/5] trace-cmd: split: Store instances in local list
Date: Fri, 12 Jan 2024 09:39:43 +0100
Message-Id: <20240112083945.1361293-4-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240112083945.1361293-1-pierre.gondois@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
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

To help achieve this goal, add a 'struct handle_list' and a
add_handle() function.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index b6c056b5..f2edfbfc 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -19,6 +19,7 @@
 #include <ctype.h>
 #include <errno.h>
 
+#include "list.h"
 #include "trace-local.h"
 
 static unsigned int page_size;
@@ -49,6 +50,26 @@ struct cpu_data {
 	char				*file;
 };
 
+struct handle_list {
+	struct list_head		list;
+	const char			*name;
+	struct tracecmd_input		*handle;
+};
+
+static struct list_head handle_list;
+
+static void add_handle(struct tracecmd_input *handle, const char *name)
+{
+	struct handle_list *item;
+
+	item = calloc(1, sizeof(*item));
+	if (!item)
+		die("Failed ot allocate");
+	item->handle = handle;
+	item->name = name;
+	list_add_tail(&item->list, &handle_list);
+}
+
 static int create_type_len(struct tep_handle *pevent, int time, int len)
 {
 	static int bigendian = -1;
@@ -450,6 +471,7 @@ void trace_split (int argc, char **argv)
 	char *output_file;
 	enum split_types split_type = SPLIT_NONE;
 	enum split_types type = SPLIT_NONE;
+	int instances;
 	int count;
 	int repeat = 0;
 	int percpu = 0;
@@ -457,6 +479,8 @@ void trace_split (int argc, char **argv)
 	int ac;
 	int c;
 
+	list_head_init(&handle_list);
+
 	if (strcmp(argv[1], "split") != 0)
 		usage(argv);
 
@@ -561,6 +585,26 @@ void trace_split (int argc, char **argv)
 		die("Failed to allocate for %s", output);
 	c = 1;
 
+	add_handle(handle, NULL);
+	instances = tracecmd_buffer_instances(handle);
+	if (instances) {
+		struct tracecmd_input *new_handle;
+		const char *name;
+		int i;
+
+		for (i = 0; i < instances; i++) {
+			name = tracecmd_buffer_instance_name(handle, i);
+			if (!name)
+				die("error in reading buffer instance");
+			new_handle = tracecmd_buffer_instance_handle(handle, i);
+			if (!new_handle) {
+				warning("could not retrieve handle %s", name);
+				continue;
+			}
+			add_handle(new_handle, name);
+		}
+	}
+
 	do {
 		if (repeat)
 			sprintf(output_file, "%s.%04d", output, c++);
-- 
2.25.1

