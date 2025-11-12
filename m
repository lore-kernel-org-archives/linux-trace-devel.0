Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B39D25783C
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762984157; cv=none; b=ZYkplkGjThE2tp7VA2nDTEDuLrbgXzzp6DULU9hCOnmjOAYhFrui2/7wU/Gr6I4RWBPNPHXAON/DqoX3NF3pCNW0N/4sYxw3OAU26p8TWBU7qRa3K5SRdd6+lLRRWUnhQxTIzaCwsQNfVJapDtcM6EXuL+FjmzjCnbwE32i/A9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762984157; c=relaxed/simple;
	bh=H5C/Z6PiPsd4cMV1U/XQYK5p39hfdOQkaWU61psMXsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMf27TFzpq/jF6/ds19zeERUd+H+POaO5BAlO0KY9w4FsmWJf14Rori53UJ0ddOnI2Wo/3ejT5I3pIgfwnOLnPwVEGt4tqnQrb/YgFq1ceizT7QUXLRWRjcvouRNbUqJczIUVpSJxbAh2WPh+XhLtFqWCnDaDODdlL8N4foynYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC8CC19423;
	Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJIiY-00000001Dha-38Sg;
	Wed, 12 Nov 2025 16:49:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/4] libtraceevent: Add man page for the new BTF functions
Date: Wed, 12 Nov 2025 16:42:36 -0500
Message-ID: <20251112214929.290686-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112214929.290686-1-rostedt@goodmis.org>
References: <20251112214929.290686-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a man page for tep_load_btf() and tep_btf_print_args()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v2: https://lore.kernel.org/all/20250802024035.1893851-3-rostedt@goodmis.org/

- Updated the man page to not state the raw_data will become part of the
  tep handler, as the tep handler will now allocate its own.

- Use mmap() to load the btf kernel file.

- Make the example program a full featured program.

 Documentation/libtraceevent-btf.txt | 156 ++++++++++++++++++++++++++++
 Documentation/libtraceevent.txt     |   5 +
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/libtraceevent-btf.txt

diff --git a/Documentation/libtraceevent-btf.txt b/Documentation/libtraceevent-btf.txt
new file mode 100644
index 000000000000..d922f80ee27d
--- /dev/null
+++ b/Documentation/libtraceevent-btf.txt
@@ -0,0 +1,156 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_load_btf, tep_btf_print_args -
+Load BTF file and use it to pretty print function arguments.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_load_btf*(struct tep_handle pass:[*]_tep_, void pass:[*]_raw_data_, size_t _data_size_);
+int *tep_btf_print_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, void pass:[*]_args_,
+		       int _nmem_, int _size_, const char pass:[*]_func_);
+--
+
+DESCRIPTION
+-----------
+If the Linux kernel has BTF configured, then a binary file will exist
+in the path of */sys/kernel/btf/vmlinux*. If this file is read into memory
+and passed to *tep_load_btf()* function, then it will be used to parse
+the arguments of a given function, if that function data is found within
+the BTF file.
+
+The *tep_load_btf()* takes the _tep_ handle and will load the _raw_data_
+into it.  The _data_size_ should be set to the size of the content in _raw_data_.
+
+The *tep_btf_print_args()* takes a _tep_ handle, a trace_seq _s_ pointer
+(that was initialized by *trace_seq_init(3)*), an _args_ array that holds either
+4 byte or 8 byte values, the _nmem_ that is the number of values in the _args_
+parameter, a _size_ that is either 4 or 8 to denote the size of each value in _args_,
+and a _func_ string that is the name of the function to find the BTF information
+to use for parsing. If BTF is not loaded or the _func_ name is not found it
+will just print a hex value of all the _args_ into the _s_ descriptor.
+
+RETURN VALUE
+------------
+*tep_load_btf()* function returns 0 on success.  It returns -1 on failure and
+the _raw_data_ will need to be freed by the caller.
+
+*tep_btf_print_args()* returns 0 on success and -1 on failure, which happens
+if the _size_ is not valid or the BTF file that was loaded is corrupted.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <event-parse.h>
+
+int print_args(const char *func, unsigned long *args, int nr)
+{
+	struct tep_handle *tep = tep_alloc();
+	struct trace_seq s;
+	struct stat st;
+	void *buf;
+	int fd;
+	int ret;
+
+	if (!tep)
+		return -1;
+
+	fd = open("/sys/kernel/btf/vmlinux", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	if (fstat(fd, &st) < 0) {
+		close(fd);
+		return -1;
+	}
+
+	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (buf == MAP_FAILED) {
+		close(fd);
+		return -1;
+	}
+
+	ret = tep_load_btf(tep, buf, st.st_size);
+	munmap(buf, st.st_size);
+	close(fd);
+
+	if (ret < 0)
+		return -1;
+
+	trace_seq_init(&s);
+	trace_seq_printf(&s, "%s(", func);
+
+	tep_btf_print_args(tep, &s, args, nr, sizeof(long), func);
+
+	trace_seq_puts(&s, ")\n");
+	trace_seq_do_printf(&s);
+
+	tep_free(tep);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
+
+	print_args("getname_flags", args, 6);
+	return 0;
+}
+...
+The above may output:
+
+  getname_flags(filename=0x7ffe7d33f3d0, flags=0)
+
+If BTF is loaded and the function was found, or it may show:
+
+  getname_flags(7ffe7d33f3d0, 0, 0, 0, 0, 0)
+
+If it was not.
+...
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtraceevent*(3), *trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 9e7777283c52..5fb5fc19ffc1 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -166,6 +166,11 @@ KVM plugin calllbacks: (Defined by the application and complied with -rdynamic)
 				    unsigned long long pass:[*]paddr);
 	void *tep_plugin_kvm_put_func*(const char pass:[*]func);
 
+BTF parsing:
+	int *tep_load_btf*(struct tep_handle pass:[*]_tep_, void pass:[*]_raw_data_, size_t _data_size_);
+	int *tep_btf_print_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, void pass:[*]_args_,
+		       int nmem, int size, const char pass:[*]_func_);
+
 Trace sequences:
 *#include <trace-seq.h>*
 	void *trace_seq_init*(struct trace_seq pass:[*]_s_);
-- 
2.51.0

