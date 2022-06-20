Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5438C43334
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jun 2022 20:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbiFTUpx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 16:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiFTUpw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 16:45:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 006B81A3BB
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Jun 2022 13:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655757948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u5292UcnH4GU0tAnV1jmJnXxOtT8/GpVBK3RDC3Ga7g=;
        b=Jb6VDfh+v323UR+Kzt5cp/BdRG5LtWzAcwHHuOUkYJAny93xd1fl8L5gNzqrlxVHTneALr
        PiNsEfQ38tCHcWIQkQ6bmKOlPFh0lJSMV1gNNKhtm0KN7XaKYt+NXqpMu5ws2C1zLqsVgS
        Irj/RxluKj6hygnpU71M9EqVKVi3k5w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-i7We4mKDP0eM9xgfeMKNNg-1; Mon, 20 Jun 2022 16:45:47 -0400
X-MC-Unique: i7We4mKDP0eM9xgfeMKNNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B678B802804
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Jun 2022 20:45:46 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CAD4456CD9;
        Mon, 20 Jun 2022 20:45:46 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     cluster-devel@redhat.com, aahringo@redhat.com
Subject: [PATCH/RFC] java: add initial bindings
Date:   Mon, 20 Jun 2022 16:45:39 -0400
Message-Id: <20220620204539.926948-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch adds basic java bindings for libtracecmd. It currently
supports very basic handling of parsing trace-cmd recorded trace files.
There might of course additional improvements regarding swig bindings and
the memory handling. E.g. in javas builtin iterator for-each handling
everything will keep in memory. The license for the high-level java
bindings jar file is LGPL-2.1 and is the same as libtracecmd.

The author of this patch created a java application that uses those java
bindings to trace locks and represent them in graphical GANTT diagram,
see [0].

You need to set the JAVA_HOME environment variable to let the Makefile know
that it builds the java bindings. This is somehow standard in the java world
as replacement for pkg-config or similar. There should no trace-cmd java
dependency, the recommended way should be to provide a kind of trace-cmd-java
package from your distribution containing the tracecmd.jar and
libctracecmdjava.so. This package would have then a java dependency to
e.g. OpenJDK, that I was using to test those bindings for.

The author is not a swig expert but it works as it currently is. Also
the author did not hit issues because memory _yet_. Those are beginning
experimental bindings and can be changed/improved in future.

[0] https://gitlab.com/netcoder/dlm2slog2
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 .gitignore                        |   4 +
 Makefile                          |  60 ++++++-
 java/Makefile                     |  39 +++++
 java/TraceCmd.java                | 236 +++++++++++++++++++++++++
 java/TraceCmdEvent.java           | 277 ++++++++++++++++++++++++++++++
 java/TraceCmdException.java       |  16 ++
 java/TraceCmdField.java           | 104 +++++++++++
 java/ctracecmdjava.i              | 180 +++++++++++++++++++
 java/example/Makefile             |   7 +
 java/example/TraceCmdExample.java |  33 ++++
 10 files changed, 953 insertions(+), 3 deletions(-)
 create mode 100644 java/Makefile
 create mode 100644 java/TraceCmd.java
 create mode 100644 java/TraceCmdEvent.java
 create mode 100644 java/TraceCmdException.java
 create mode 100644 java/TraceCmdField.java
 create mode 100644 java/ctracecmdjava.i
 create mode 100644 java/example/Makefile
 create mode 100644 java/example/TraceCmdExample.java

diff --git a/.gitignore b/.gitignore
index eb1b0db..586601a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,12 +10,16 @@
 .pc
 *~
 *.pyc
+*.class
+*.jar
 *.swp
 \#*\#
 patches/
 tc_version.h
 ks_version.h
 ctracecmd_wrap.c
+ctracecmdjava_wrap.c
+swig/
 ctracecmdgui_wrap.c
 tags
 TAGS
diff --git a/Makefile b/Makefile
index d72686d..eeafac9 100644
--- a/Makefile
+++ b/Makefile
@@ -89,6 +89,7 @@ export DESTDIR DESTDIR_SQ
 ifeq ($(prefix),$(HOME))
 plugin_tracecmd_dir = $(libdir)/trace-cmd/plugins
 python_dir ?= $(libdir)/trace-cmd/python
+java_dir ?= $(libdir)/trace-cmd/java
 var_dir = $(HOME)/.trace-cmd/
 else
 python_dir ?= $(libdir)/trace-cmd/python
@@ -96,6 +97,9 @@ PLUGIN_DIR_TRACECMD = -DPLUGIN_TRACECMD_DIR="$(plugin_tracecmd_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
 PLUGIN_DIR_TRACECMD_SQ = '$(subst ','\'',$(PLUGIN_DIR_TRACECMD))'
 PYTHON_DIR_SQ = '$(subst ','\'',$(PYTHON_DIR))'
+java_dir ?= $(libdir)/trace-cmd/java
+JAVA_DIR = -DJAVA_DIR="$(java_dir)"
+JAVA_DIR_JAR = '$(subst ','\'',$(JAVA_DIR))'
 var_dir = /var
 endif
 
@@ -104,6 +108,7 @@ bindir_SQ = $(subst ','\'',$(bindir))
 bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
 plugin_tracecmd_dir_SQ = $(subst ','\'',$(plugin_tracecmd_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
+java_dir_JAR = $(subst ','\'',$(java_dir))
 
 pound := \#
 
@@ -120,8 +125,11 @@ BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
 export PLUGIN_DIR_TRACECMD
 export PYTHON_DIR
 export PYTHON_DIR_SQ
+export JAVA_DIR
+export JAVA_DIR_JAR
 export plugin_tracecmd_dir_SQ
 export python_dir_SQ
+export java_dir_JAR
 export var_dir
 
 # copy a bit from Linux kbuild
@@ -139,6 +147,7 @@ SWIG_DEFINED := $(shell if command -v swig; then echo 1; else echo 0; fi)
 ifeq ($(SWIG_DEFINED), 0)
 BUILD_PYTHON := report_noswig
 NO_PYTHON = 1
+NO_JAVA = 1
 endif
 
 ifndef NO_PYTHON
@@ -160,6 +169,21 @@ endif # NO_PYTHON
 export BUILD_PYTHON_WORKS
 export NO_PYTHON
 
+ifndef NO_JAVA
+JAVA		:= tracecmd.jar
+
+ifeq ($(origin JAVA_HOME),undefined)
+	BUILD_JAVA := report_nojavadev
+	NO_JAVA = 1
+else
+	BUILD_JAVA := $(JAVA)
+	BUILD_JAVA_WORKS := 1
+endif
+endif # NO_JAVA
+
+export BUILD_JAVA_WORKS
+export NO_JAVA
+
 # $(call test-build, snippet, ret) -> ret if snippet compiles
 #                                  -> empty otherwise
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
@@ -375,7 +399,7 @@ override CFLAGS += $(PLUGIN_DIR_TRACECMD_SQ)
 override CFLAGS += $(udis86-flags) $(blk-flags) $(memfd-flags)
 override LDFLAGS += $(udis86-ldflags)
 
-CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
+CMD_TARGETS = trace-cmd $(BUILD_PYTHON) $(BUILD_JAVA)
 
 ###
 #    Default we just build trace-cmd
@@ -487,10 +511,13 @@ install_plugins: install_plugins_tracecmd
 install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
 
+install_java: force
+	$(Q)$(MAKE) -C $(src)/java $@
+
 install_bash_completion: force
 	$(Q)$(call do_install_data,$(src)/tracecmd/trace-cmd.bash,$(BASH_COMPLETE_DIR))
 
-install_cmd: all_cmd install_plugins install_python install_bash_completion
+install_cmd: all_cmd install_plugins install_python install_java install_bash_completion
 	$(Q)$(call do_install,$(obj)/tracecmd/trace-cmd,$(bindir_SQ))
 
 install: install_cmd
@@ -519,6 +546,7 @@ clean:
 	$(MAKE) -C $(src)/lib/trace-cmd/plugins clean
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/python clean
+	$(MAKE) -C $(src)/java clean
 	$(MAKE) -C $(src)/tracecmd clean
 
 define build_uninstall_script
@@ -554,7 +582,7 @@ uninstall_libs: $(BUILD_OUTPUT)/build_libs_uninstall
 
 report_noswig: force
 	$(Q)echo
-	$(Q)echo "    NO_PYTHON forced: swig not installed, not compiling python plugins"
+	$(Q)echo "    NO_PYTHON forced: swig not installed, not compiling python plugins or java bindings"
 	$(Q)echo
 
 report_nopythondev: force
@@ -562,6 +590,13 @@ report_nopythondev: force
 	$(Q)echo "    python-dev is not installed, not compiling python plugins"
 	$(Q)echo
 
+##### JAVA STUFF #####
+
+report_nojavadev: force
+	$(Q)echo
+	$(Q)echo "    JAVA_HOME env is not set, not compiling java bindings"
+	$(Q)echo
+
 ifndef NO_PYTHON
 PYTHON_INCLUDES = `$(PKG_CONFIG) --cflags $(PYTHON_PKGCONFIG_VERS)`
 PYTHON_LDFLAGS = `$(PKG_CONFIG) --libs $(PYTHON_PKGCONFIG_VERS)` \
@@ -583,6 +618,25 @@ ctracecmd.so: force $(LIBTRACECMD_STATIC)
 PHONY += python
 python: $(PYTHON)
 
+ifndef NO_JAVA
+JAVA_JAVAC = $(JAVA_HOME)/bin/javac
+JAVA_JAR = $(JAVA_HOME)/bin/jar
+JAVA_INCLUDES = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux
+else
+JAVA_JAVAC =
+JAVA_JAR =
+JAVA_INCLUDES =
+endif
+
+export JAVA_JAVAC
+export JAVA_JAR
+export JAVA_INCLUDES
+
+tracecmd.jar: force $(LIBTRACECMD_STATIC)
+	$(Q)$(MAKE) -C $(src)/java $@
+
+PHONY += java
+java: $(JAVA)
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
diff --git a/java/Makefile b/java/Makefile
new file mode 100644
index 0000000..7f34c9f
--- /dev/null
+++ b/java/Makefile
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0
+
+include $(src)/scripts/utils.mk
+
+ifdef BUILD_JAVA_WORKS
+JAVA_SO_INSTALL := libctracecmdjava.install
+JAVA_JAR_INSTALL := tracecmd.install
+endif
+
+root_pkgdir := tracecmd
+swigdir := swig
+jardir := jar
+
+SRCS := TraceCmd.java TraceCmdEvent.java TraceCmdException.java TraceCmdField.java
+
+libctracecmdjava.so: ctracecmdjava.i $(LIBTRACECMD_STATIC)
+	@mkdir -p $(swigdir)
+	swig -Wall -java -noproxy -package $(root_pkgdir).swig -I$(src)/include/trace-cmd $(LIBTRACEEVENT_CFLAGS) -outdir $(swigdir) ctracecmdjava.i
+	$(CC) -fpic -c $(JAVA_INCLUDES) $(CPPFLAGS) $(CFLAGS) ctracecmdjava_wrap.c
+	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmdjava_wrap.o -o libctracecmdjava.so $(TRACE_LIBS)
+
+tracecmd.jar: libctracecmdjava.so $(SRCS)
+	$(JAVA_JAVAC) -d . $(swigdir)/*.java *.java
+	$(JAVA_JAR) cf tracecmd.jar $(root_pkgdir)
+
+$(JAVA_SO_INSTALL): %.install : %.so force
+	$(Q)$(call do_install_data,$<,$(libdir_SQ))
+
+$(JAVA_JAR_INSTALL): %.install : %.jar force
+	$(Q)$(call do_install_data,$<,$(java_dir_JAR))
+
+install_java: $(JAVA_SO_INSTALL) $(JAVA_JAR_INSTALL)
+
+clean:
+	$(RM) *.jar *.a *.so *.o .*.d ctracecmdjava_wrap.*
+	$(RM) -r $(swigdir) tracecmd
+
+force:
+.PHONY: clean force
diff --git a/java/TraceCmd.java b/java/TraceCmd.java
new file mode 100644
index 0000000..cb24579
--- /dev/null
+++ b/java/TraceCmd.java
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Red Hat Inc, Alexander Aring <aahringo@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+package tracecmd;
+
+import java.math.BigInteger;
+import java.util.LinkedList;
+import java.io.IOException;
+import java.util.Iterator;
+import java.util.List;
+
+import tracecmd.swig.*;
+
+/**
+* Represents a trace instance of a trace file.
+*
+* @author Alexander Aring <aahringo@redhat.com>
+*
+*/
+public class TraceCmd implements Iterable<TraceCmdEvent>, AutoCloseable
+{
+	static { System.loadLibrary("ctracecmdjava"); }
+
+	private SWIGTYPE_p_tracecmd_input handle;
+	private SWIGTYPE_p_tep_handle pevent;
+	private List<TraceCmdEvent> events;
+	private BigInteger first_ts;
+	private Integer long_size;
+	private Integer cpus;
+
+	/**
+	 * Instantiate a TraceCmd Object to read a tracefile
+	 *
+	 * @param file relative or absolute filepath to the tracefile to read
+	 */
+	public TraceCmd(String file)
+	{
+		int rv;
+
+		this.handle = CTraceCmd.tracecmd_alloc(file, 0);
+		if (this.handle == null)
+			throw new TraceCmdException("Failed to alloc file: " + file);
+
+		/* 0 is TRACECMD_FILE_ALLOCATED */
+		rv = CTraceCmd.tracecmd_read_headers(this.handle, 0);
+		if (rv != 0)
+			throw new TraceCmdException("Failed to read headers of file: " + file);
+
+		rv = CTraceCmd.tracecmd_init_data(this.handle);
+		if (rv != 0)
+			throw new TraceCmdException("Failed to init data of file: " + file);
+
+		this.pevent = CTraceCmd.tracecmd_get_tep(this.handle);
+	}
+
+	/**
+	 * Get the number of CPUs recorded
+	 *
+	 * @return the number of CPUs recorded
+	 */
+	public Integer getCpus()
+	{
+		if (this.cpus != null)
+			return this.cpus;
+
+		this.cpus = CTraceCmd.tracecmd_cpus(this.handle);
+		return this.cpus;
+	}
+
+	/**
+	 * Get the size of a long for the recorded tracefile
+	 *
+	 * @return the size of a long type
+	 */
+	public Integer getLongSize()
+	{
+		if (this.long_size != null)
+			return this.long_size;
+
+		this.long_size = CTraceCmd.tracecmd_long_size(this.handle);
+		return this.long_size;
+	}
+
+	/**
+	 * Get the first recorded timestamp
+	 *
+	 * @return the first recorded timestamp
+	 */
+	public BigInteger getFirstTs()
+	{
+		if (this.first_ts != null)
+			return this.first_ts;
+
+		this.first_ts = CTraceCmd.tracecmd_get_first_ts(this.handle);
+		return this.first_ts;
+	}
+
+	/**
+	 * Read the next record and increment
+	 *
+	 * Returns null if end reached.
+	 *
+	 * @param cpu the CPU to pull from
+	 * @return the specifc event as a TraceCmdEvent object
+	 */
+	public TraceCmdEvent getEvent(Integer cpu)
+	{
+		SWIGTYPE_p_tep_event format;
+		SWIGTYPE_p_tep_record rec;
+		int type;
+
+		rec = CTraceCmd.tracecmd_read_data(this.handle, cpu);
+		if (rec == null)
+			return null;
+
+		type = CTraceCmd.tep_data_type(this.pevent, rec);
+		format = CTraceCmd.tep_find_event(this.pevent, type);
+
+		return new TraceCmdEvent(this.pevent, rec, format);
+	}
+
+	/**
+	 * Read a record from a specific offset
+	 *
+	 * @param offset the offset into the file to find the record
+	 * @return the specifc event as a TraceCmdEvent object
+	 */
+	public TraceCmdEvent getEventAt(BigInteger offset) throws TraceCmdException
+	{
+		SWIGTYPE_p_tep_event format;
+		SWIGTYPE_p_tep_record rec;
+		int type;
+
+		rec = CTraceCmd.tracecmd_read_at(this.handle, offset, null);
+		if (rec == null)
+			throw new TraceCmdException("Failed to read data at: " + offset);
+
+		type = CTraceCmd.tep_data_type(this.pevent, rec);
+		format = CTraceCmd.tep_find_event(this.pevent, type);
+
+		return new TraceCmdEvent(this.pevent, rec, format);
+	}
+
+	/**
+	 * Read the next record on any cpu.
+	 *
+	 * Returns null if end reached.
+	 *
+	 * @return the specifc event as a TraceCmdEvent object
+	 */
+	public TraceCmdEvent getNextEvent()
+	{
+		SWIGTYPE_p_tep_event format;
+		SWIGTYPE_p_tep_record rec;
+		int[] rec_cpu = { 0 };
+		int type;
+
+		rec = CTraceCmd.tracecmd_read_next_data(this.handle, rec_cpu);
+		if (rec == null)
+			return null;
+
+		type = CTraceCmd.tep_data_type(this.pevent, rec);
+		format = CTraceCmd.tep_find_event(this.pevent, type);
+
+		return new TraceCmdEvent(this.pevent, rec, format);
+	}
+
+
+	/**
+	 * Return the record at the current location by cpu iterator.
+	 *
+	 * Returns null if end reached.
+	 *
+	 * @param cpu the CPU to pull from
+	 * @return the specifc event as a TraceCmdEvent object
+	 */
+	public TraceCmdEvent peekEvent(Integer cpu)
+	{
+		SWIGTYPE_p_tep_event format;
+		SWIGTYPE_p_tep_record rec;
+		int type;
+
+		rec = CTraceCmd.tracecmd_peek_data_ref(this.handle, cpu);
+		if (rec == null)
+			return null;
+
+		type = CTraceCmd.tep_data_type(this.pevent, rec);
+		format = CTraceCmd.tep_find_event(this.pevent, type);
+
+		return new TraceCmdEvent(this.pevent, rec, format);
+	}
+
+	/**
+	 * Closes the TraceCmd handle.
+	 *
+	 * If not called AutoCloseable will take care about it.
+	 */
+	@Override
+	public void close()
+	{
+		CTraceCmd.tracecmd_close(this.handle);
+	}
+
+	/**
+	 * Iterator over all Events by using getNextEvent().
+	 *
+	 * Probably the best and easiest way to multiple times iterate
+	 * over all events in order of their timestamp. Note that all
+	 * events will be held in memory of TraceCmd lifetime.
+	 *
+	 * Just use for-each loop e.g. for (TraceCmdEvent e:new TraceCmd(...))
+	 *
+	 * @return iterator object
+	 */
+	@Override
+	public Iterator<TraceCmdEvent> iterator()
+	{
+		if (this.events == null) {
+			TraceCmdEvent e;
+
+			CTraceCmd.tracecmd_set_all_cpus_to_timestamp(this.handle, this.getFirstTs());
+			this.events = new LinkedList<TraceCmdEvent>();
+			e = this.getNextEvent();
+			while (e != null) {
+				this.events.add(e);
+				e = this.getNextEvent();
+			}
+		}
+
+		return this.events.listIterator();
+	}
+}
diff --git a/java/TraceCmdEvent.java b/java/TraceCmdEvent.java
new file mode 100644
index 0000000..ff8a12d
--- /dev/null
+++ b/java/TraceCmdEvent.java
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Red Hat Inc, Alexander Aring <aahringo@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+package tracecmd;
+
+import java.lang.ref.Cleaner;
+import java.math.BigInteger;
+import java.util.ArrayList;
+import java.util.HashSet;
+import java.util.List;
+import java.util.Set;
+
+import tracecmd.swig.*;
+
+/**
+* TraceCmdEvent represent a trace event.
+*
+* @author Alexander Aring <aahringo@redhat.com>
+*
+*/
+public class TraceCmdEvent implements AutoCloseable
+{
+	/* memory free handler */
+	private static final Cleaner cleaner = Cleaner.create();
+	private final Cleaner.Cleanable cleanable;
+	private final TraceCmdEventCleaner ec;
+
+	/* swig handlers */
+	private SWIGTYPE_p_tep_handle pevent;
+	private SWIGTYPE_p_tep_record record;
+	private SWIGTYPE_p_tep_event format;
+
+	/* caches attributes */
+	private Set<String> keys;
+	private BigInteger ts;
+	private String system;
+	private Integer type;
+	private String name;
+	private Integer cpu;
+	private String comm;
+	private Integer pid;
+
+	static class TraceCmdEventCleaner implements Runnable {
+		private SWIGTYPE_p_tep_record record;
+
+		public TraceCmdEventCleaner(SWIGTYPE_p_tep_record record) {
+			this.record = record;
+		}
+
+		@Override
+		public void run(){
+			CTraceCmd.tracecmd_free_record(this.record);
+		}
+	}
+
+	public TraceCmdEvent(SWIGTYPE_p_tep_handle pevent,
+			     SWIGTYPE_p_tep_record record,
+			     SWIGTYPE_p_tep_event format)
+	{
+		this.pevent = pevent;
+		this.record = record;
+		this.format = format;
+
+		this.ec = new TraceCmdEventCleaner(record);
+		this.cleanable = cleaner.register(this, this.ec);
+	}
+
+	/**
+	 * Freeing up a TraceCmdEvent object.
+	 *
+	 * If not called AutoCloseable will take care about it.
+	 */
+	@Override
+	public void close()
+	{
+		cleanable.clean();
+	}
+
+	/**
+	 * Get the trace system name of the trace event.
+	 *
+	 * @return the specific trace system as string
+	 */
+	public String getSystem()
+	{
+		if (this.system != null)
+			return this.system;
+
+		this.system = CTraceCmd.tracecmd_event_system_get(this.format);
+		return this.system;
+	}
+
+	/**
+	 * Get the trace event name.
+	 *
+	 * @return the specific trace event name as string
+	 */
+	public String getName()
+	{
+		if (this.name != null)
+			return this.name;
+
+		this.name = CTraceCmd.tracecmd_event_name_get(this.format);
+		return this.name;
+	}
+
+	/**
+	 * Get the trace event timestamp.
+	 *
+	 * @return the specific trace event timestamp in uptime nanoseconds.
+	 */
+	public BigInteger getTs()
+	{
+		if (this.ts != null)
+			return this.ts;
+
+		this.ts = CTraceCmd.tracecmd_record_ts_get(this.record);
+		return this.ts;
+	}
+
+	/**
+	 * Get the cpu on which the event was recorded on.
+	 *
+	 * @return the specific cpu which the event was record on.
+	 */
+	public Integer getCpu()
+	{
+		if (this.cpu != null)
+			return this.cpu;
+
+		this.cpu = CTraceCmd.tracecmd_record_cpu_get(this.record);
+		return this.cpu;
+	}
+
+	/**
+	 * Get the pid on which the event was recorded on.
+	 *
+	 * @return the specific pid which the event was record on.
+	 */
+	public Integer getPid()
+	{
+		if (this.pid != null)
+			return this.pid;
+
+		this.pid = CTraceCmd.tep_data_pid(this.pevent, this.record);
+		return this.pid;
+	}
+
+	public Integer getType()
+	{
+		if (this.type != null)
+			return this.type;
+
+		this.type = CTraceCmd.tep_data_type(this.pevent, this.record);
+		return this.type;
+	}
+
+	public String getComm()
+	{
+		if (this.comm != null)
+			return this.comm;
+
+		this.comm = CTraceCmd.tep_data_comm_from_pid(this.pevent, this.getPid());
+		return this.comm;
+	}
+
+	/**
+	 * Get a set of available keys for getField().
+	 *
+	 * @return a String set for specific keys.
+	 */
+	public Set<String> getKeys()
+	{
+		HashSet<String> ret = new HashSet<String>();
+		SWIGTYPE_p_tep_format_field f;
+
+		if (this.keys != null)
+			return this.keys;
+
+		f = CTraceCmd.tracecmd_event_format_fields_get(this.format);
+		while (f != null) {
+			ret.add(CTraceCmd.tracecmd_field_name_get(f));
+			f = CTraceCmd.tracecmd_field_next_get(f);
+		}
+
+		this.keys = ret;
+		return this.keys;
+	}
+
+	public List<String> getStack(Integer long_size) throws TraceCmdException
+	{
+		List<String> ret = new ArrayList<String>();
+		long[] addr = { 0 };
+		SWIGTYPE_p_void i;
+		String str;
+		int rv;
+
+		i = CTraceCmd.java_field_get_stack_init(this.record, this.format);
+		if (i == null)
+			throw new TraceCmdException("Failed to get stack data");
+
+		for (;;) {
+			rv = CTraceCmd.java_field_get_stack_check(this.record,
+								  this.format,
+								  i, long_size,
+								  addr);
+			if (rv == 1)
+				break;
+
+			str = CTraceCmd.java_field_get_stack_str(this.format, addr[0]);
+			if (str == null)
+				throw new TraceCmdException("Failed to get stack string");
+
+			ret.add(str);
+			i = CTraceCmd.java_field_get_stack_next(i, long_size);
+		}
+
+		return ret;
+	}
+
+	/**
+	 * Get a TraceCmdField object for a specific trace field.
+	 *
+	 * @param name the name of the field.
+	 * @return a TraceCmdField object which represent the event field.
+	 */
+	public TraceCmdField getField(String name) throws TraceCmdException
+	{
+		SWIGTYPE_p_tep_format_field f = CTraceCmd.tep_find_field(this.format, name);
+		if (f == null)
+			throw new TraceCmdException("Field not found: " + name);
+
+		return new TraceCmdField(this.record, f);
+	}
+
+	/**
+	 * Get a number value of a specific trace field.
+	 *
+	 * @param name the name of the field.
+	 * @return the number value.
+	 */
+	public BigInteger getNumField(String name)
+	{
+		return this.getField(name).getNum();
+	}
+
+	/**
+	 * Get a string value of a specific trace field.
+	 *
+	 * @param name the name of the field.
+	 * @return the string value.
+	 */
+	public String getStrField(String name)
+	{
+		return this.getField(name).toString();
+	}
+
+	/**
+	 * Get a string representation of the trace event.
+	 *
+	 * @param name the name of the field.
+	 * @return the string representation.
+	 */
+	@Override
+	public String toString()
+	{
+		BigInteger[] ts = this.getTs().divideAndRemainder(new BigInteger("1000000000"));
+
+		return String.format("%d.%09d CPU%d %s: pid=%d comm=%s type=%d",
+				     ts[0], ts[1], this.getCpu(), this.getName(),
+				     this.getPid(), this.getComm(), this.getType());
+	}
+}
diff --git a/java/TraceCmdException.java b/java/TraceCmdException.java
new file mode 100644
index 0000000..f17ac5d
--- /dev/null
+++ b/java/TraceCmdException.java
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Red Hat Inc, Alexander Aring <aahringo@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+package tracecmd;
+
+class TraceCmdException extends RuntimeException
+{
+	public TraceCmdException(String m)
+	{
+		super(m);
+	}
+}
diff --git a/java/TraceCmdField.java b/java/TraceCmdField.java
new file mode 100644
index 0000000..82079c4
--- /dev/null
+++ b/java/TraceCmdField.java
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Red Hat Inc, Alexander Aring <aahringo@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+package tracecmd;
+
+import java.math.BigInteger;
+
+import tracecmd.swig.*;
+
+/**
+* TraceCmdEventField represent a field of an trace event.
+*
+* @author Alexander Aring <aahringo@redhat.com>
+*
+*/
+public class TraceCmdField
+{
+	private SWIGTYPE_p_tep_format_field field;
+	private SWIGTYPE_p_tep_record record;
+
+	private Byte[] data;
+
+	public TraceCmdField(SWIGTYPE_p_tep_record record,
+			     SWIGTYPE_p_tep_format_field field)
+	{
+		this.record = record;
+		this.field = field;
+	}
+
+	/**
+	 * Get the field data as java byte array.
+	 *
+	 * @return the field data as byte array.
+	 */
+	public Byte[] getData() throws TraceCmdException
+	{
+		byte ret[];
+		int rv, i;
+
+		if (this.data != null)
+			return this.data;
+
+		/* get the length at first */
+		rv = CTraceCmd.java_field_get_data(this.field, this.record,
+						   new byte[0], 0);
+		if (rv < 0)
+			throw new TraceCmdException("Failed to get field data length, rv: " + rv);
+
+		ret = new byte[rv];
+		for (byte b:ret) {
+			b = 0;
+		}
+
+		rv = CTraceCmd.java_field_get_data(this.field, this.record,
+						   ret, rv);
+		if (rv < 0)
+			throw new TraceCmdException("Failed to get field data, rv: " + rv);
+
+		Byte[] byteObjects = new Byte[ret.length];
+		i = 0;
+		for (byte b:ret)
+			byteObjects[i++] = b;
+
+		this.data = byteObjects;
+		return this.data;
+	}
+
+	/**
+	 * Get the field data as BigInteger.
+	 *
+	 * @return the field data as BigInteger.
+	 */
+	public BigInteger getNum() throws TraceCmdException
+	{
+		BigInteger[] val = { new BigInteger("0") };
+		SWIGTYPE_p_void rd;
+
+		rd = CTraceCmd.tep_record_data_get(this.record);
+		if (rd == null)
+			throw new TraceCmdException("Failed to retrieve field data");
+
+		int rv = CTraceCmd.tep_read_number_field(this.field, rd, val);
+		if (rv != 0)
+			throw new TraceCmdException("Failed to read field number, rv: " + rv);
+
+		return val[0];
+	}
+
+	@Override
+	public String toString()
+	{
+		String ret;
+
+		ret = CTraceCmd.java_field_get_str(this.field, this.record);
+		if (ret == null)
+			throw new TraceCmdException("Failed to retrieve field string");
+
+		return ret;
+	}
+}
diff --git a/java/ctracecmdjava.i b/java/ctracecmdjava.i
new file mode 100644
index 0000000..3bf6654
--- /dev/null
+++ b/java/ctracecmdjava.i
@@ -0,0 +1,180 @@
+// tracecmdjava.i
+%module CTraceCmd
+%include "typemaps.i"
+%include "constraints.i"
+%include "various.i"
+
+%apply Pointer NONNULL { struct tracecmd_input *handle };
+%apply Pointer NONNULL { struct tep_handle *pevent };
+%apply Pointer NONNULL { struct tep_format_field * };
+%apply unsigned long long *OUTPUT {unsigned long long *}
+%apply unsigned long *OUTPUT {unsigned long *}
+%apply char *BYTE { char *buf };
+%apply int *OUTPUT {int *}
+
+%{
+#include "trace-cmd.h"
+#include "event-parse.h"
+#include "event-utils.h"
+%}
+
+%inline %{
+struct tracecmd_input *tracecmd_alloc(const char *file, int flags);
+int tracecmd_read_headers(struct tracecmd_input *handle, int state);
+int tracecmd_cpus(struct tracecmd_input *handle);
+int tracecmd_long_size(struct tracecmd_input *handle);
+struct tep_record *
+tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu);
+struct tep_record *
+tracecmd_peek_data(struct tracecmd_input *handle, int cpu);
+void tracecmd_set_all_cpus_to_timestamp(struct tracecmd_input *handle,
+					unsigned long long time);
+
+unsigned long long tracecmd_record_ts_get(struct tep_record *record)
+{
+	return record->ts;
+}
+
+int tracecmd_record_cpu_get(struct tep_record *record)
+{
+	return record->cpu;
+}
+
+const char *tracecmd_event_name_get(const struct tep_event *event)
+{
+	return event->name;
+}
+
+const char *tracecmd_event_system_get(const struct tep_event *event)
+{
+	return event->system;
+}
+
+static inline struct tep_record *
+tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
+{
+	struct tep_record *rec = tracecmd_peek_data(handle, cpu);
+	if (rec)
+		rec->ref_count++;
+	return rec;
+}
+
+char *java_field_get_str(struct tep_format_field *f, struct tep_record *r)
+{
+	if (!strncmp(f->type, "__data_loc ", 11)) {
+		unsigned long long val;
+		int offset;
+
+		if (tep_read_number_field(f, r->data, &val))
+			return NULL;
+
+		/*
+		 * The actual length of the dynamic array is stored
+		 * in the top half of the field, and the offset
+		 * is in the bottom half of the 32 bit field.
+		 */
+		offset = val & 0xffff;
+		return r->data + offset;
+	}
+
+	return r->data + f->offset;
+}
+
+int java_field_get_data(struct tep_format_field *f, struct tep_record *r,
+			char *buf, size_t len)
+{
+	unsigned long long val;
+	int size, offset;
+
+	if (!strncmp(f->type, "__data_loc ", 11)) {
+		if (tep_read_number_field(f, r->data, &val))
+			return -1;
+
+		/*
+		 * The actual length of the dynamic array is stored
+		 * in the top half of the field, and the offset
+		 * is in the bottom half of the 32 bit field.
+		 */
+		offset = val & 0xffff;
+		size = val >> 16;
+	} else {
+		offset = f->offset;
+		size = f->size;
+	}
+
+	if (len < size)
+		return size;
+
+	memcpy(buf, r->data + offset, len);
+	return len;
+}
+
+static void *java_field_get_stack_init(struct tep_record *record,
+				       struct tep_event *event)
+{
+	struct tep_format_field *field;
+	void *data = record->data;
+
+	field = tep_find_any_field(event, "caller");
+	if (!field)
+		return NULL;
+
+	return data + field->offset;
+}
+
+static int java_field_get_stack_check(struct tep_record *record,
+				      struct tep_event *event,
+				      void *data, int long_size,
+				      unsigned long *addr)
+{
+	int rv;
+
+	rv = data < record->data + record->size;
+	if (!rv)
+		return 1;
+
+	*addr = tep_read_number(event->tep, data, long_size);
+	rv = ((long_size == 8 && *addr == (unsigned long long)-1) ||
+	      ((int)*addr == -1));
+
+	return rv;
+}
+
+static void *java_field_get_stack_next(void *data, int long_size)
+{
+	return data + long_size;
+}
+
+static const char *java_field_get_stack_str(struct tep_event *event,
+					    unsigned long addr)
+{
+	return tep_find_function(event->tep, addr);
+}
+
+struct tep_format_field *tracecmd_event_format_fields_get(struct tep_event *event)
+{
+	return event->format.fields;
+}
+
+struct tep_format_field *tracecmd_field_next_get(struct tep_format_field *f)
+{
+	return f->next;
+}
+
+char *tracecmd_field_name_get(struct tep_format_field *f)
+{
+	return f->name;
+}
+%}
+
+%ignore trace_seq_vprintf;
+%ignore vpr_stat;
+
+/* SWIG can't grok these, define them to nothing */
+#define __trace
+#define __attribute__(x)
+#define __thread
+
+%include "trace-cmd.h"
+%include <trace-seq.h>
+%include <event-parse.h>
diff --git a/java/example/Makefile b/java/example/Makefile
new file mode 100644
index 0000000..f6308cb
--- /dev/null
+++ b/java/example/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+all:
+	$(JAVA_HOME)/bin/javac -classpath ../tracecmd.jar TraceCmdExample.java
+
+clean:
+	$(RM) *.class
diff --git a/java/example/TraceCmdExample.java b/java/example/TraceCmdExample.java
new file mode 100644
index 0000000..a6fef87
--- /dev/null
+++ b/java/example/TraceCmdExample.java
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Red Hat Inc, Alexander Aring <aahringo@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+import tracecmd.*;
+
+/**
+* Very small example how to use libtracecmd java bindings.
+*
+* Run as:
+*
+* $JAVA_HOME/bin/java -cp ../tracecmd.jar:. TraceCmdExample $TRACE.DAT
+*
+* @author Alexander Aring <aahringo@redhat.com>
+*
+*/
+public class TraceCmdExample
+{
+	public static final void main(String[] args)
+	{
+		TraceCmd t = new TraceCmd(args[0]);
+
+		System.out.println("First Timestamp: " + t.getFirstTs());
+		System.out.println("Amount of Cpus: " + t.getCpus());
+
+		for (TraceCmdEvent e:t) {
+			System.out.println(e);
+		}
+	}
+}
-- 
2.31.1

