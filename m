Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336120CCE3
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Jul 2025 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753988142; cv=none; b=CYwpoePKJrMZKij14qcgS17Gj+KtOkygl7SQ/SwNy6gxQUCGIUUlT+WxFxtupUoYtmtN9M3TUqg1ujWGza9MR/Fie79HXvGgLz3Ea4EHKnVCP1665qK3XWn3qm44LgGtD1HkKctanlo61vh2J87V7BEnHwUVsd5mn64Bzgo6hSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753988142; c=relaxed/simple;
	bh=q3kaX/XDbGBGD25XBSKrBakbthbesq3jpPf9e3I/dJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmL699bl5i7W6DVFZ404otadZgjp7K7/SMymPxMo4jxvNWP2tCnnj+KutFSIwXZiqJM22z8QYOzFhsg6+f59Ty3OXJQgIGxfYBfXxQGFYGQDO5QHGreasXrcmNkE9vOnf20MkBIx1PCACbtIj7HG3YWmgrJh13kU6+g1TMpsQC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FEEC4CEEF;
	Thu, 31 Jul 2025 18:55:42 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1uhYRd-00000006tyY-1AVx;
	Thu, 31 Jul 2025 14:56:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceevent: Add man page for the new BTF functions
Date: Thu, 31 Jul 2025 14:52:34 -0400
Message-ID: <20250731185559.1644753-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250731185559.1644753-1-rostedt@goodmis.org>
References: <20250731185559.1644753-1-rostedt@goodmis.org>
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
 Documentation/libtraceevent-btf.txt | 158 ++++++++++++++++++++++++++++
 Documentation/libtraceevent.txt     |   5 +
 2 files changed, 163 insertions(+)
 create mode 100644 Documentation/libtraceevent-btf.txt

diff --git a/Documentation/libtraceevent-btf.txt b/Documentation/libtraceevent-btf.txt
new file mode 100644
index 000000000000..802d953a6ef1
--- /dev/null
+++ b/Documentation/libtraceevent-btf.txt
@@ -0,0 +1,158 @@
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
+		       int nmem, int size, const char pass:[*]_func_);
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
+The *tep_load_btf()* takes the _tep_ handle and will load the allocated _raw_data_
+into it. NOTE, the _raw_data_ must be allocated via glibc() allocations as on
+success, it will save the _raw_data_ internally, and will be freed when the
+_tep_ handler is destroyed. If it is called twice, it will free the old _raw_data_
+and reinitialize itself with the new _raw_data_. The _data_size_ should be set
+to the size of the content in _raw_data_.
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
+*tep_load_btf()* function returns 0 on success and the _raw_data_ is now
+owned by the _tep_ descriptor and will be freed when it is destroyed.
+It returns -1 on failure and the _raw_data_ will need to be freed by the caller.
+
+*tep_btf_print_args()* returns 0 on success and -1 on failure, which happens
+if the _size_ is not valid or the BTF file that was loaded is corrupted.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+int print_args(const char *func, unsigned long *args, int nr)
+{
+	struct tep_handle *tep;
+	struct trace_seq s;
+	struct stat st;
+	ssize_t r;
+	size_t tot = 0;
+	void *buf;
+	int fd;
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
+	buf = malloc(st.st_size);
+	if (!buf) {
+		close(fd);
+		return -1;
+	}
+
+	while (tot < st.size) {
+		r = read(fd, buf + tot, st.st_size - tot);
+		if (r <= 0)
+			break;
+		tot += r;
+	}
+	close(fd);
+
+	tep = tep_alloc();
+	if (!tep) {
+		free(buf);
+		return -1;
+	}
+
+	if (tep_load_btf(tep, buf, tot) < 0) {
+		free(buf);
+		return -1;
+	}
+
+	/* Now buf belongs to tep and does not need to be freed */
+
+	trace_seq_init(&s);
+
+	printf("%s(", func);
+	tep_btf_print_args(tep, &s, args, nr, sizeof(long), func);
+
+	/* This will also free buf */
+	tep_free(tep);
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
2.47.2

