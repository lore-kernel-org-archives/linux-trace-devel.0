Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B32BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Dec 2022 23:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiLBXGa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Dec 2022 18:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiLBXG3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Dec 2022 18:06:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6261BF28A4
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Dec 2022 15:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B2262412
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Dec 2022 23:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA2C433C1
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Dec 2022 23:06:27 +0000 (UTC)
Date:   Fri, 2 Dec 2022 18:06:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add tep_find_function_info()
Message-ID: <20221202180625.58262735@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

I needed a way to get the size of a function, and instead of creating
another function that gets the size (having to look up the function by
address again), I decided it would be better to have a single function
that retrieved the name, starting address and the size.

This implements tep_find_function_info() that does just that.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-func_find.txt | 51 +++++++++++++++++++++--
 include/traceevent/event-parse.h          |  3 ++
 src/event-parse.c                         | 37 ++++++++++++++++
 3 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtraceevent-func_find.txt b/Documentation/libtraceevent-func_find.txt
index 20982e91fa0b..26fac681fe8e 100644
--- a/Documentation/libtraceevent-func_find.txt
+++ b/Documentation/libtraceevent-func_find.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_find_function,tep_find_function_address - Find function name / start address.
+tep_find_function,tep_find_function_address,tep_find_function_info - Find function name / start address.
 
 SYNOPSIS
 --------
@@ -13,6 +13,8 @@ SYNOPSIS
 
 const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
 unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+int *tep_find_function_info*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_, const char pass:[**]_name_,
+			   unsigned long long pass:[*]_start_, unsigned long pass:[*]_size_);
 --
 
 DESCRIPTION
@@ -28,6 +30,11 @@ The *tep_find_function_address()* function returns the function start address,
 by given address _addr_. The _addr_ does not have to be exact, it will select the
 function that would contain it. The _tep_ argument is the trace event parser context.
 
+The *tep_find_function_info()* function retrieves the _name_, starting address (_start_),
+and the function text _size_ of the function at _address_, if it is found. Note,
+if the _tep_ handle has a function resolver (used by perf), then _size_ is set to
+zero.
+
 RETURN VALUE
 ------------
 The *tep_find_function()* function returns the function name, or NULL in case
@@ -36,6 +43,9 @@ it cannot be found.
 The *tep_find_function_address()* function returns the function start address,
 or 0 in case it cannot be found.
 
+The *tep_find_function_info()* function returns 1 if a function is found for the
+given address, or 0 if it is not.
+
 EXAMPLE
 -------
 [source,c]
@@ -44,12 +54,45 @@ EXAMPLE
 ...
 struct tep_handle *tep = tep_alloc();
 ...
-void show_function( unsigned long long addr)
+void show_function_name(unsigned long long addr)
+{
+	const char *fname = tep_find_function(tep, addr);
+
+	if (fname)
+		printf("Found function %s at 0x%0llx\n", fname, addr);
+	else
+		printf("No function found at 0x%0llx\n", addr);
+}
+
+void show_function_start_addr(unsigned long long addr)
 {
 	const char *fname = tep_find_function(tep, addr);
-	unsigned long long fstart = tep_find_function_address(tep, addr);
+	unsigned long long fstart;
+
+	if (!fname) {
+		printf("No function found at 0x%0llx\n", addr);
+		return;
+	}
+
+	fstart = tep_find_function_address(tep, addr);
+	printf("Function %s at 0x%llx starts at 0x%0llx\n",
+	       fname, addr, fstart);
+}
+
+void show_function_info(unsigned long long addr)
+{
+	const char *fname;
+	unsigned long long fstart;
+	unsigned long size;
+
+	ret = tep_find_function_info(tep, addr, &fname, &fstart, &size);
+	if (!ret) {
+		printf("No function found at 0x%0lx\n", addr);
+		return;
+	}
 
-	/* addr is in function named fname, starting at fstart address, at offset (addr - fstart) */
+	printf("Function %s at 0x%lx starts at 0x%0lx and is %ld in size\n",
+	       fname, addr, fstart, size);
 }
 ...
 --
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index f749cc2656ba..df307666abfa 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -527,6 +527,9 @@ struct tep_format_field *tep_find_any_field(struct tep_event *event, const char
 const char *tep_find_function(struct tep_handle *tep, unsigned long long addr);
 unsigned long long
 tep_find_function_address(struct tep_handle *tep, unsigned long long addr);
+int tep_find_function_info(struct tep_handle *tep, unsigned long long addr,
+			   const char **name, unsigned long long *start,
+			   unsigned long *size);
 unsigned long long tep_read_number(struct tep_handle *tep, const void *ptr, int size);
 int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value);
diff --git a/src/event-parse.c b/src/event-parse.c
index d842f9d4bbce..a6e9e936ac87 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -613,6 +613,43 @@ find_func(struct tep_handle *tep, unsigned long long addr)
 	return map;
 }
 
+/**
+ * tep_find_function_info - find a function by a given address
+ * @tep: a handle to the trace event parser context
+ * @addr: the address to find the function with
+ * @name: Return the name of the function (if found)
+ * @start: Return the start of the function (if found)
+ * @size: Return the size of the function (if found)
+ *
+ * Returns 1 if found, and 0 if it is not.
+ *  If found then @name will point to the name of the function.
+ *                @start: will contain the starting address of the function.
+ *                @size: will contain the size of the function.
+ */
+int tep_find_function_info(struct tep_handle *tep, unsigned long long addr,
+			   const char **name, unsigned long long *start,
+			   unsigned long *size)
+{
+	struct func_map *map;
+
+	map = find_func(tep, addr);
+	if (!map)
+		return 0;
+
+	if (name)
+		*name = map->func;
+	if (start)
+		*start = map->addr;
+	if (size) {
+		if (!tep->func_resolver)
+			*size = map[1].addr - map->addr;
+		else
+			*size = 0;
+	}
+
+	return 1;
+}
+
 /**
  * tep_find_function - find a function by a given address
  * @tep: a handle to the trace event parser context
-- 
2.35.1

