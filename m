Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E75C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 096FF20B1F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WjGT0pmm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgFRIxz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgFRIxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 04:53:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101F0C0613ED
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:53:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j198so6183669wmj.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cx4q++ePlBxJTLmksmUzmwFBy719IyRjHzqLxqqwIVM=;
        b=WjGT0pmmEnFsxgT6Ta+n/ZGPbHE9vPZeqp2VveyOqOAQPzpljx6o0l152lddX3Ez4F
         3//1yjZydAgoSFtZgfuICIeRM3A5+vFea8UHsVQyyz4AZvos+kl842t639CN4bdJIIQK
         OfMK86buJNtg4knnrqnXcxKEZlBkZh0XnklxvUoyR8o5fOdleGf9XRxY29rU+WfnhEev
         qQVBuKVl1u+y1/umvF9dJIYXloxaoZt7sgf1z6FeYhm9vKVlyVQXC3IDVDau2fRbU7FU
         JqqV0HFtoixC70T9DT1nZ0zbMHKPSEUABHVlrNCe2SVuIBwSk3Fzv6LT1O3kWBJiZ+2y
         fJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cx4q++ePlBxJTLmksmUzmwFBy719IyRjHzqLxqqwIVM=;
        b=IWzuArXY0MM9mF209CSAvMxXmCGHQonKPhjliU1RfAggFrWaF7QkDpQmCMaSQ2RULx
         +y0L/v9bD9tTuuQgF9pbw2z8rBQ2AUVrfzbwIfPlhWYqFJWR6bS74KwT4cTYXhKqaGFx
         2IvtnLnWEPefis7XBewHjY74dv4QwIh0y8rAR+WUU+4BNjGV3ycinVrIuT0Nk0vUA97s
         Wv3KNHtzL3Sq4voDjF34Aj6x11/4yZ1TPVh9Gx0m95osePpWbHb9I+qaCBm3l646x3hG
         Z2qxnyCcO70DG8knc2ZJvhBpU1V5ThRC1LgPrqxhNRQlE2PG+OGyPL91WOqcVEcxjWgP
         b86w==
X-Gm-Message-State: AOAM530H4krn0GCzWsRkIxIz8F7vELpkNdV8WElQfZ7ZrS/NlqEbWdYG
        sw3nub1k1RYQAKxQpyJa3QIjDRtY9RA=
X-Google-Smtp-Source: ABdhPJwU389SlCQ1E6KgynrIS5DEg0tnrvRvIL56JeWRqgrUAyVVRbZDZCH9kny+NuikxuzaeLQKSA==
X-Received: by 2002:a1c:3c89:: with SMTP id j131mr2841628wma.59.1592470417542;
        Thu, 18 Jun 2020 01:53:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a1sm2808231wmd.28.2020.06.18.01.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 01:53:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: [POC] Add APIs for extracting DWARF information from a file
Date:   Thu, 18 Jun 2020 11:53:32 +0300
Message-Id: <20200618085333.164150-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618085333.164150-1-tz.stoyanov@gmail.com>
References: <20200618085333.164150-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added initial infrastructure and trace-cmd library APIs for working with
DWARF debug information:
 trace_obj_debug_create()
 trace_obj_debug_destroy()
 trace_obj_debug_get_fileoffset()
These internal APIs utilize libdwarf and libbfd for parsing ELF and
DWARF headers of the files. The trace_obj_debug_get_fileoffset()
API retrieves the offset in the file of the given functions. These
offsets can be used to set a uprobes to the functions.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                                |  12 +
 lib/trace-cmd/Makefile                  |  17 ++
 lib/trace-cmd/include/trace-cmd-local.h |  13 +
 lib/trace-cmd/trace-obj-debug.c         | 348 ++++++++++++++++++++++++
 4 files changed, 390 insertions(+)
 create mode 100644 lib/trace-cmd/trace-obj-debug.c

diff --git a/Makefile b/Makefile
index 2f9620e4..d737b588 100644
--- a/Makefile
+++ b/Makefile
@@ -243,6 +243,18 @@ endif
 CUNIT_INSTALLED := $(shell if (echo -e "\#include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
+DWARF_INSTALLED := $(shell if (echo -e "\#include <libdwarf/libdwarf.h>\n void main(){dwarf_init(-1, 0, 0, 0, 0, 0);}" | $(CC) -xc - -ldwarf >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+export DWARF_INSTALLED
+BFD_INSTALLED := $(shell if (echo -e "\#include <bfd.h>\n void main(){bfd_init();}" | $(CC) -xc  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+export BFD_INSTALLED
+
+ifeq ($(BFD_INSTALLED), 1)
+LIBS += -lbfd
+endif
+ifeq ($(DWARF_INSTALLED), 1)
+LIBS += -ldwarf
+endif
+
 export CFLAGS
 export INCLUDES
 
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 666a1ebf..f8fb8390 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -24,6 +24,16 @@ endif
 OBJS += trace-blk-hack.o
 OBJS += trace-ftrace.o
 
+ifeq ($(BFD_INSTALLED), 1)
+ifeq ($(DWARF_INSTALLED), 1)
+OBJS += trace-obj-debug.o
+else
+$(warning libdwarf is not installed)
+endif
+else
+$(warning libbfd is not installed)
+endif
+
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
@@ -40,6 +50,13 @@ $(bdir)/libtracecmd.a: $(OBJS)
 
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
+ifeq ($(BFD_INSTALLED), 1)
+LIBS += -lbfd
+endif
+ifeq ($(DWARF_INSTALLED), 1)
+LIBS += -ldwarf
+endif
+
 $(bdir)/libtracecmd.so: $(OBJS)
 	$(Q)$(call do_compile_shared_library)
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 95dce66c..d4b31393 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -26,5 +26,18 @@ void warning(const char *fmt, ...);
 #endif
 #endif
 
+struct trace_obj_debug;
+struct trace_obj_symbols {
+	struct trace_obj_symbols *next;
+	char *name;	/* symbol name */
+	unsigned long long vma; /* symbol virtual memory address */
+	unsigned long long foffset; /* symbol file offset */
+};
+
+struct trace_obj_debug *trace_obj_debug_create(char *file);
+void trace_obj_debug_destroy(struct trace_obj_debug *obj);
+int trace_obj_debug_get_fileoffset(struct trace_obj_debug *obj,
+				   struct trace_obj_symbols *symbols);
+
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-obj-debug.c b/lib/trace-cmd/trace-obj-debug.c
new file mode 100644
index 00000000..80d626c8
--- /dev/null
+++ b/lib/trace-cmd/trace-obj-debug.c
@@ -0,0 +1,348 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <dwarf.h>
+#include <libdwarf/libdwarf.h>
+#include <bfd.h>
+#include "trace-cmd-local.h"
+#include "trace-cmd.h"
+
+struct trace_obj_debug {
+	Dwarf_Debug dwarf;
+	bfd *bfd;
+};
+
+static void dwarf_error_handler(Dwarf_Error error, Dwarf_Ptr errarg)
+{
+	warning("\nlibdwarf error detected: 0x%" DW_PR_DUx " %s\n",
+		dwarf_errno(error), dwarf_errmsg(error));
+}
+
+static int get_addr(Dwarf_Attribute attr, Dwarf_Addr *val)
+{
+	Dwarf_Error error = 0;
+	Dwarf_Addr uval = 0;
+	int res;
+
+	res = dwarf_formaddr(attr, &uval, &error);
+	if (res != DW_DLV_OK)
+		return -1;
+
+	*val = uval;
+	return 0;
+}
+
+static int dwarf_get_subprog(Dwarf_Debug dbg, Dwarf_Die die,
+			     struct trace_obj_symbols *data, const char *name)
+{
+	Dwarf_Attribute *attrbuf = 0;
+	Dwarf_Signed attrcount = 0;
+	Dwarf_Error error = 0;
+	Dwarf_Addr lowpc = 0;
+	Dwarf_Half aform;
+	Dwarf_Signed i;
+	int res;
+
+	res = dwarf_attrlist(die, &attrbuf, &attrcount, &error);
+	if (res != DW_DLV_OK)
+		return -1;
+	for (i = 0; i < attrcount ; ++i) {
+		res = dwarf_whatattr(attrbuf[i], &aform, &error);
+		if (res == DW_DLV_OK) {
+			if (aform == DW_AT_low_pc)
+				get_addr(attrbuf[i], &lowpc);
+		}
+		dwarf_dealloc(dbg, attrbuf[i], DW_DLA_ATTR);
+		if (lowpc)
+			break;
+	}
+
+	while (data) {
+		if (lowpc && !strcmp(name, data->name) && !data->vma)
+			data->vma = lowpc;
+		data = data->next;
+	}
+
+	dwarf_dealloc(dbg, attrbuf, DW_DLA_LIST);
+
+	return 0;
+}
+
+
+static int dwarf_get_die_data(Dwarf_Debug dbg, Dwarf_Die die,
+			      struct trace_obj_symbols *data)
+{
+	const char *formname = 0;
+	Dwarf_Attribute attr = 0;
+	const char *tagname = 0;
+	Dwarf_Half formnum = 0;
+	Dwarf_Error error = 0;
+	Dwarf_Half tag = 0;
+	char *name = NULL;
+	int res = 0;
+
+	res = dwarf_diename(die, &name, &error);
+	if (res == DW_DLV_ERROR) {
+		warning("Error in dwarf_diename: %s\n", dwarf_errmsg(error));
+		return -1;
+	}
+	if (res == DW_DLV_NO_ENTRY)
+		name = "<no DW_AT_name attr>";
+
+	res = dwarf_tag(die, &tag, &error);
+	if (res != DW_DLV_OK) {
+		warning("Error in dwarf_tag: %s n", dwarf_errmsg(error));
+		return -1;
+	}
+	res = dwarf_get_TAG_name(tag, &tagname);
+	if (res != DW_DLV_OK) {
+		warning("Error in dwarf_get_TAG_name: %s\n", dwarf_errmsg(error));
+		return -1;
+	}
+
+	res = dwarf_attr(die, DW_AT_name, &attr, &error);
+	if (res == DW_DLV_OK) {
+		res = dwarf_whatform(attr, &formnum, &error);
+		if (res != DW_DLV_OK) {
+			warning("Error in dwarf_whatform: %s\n",
+				dwarf_errmsg(error));
+			return -1;
+		}
+		formname = "form-name-unavailable";
+		res = dwarf_get_FORM_name(formnum, &formname);
+		if (res != DW_DLV_OK)
+			formname = "UNKNoWn FORM!";
+		dwarf_dealloc(dbg, attr, DW_DLA_ATTR);
+	}
+
+	if (tag == DW_TAG_subprogram)
+		dwarf_get_subprog(dbg, die, data, name);
+
+	return 0;
+}
+
+static void dwarf_get_die_and_siblings(Dwarf_Debug dbg, Dwarf_Die in_die,
+				       struct trace_obj_symbols *data)
+{
+	Dwarf_Die cur_die = in_die;
+	int res = DW_DLV_ERROR;
+	Dwarf_Error error = 0;
+	Dwarf_Die child = 0;
+	Dwarf_Die sib_die;
+
+	dwarf_get_die_data(dbg, in_die, data);
+	for (;;) {
+		sib_die = 0;
+		res = dwarf_child(cur_die, &child, &error);
+		if (res == DW_DLV_ERROR) {
+			warning("Error in dwarf_child: %s\n", dwarf_errmsg(error));
+			return;
+		}
+		if (res == DW_DLV_OK) {
+			dwarf_get_die_and_siblings(dbg, child, data);
+			/* No longer need 'child' die. */
+			dwarf_dealloc(dbg, child, DW_DLA_DIE);
+			child = 0;
+		}
+		/* res == DW_DLV_NO_ENTRY or DW_DLV_OK */
+		res = dwarf_siblingof_b(dbg, cur_die, 1, &sib_die, &error);
+		if (res == DW_DLV_ERROR) {
+			warning("Error in dwarf_siblingof_b :%s\n",
+				dwarf_errmsg(error));
+			return;
+		}
+		if (res == DW_DLV_NO_ENTRY)
+			break; /* Done at this level. */
+
+		if (cur_die != in_die) {
+			dwarf_dealloc(dbg, cur_die, DW_DLA_DIE);
+			cur_die = 0;
+		}
+		cur_die = sib_die;
+		dwarf_get_die_data(dbg, cur_die, data);
+	}
+}
+
+static int dwarf_read_all(Dwarf_Debug dwarf, struct trace_obj_symbols *data)
+{
+	Dwarf_Half header_cu_type = DW_UT_compile;
+	Dwarf_Unsigned cu_header_length = 0;
+	Dwarf_Unsigned next_cu_header = 0;
+	Dwarf_Unsigned abbrev_offset = 0;
+	Dwarf_Unsigned typeoffset = 0;
+	Dwarf_Half extension_size = 0;
+	Dwarf_Half version_stamp = 0;
+	Dwarf_Half address_size = 0;
+	Dwarf_Half offset_size = 0;
+	Dwarf_Sig8 signature;
+	Dwarf_Die no_die = 0;
+	Dwarf_Die cu_die = 0;
+	Dwarf_Error error;
+	Dwarf_Sig8 sig;
+	int number = 0;
+	int res;
+
+	for (;; ++number) {
+		no_die = 0;
+		cu_die = 0;
+		memset(&sig, 0, sizeof(sig));
+
+		res = dwarf_next_cu_header_d(dwarf, 1, &cu_header_length,
+					     &version_stamp, &abbrev_offset,
+					     &address_size, &offset_size,
+					     &extension_size, &signature,
+					     &typeoffset, &next_cu_header,
+					     &header_cu_type, &error);
+		if (res == DW_DLV_ERROR) {
+			warning("Error in dwarf_next_cu_header: %s\n",
+				dwarf_errmsg(error));
+			goto out_error;
+		}
+		if (res == DW_DLV_NO_ENTRY)
+			break;
+
+		res = dwarf_siblingof_b(dwarf, no_die, 1, &cu_die, &error);
+		if (res == DW_DLV_ERROR) {
+			warning("Error in dwarf_siblingof_b on CU die: %s\n",
+				dwarf_errmsg(error));
+			goto out_error;
+		}
+		if (res == DW_DLV_NO_ENTRY) {
+			warning("no entry! in dwarf_siblingof on CU die\n");
+			goto out_error;
+		}
+		dwarf_get_die_and_siblings(dwarf, cu_die, data);
+		dwarf_dealloc(dwarf, cu_die, DW_DLA_DIE);
+	}
+	return 0;
+
+out_error:
+	return -1;
+}
+
+static void bfd_dwarf_section(bfd *abfd, asection *section, void *param)
+{
+	struct trace_obj_symbols *data = (struct trace_obj_symbols *)param;
+
+	while (data) {
+		if ((section->flags & SEC_CODE) && section->vma <= data->vma &&
+		    (section->vma + section->size) > data->vma)
+			data->foffset = section->filepos + (data->vma - section->vma);
+
+		data = data->next;
+	}
+}
+
+static int bfd_process_object(bfd *abfd, struct trace_obj_symbols *data)
+{
+	int ret = 0;
+
+	if (bfd_check_format_matches(abfd, bfd_object, NULL) ||
+	    bfd_check_format_matches(abfd, bfd_core, NULL))
+		bfd_map_over_sections(abfd, bfd_dwarf_section, data);
+	else
+		ret = -1;
+
+	return ret;
+}
+
+static int bfd_read_all(bfd *handle, struct trace_obj_symbols *data)
+{
+	bfd *last_arfile = NULL;
+	bfd *arfile = NULL;
+	int ret = 0;
+
+	if (bfd_check_format(handle, bfd_archive)) {
+		for (;;) {
+			bfd_set_error(bfd_error_no_error);
+			arfile = bfd_openr_next_archived_file(handle, arfile);
+			if (arfile == NULL) {
+				if (bfd_get_error() != bfd_error_no_more_archived_files)
+					break;
+			}
+			ret = bfd_read_all(arfile, data);
+			if (last_arfile != NULL)
+				bfd_close(last_arfile);
+			last_arfile = arfile;
+		}
+		if (last_arfile != NULL)
+			bfd_close(last_arfile);
+	} else
+		ret = bfd_process_object(handle, data);
+
+	return ret;
+}
+
+/**
+ * trace_obj_debug_get_fileoffset - Get symbols VMA and file offset
+ * @obj - pointer to object, returned by trace_obj_debug_create()
+ * @symbols - link list with desired symbols
+ *
+ * Get VMA and file offset of the given symbols, using file debug information
+ * Return 0 on success, -1 on error
+ */
+int trace_obj_debug_get_fileoffset(struct trace_obj_debug *obj,
+				   struct trace_obj_symbols *symbols)
+{
+	int ret;
+
+	ret = dwarf_read_all(obj->dwarf, symbols);
+	if (!ret)
+		ret = bfd_read_all(obj->bfd, symbols);
+
+	return ret;
+}
+
+/**
+ * trace_symbols_destroy - Close file opened with trace_obj_debug_create()
+ * @obj - pointer to object, returned by trace_obj_debug_create()
+ *
+ * Close the file and free any allocated resources, related to file's debug
+ * information
+ */
+void trace_obj_debug_destroy(struct trace_obj_debug *obj)
+{
+	if (obj && obj->dwarf)
+		dwarf_finish(obj->dwarf, NULL);
+	if (obj && obj->bfd)
+		bfd_close(obj->bfd);
+	free(obj);
+}
+
+/**
+ * trace_obj_debug_create - Open binary file for parsing ELF and DWARF information
+ * @name: Name of the binary ELF file.
+ *
+ * Return pointer to trace_obj_debug structure, that can be passed to other APIs
+ * for extracting debug information from the file. NULL in case of an error.
+ */
+struct trace_obj_debug *trace_obj_debug_create(char *file)
+{
+	struct trace_obj_debug *obj = NULL;
+	Dwarf_Error dw_error;
+	int res;
+
+	obj = calloc(1, sizeof(*obj));
+	if (!obj)
+		return NULL;
+
+	res = dwarf_init_path(file, NULL, 0, DW_DLC_READ, DW_GROUPNUMBER_ANY,
+			      dwarf_error_handler, NULL, &obj->dwarf,
+			      0, 0, 0, &dw_error);
+	if (res != DW_DLV_OK)
+		goto error;
+	bfd_init();
+	obj->bfd = bfd_openr(file, NULL);
+	if (!obj->bfd)
+		goto error;
+	return obj;
+
+error:
+	trace_obj_debug_destroy(obj);
+	return NULL;
+}
-- 
2.26.2

