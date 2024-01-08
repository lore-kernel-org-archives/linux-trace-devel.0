Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB456D6EC
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 18:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B1C433C7;
	Mon,  8 Jan 2024 18:18:07 +0000 (UTC)
Date: Mon, 8 Jan 2024 13:19:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH] libtracefs: Force off trace mmapping
Message-ID: <20240108131903.52b02897@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The libtracefs API for trace buffer memory mapping should be stable. But the
Linux kernel has not yet accepted the changes. There's a chance tha the kernel
API may change. In order to add the libtracefs API without depending on the API
being stable add it but always have it fail unless the code is built with:

  make EXTRA_FLAGS=-DFORCE_MMAP

Applications can start using the API and when it becomes available in the
kernel force disabling will be removed in a "fix" update to libtracefs. This
way if the Linux kernel API changes before it gets in, an application using an
older libtracefs will not break, as the mapping code will still silently fail
like it always has. For an application to work with the buffer mmap after it is
in the Linux kernel with a stable API, all it will need to do is update the
libtracefs to a version that has it enabled.

That is, the libtracefs API of:

 tracefs_cpu_open_mapped()
 tracefs_cpu_is_mapped()
 tracefs_cpu_map()
 tracefs_cpu_unmap()

Will still be applicable even if the Linux kernel changes how it does the
memory mapping when it is finally upstream.

The memory mapping can still be complied in by doing:

  make EXTRA_CFLAGS=-DFORCE_MMAP_ENABLE

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile           | 12 +++++++++---
 src/tracefs-mmap.c |  4 ++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e915e14..7a5b0c4 100644
--- a/Makefile
+++ b/Makefile
@@ -165,6 +165,12 @@ INCLUDES += -I$(src)/include/tracefs
 include $(src)/scripts/features.mk
 
 # Set compile option CFLAGS if not set elsewhere
+ifdef EXTRA_CFLAGS
+  CFLAGS ?= $(EXTRA_CFLAGS)
+else
+  CFLAGS ?= -g -Wall
+endif
+
 CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
@@ -172,15 +178,15 @@ LDFLAGS ?=
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit -o /dev/null >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
-export CFLAGS
-export INCLUDES
-
 # Append required CFLAGS
 override CFLAGS += -D_GNU_SOURCE $(LIBTRACEEVENT_INCLUDES) $(INCLUDES)
 
 # Make sure 32 bit stat() works on large file systems
 override CFLAGS += -D_FILE_OFFSET_BITS=64
 
+export CFLAGS
+export INCLUDES
+
 all: all_cmd
 
 LIB_TARGET  = libtracefs.a libtracefs.so.$(TRACEFS_VERSION)
diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index 5807453..0f90f51 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -61,6 +61,10 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
 	void *meta;
 	void *data;
 
+#ifndef FORCE_MMAP_ENABLE
+	return NULL;
+#endif
+
 	page_size = getpagesize();
 	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
 	if (meta == MAP_FAILED)
-- 
2.42.0

