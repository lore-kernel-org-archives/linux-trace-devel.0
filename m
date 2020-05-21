Return-Path: <SRS0=eXyg=7D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB90C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 May 2020 10:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527A2206F6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 May 2020 10:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5J7kfUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgEUKzY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 May 2020 06:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgEUKzX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 May 2020 06:55:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B8AC061A0E
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 May 2020 03:55:23 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id d7so8245171eja.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 May 2020 03:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uJJDj51cyIqrTDRuS3jBt3VmZjADSoN2WV5yMZVIy1U=;
        b=d5J7kfUNq+/0o1Hfacac4eYFSiUH99DgPo5JEwR68oioTkni6UWtad8YNwjva8wZWh
         nGHQ6wouzLUWsP9V5VDykzbN+4AEb+bvsKMhe9hnLMrgVG4wzTMCtE/nI9wQnDkZOZMN
         1MX6igEo5YArZHUHIzLn1t0GgLjUD6b3erDGuuuFa7cbSqTqi8qkn2Dr6RbmkMpzvWYE
         dmWWUtErQt7ds0ZaKe9g3bHY5E/kXKZlFMWoFsgnadAUL6ALv2EV3ECG6Cxt4xVq5fuC
         HYyePPCUot4mghINel2jJaj+FjniE/m6BDmT6XTtrkdmZ8KXT2cDk3g/oX3gsq2n0kot
         MHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uJJDj51cyIqrTDRuS3jBt3VmZjADSoN2WV5yMZVIy1U=;
        b=gSVU1Kj/YZXA43tch465SVlsJyzFEDHUq+LlkZQJ+i5KzelpYt6pVUGKGPhSJ8QwHB
         jhVESW4sBvBKhWlhY9ZAJsBAKU9LX4TC0PlN6O8TGDKed5M1CThQW7vSgxP4yjfVbCKp
         I7e8r4Y6OWeY/X6EOSXykWJ+APt3TeTmCDkdXqbFJQ4ki6zPSgQRUGAinrUtaDjh/pcC
         lFl5gsaGyPMxjU2/QlYsRYujL/sstf0WPgdG81ELlG/9Wrvqy0cs7qkUi8UM/A40OEq+
         cmCwjQT4eG+n1O8FONBRwOLieusskwJGl+6GpctXR5m+N2R0u+m3EwXHk4buvSkaoMy+
         9nZQ==
X-Gm-Message-State: AOAM530VfE0fKvJG9CJWnpJxnFE1cMG37pR5eaRA5j0OA4k8obN5sX0k
        c8b/cfvucEkzbvP75rWKqvQcs3GQAfc=
X-Google-Smtp-Source: ABdhPJzRgR7iMekx9BNHZb8UB/yrByNhD1Bu611c9503u5N+uLTVCn2cNyCeWgJ/fYzrC8dAogeMbw==
X-Received: by 2002:a17:906:d10d:: with SMTP id b13mr2781674ejz.87.1590058521894;
        Thu, 21 May 2020 03:55:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c16sm4490836edv.88.2020.05.21.03.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 03:55:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: [POC] Add APIs for extracting DWARF information from a file
Date:   Thu, 21 May 2020 13:55:19 +0300
Message-Id: <20200521105519.31391-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
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
These APIs utilize libdwarf and libbfd for parsing ELF and DWARF headers
of the files. The trace_obj_debug_get_fileoffset() API retrieves the
offset in the file of the given functions. These offsets can be used to
set a uprobes to the functions.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                        |  12 ++
 include/trace-cmd/trace-cmd.h   |  14 ++
 lib/trace-cmd/Makefile          |  17 ++
 lib/trace-cmd/trace-obj-debug.c | 340 ++++++++++++++++++++++++++++++++
 4 files changed, 383 insertions(+)
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
 
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f3c95f30..5ad75b30 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -483,6 +483,20 @@ void tracecmd_plog(const char *fmt, ...);
 void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
+/* --- Object debug --- */
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
 /* --- System --- */
 unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ab7440ac..72d3864a 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -22,6 +22,16 @@ OBJS += trace-timesync.o
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
 
@@ -38,6 +48,13 @@ $(bdir)/libtracecmd.a: $(OBJS)
 
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
 
diff --git a/lib/trace-cmd/trace-obj-debug.c b/lib/trace-cmd/trace-obj-debug.c
new file mode 100644
index 00000000..e98185a4
--- /dev/null
+++ b/lib/trace-cmd/trace-obj-debug.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
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
+static void get_addr(Dwarf_Attribute attr, Dwarf_Addr *val)
+{
+	Dwarf_Error error = 0;
+	Dwarf_Addr uval = 0;
+	int res;
+
+	res = dwarf_formaddr(attr, &uval, &error);
+	if (res == DW_DLV_OK)
+		*val = uval;
+}
+
+static void dwarf_get_subprog(Dwarf_Debug dbg, Dwarf_Die die,
+			      struct trace_obj_symbols *data, const char *name)
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
+		return;
+	for (i = 0; i < attrcount ; ++i) {
+		res = dwarf_whatattr(attrbuf[i], &aform, &error);
+		if (res == DW_DLV_OK) {
+			if (aform == DW_AT_low_pc)
+				get_addr(attrbuf[i], &lowpc);
+		}
+		dwarf_dealloc(dbg, attrbuf[i], DW_DLA_ATTR);
+	}
+
+	while (data) {
+		if (lowpc && !strcmp(name, data->name))
+			data->vma = lowpc;
+		data = data->next;
+	}
+
+	dwarf_dealloc(dbg, attrbuf, DW_DLA_LIST);
+}
+
+
+static void dwarf_get_die_data(Dwarf_Debug dbg, Dwarf_Die die,
+			       struct trace_obj_symbols *data)
+{
+	const char *formname = 0;
+	Dwarf_Attribute attr = 0;
+	const char *tagname = 0;
+	Dwarf_Half formnum = 0;
+	Dwarf_Error error = 0;
+	Dwarf_Half tag = 0;
+	char *name = 0;
+	int res = 0;
+
+	res = dwarf_diename(die, &name, &error);
+	if (res == DW_DLV_ERROR) {
+		warning("Error in dwarf_diename: %s\n", dwarf_errmsg(error));
+		return;
+	}
+	if (res == DW_DLV_NO_ENTRY)
+		name = "<no DW_AT_name attr>";
+
+	res = dwarf_tag(die, &tag, &error);
+	if (res != DW_DLV_OK) {
+		warning("Error in dwarf_tag: %s n", dwarf_errmsg(error));
+		return;
+	}
+	res = dwarf_get_TAG_name(tag, &tagname);
+	if (res != DW_DLV_OK) {
+		warning("Error in dwarf_get_TAG_name: %s\n", dwarf_errmsg(error));
+		return;
+	}
+
+	res = dwarf_attr(die, DW_AT_name, &attr, &error);
+	if (res == DW_DLV_OK) {
+		res = dwarf_whatform(attr, &formnum, &error);
+		if (res != DW_DLV_OK) {
+			warning("Error in dwarf_whatform: %s\n",
+				dwarf_errmsg(error));
+			return;
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

