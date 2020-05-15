Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3196BC433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 05:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2E2206F1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 05:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNp4pmkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgEOFiB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 May 2020 01:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgEOFiB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 May 2020 01:38:01 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299AEC061A0C
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 22:37:59 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 82so767959lfh.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 May 2020 22:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBcBuG3kzJOeUxwwwvkZlp/VaSluBq2lswBgknykChc=;
        b=jNp4pmkw/8LXSfzfZ+oYDNLTrq5+Zy7XihCznn+zr+9qHrv7079DsuQefG1rAA7O+C
         OYXkEF165hP5Mm1snPNpF5TXNjwmlJ/QswzHo9tKfyPiPK/D3A20JI8wT1WDcw4d4J4v
         kBBGlEpPTLgJv4iKdsx/g/yWFWdqH8vYlkmAR2stPEzkUW+UgLEdSnqER+3CT+HgYBH5
         GlljSZpDk18SoBHQq6IZRLyRG7EIY3ktEocEgO5y78xt6UlKHmeq8JCqTD/nZ9bc/+Du
         /ninq7pv+qfPJYG35OWlcITaCeGn+3TIZpBq6l2YzaQVX2ee1OJMupbFL6OYC0d1Stsq
         rbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBcBuG3kzJOeUxwwwvkZlp/VaSluBq2lswBgknykChc=;
        b=P8dporax2lf/M6hrHIhy06hyoeOyBjUNTPlAhA4AVJ9lnH8ei2v+i4W3LbwaXwfIB1
         fTCHVxh0TaFS9jkQ4B/Ly68Kq5n+ihbS3LCyxUwoCFPLK1HAnLjv1u9ykLD/WyyMGxZd
         a4pfPFJwpfJ0RR+UioWRZYHyAr8aBy4So4LGMnWV9wa8ZYeCRPhSp2yG9RbHVcLZS2vN
         6dCVnVsNXAtJrMVzC4e5dkrql/V07nYdirgYXULw7GRUWhym2GUZg+aduzUl0C+JhZsM
         cGNSGClskn6CFUFacy8+6cPK3+esT9KKY3tlQwolevDCAQ5wPAelZZE9qdyvXIOloM5/
         xkMg==
X-Gm-Message-State: AOAM531L0SoH4YUdACcx3RJ/fH6JU9JBoqb6ccL0zGIDOFZj3CUmzf8/
        gljvcxxjPcUashc0/TirfBqifVAGtUM=
X-Google-Smtp-Source: ABdhPJwO6nVcin7yMlMm6MVOPLPhjK+ZB+INu/Aash/fUVDeakud5Crzjfj4OTz9w8LF76JIFWsoNQ==
X-Received: by 2002:a19:3804:: with SMTP id f4mr1133566lfa.121.1589521077440;
        Thu, 14 May 2020 22:37:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c4sm633842lfi.13.2020.05.14.22.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 22:37:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH v4] trace-cmd: Add support for more printk format specifiers
Date:   Fri, 15 May 2020 08:37:54 +0300
Message-Id: <20200515053754.3695335-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The printk format specifiers used in event's print format files extend
the standard printf formats. There are a lot of new options related to
printing pointers and kernel specific structures. Currently trace-cmd
does not support many of them.

Support for these new printk specifiers is added to the pretty_print()
function:
 - UUID/GUID address: %pU[bBlL]
 - Raw buffer as a hex string: %*ph[CDN]

These are improved:
 - MAC address: %pMF, %pM and %pmR
 - IPv4 adderss: %p[Ii]4[hnbl]

Function pretty_print() is refactored. The logic for printing pointers
%p[...] is moved to its own function.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207605
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
   - Small code style changes in print_mac_arg()
   - Check for file byte order instead of host byte order in
     parse_ip4_print_args()
v3 changes: 
   - Coding style fixes
   - Return back a check in case of %p and BSTRING argument
v4 changes:
   - Print poiners with "%p" insted of "0x%llx" in print_arg_pointer()
     default case.
---
 lib/traceevent/event-parse.c | 363 ++++++++++++++++++++++++++++-------
 1 file changed, 289 insertions(+), 74 deletions(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 064c100d..c28cbba3 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -4510,43 +4510,93 @@ get_bprint_format(void *data, int size __maybe_unused,
 	return format;
 }
 
-static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
-			  struct tep_event *event, struct tep_print_arg *arg)
+static int print_mac_arg(struct trace_seq *s, const char *format,
+			 void *data, int size, struct tep_event *event,
+			 struct tep_print_arg *arg)
 {
-	unsigned char *buf;
 	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
+	bool reverse = false;
+	unsigned char *buf;
+	int ret = 0;
 
 	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
-		return;
+		return 0;
 	}
 
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d",
 				 arg->type);
-		return;
+		return 0;
 	}
 
-	if (mac == 'm')
+	if (format[0] == 'm') {
 		fmt = "%.2x%.2x%.2x%.2x%.2x%.2x";
+	} else if (format[0] == 'M' && format[1] == 'F') {
+		fmt = "%.2x-%.2x-%.2x-%.2x-%.2x-%.2x";
+		ret++;
+	}
+	if (format[1] == 'R') {
+		reverse = true;
+		ret++;
+	}
+
 	if (!arg->field.field) {
 		arg->field.field =
 			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning_event(event, "%s: field %s not found",
 					 __func__, arg->field.name);
-			return;
+			return ret;
 		}
 	}
 	if (arg->field.field->size != 6) {
 		trace_seq_printf(s, "INVALIDMAC");
-		return;
+		return ret;
 	}
+
 	buf = data + arg->field.field->offset;
-	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
+	if (reverse)
+		trace_seq_printf(s, fmt, buf[5], buf[4], buf[3], buf[2], buf[1], buf[0]);
+	else
+		trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
+
+	return ret;
+}
+
+static int parse_ip4_print_args(struct tep_handle *tep,
+				const char *ptr, bool *reverse)
+{
+	int ret = 0;
+
+	*reverse = false;
+
+	/* hnbl */
+	switch (*ptr) {
+	case 'h':
+		if (tep->file_bigendian)
+			*reverse = false;
+		else
+			*reverse = true;
+		ret++;
+	break;
+	case 'l':
+		*reverse = true;
+		ret++;
+	break;
+	case 'n':
+	case 'b':
+		ret++;
+		/* fall through */
+	default:
+		*reverse = false;
+		break;
+	}
+
+	return ret;
 }
 
-static void print_ip4_addr(struct trace_seq *s, char i, unsigned char *buf)
+static void print_ip4_addr(struct trace_seq *s, char i, bool reverse, unsigned char *buf)
 {
 	const char *fmt;
 
@@ -4555,7 +4605,11 @@ static void print_ip4_addr(struct trace_seq *s, char i, unsigned char *buf)
 	else
 		fmt = "%d.%d.%d.%d";
 
-	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3]);
+	if (reverse)
+		trace_seq_printf(s, fmt, buf[3], buf[2], buf[1], buf[0]);
+	else
+		trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3]);
+
 }
 
 static inline bool ipv6_addr_v4mapped(const struct in6_addr *a)
@@ -4638,7 +4692,7 @@ static void print_ip6c_addr(struct trace_seq *s, unsigned char *addr)
 	if (useIPv4) {
 		if (needcolon)
 			trace_seq_printf(s, ":");
-		print_ip4_addr(s, 'I', &in6.s6_addr[12]);
+		print_ip4_addr(s, 'I', false, &in6.s6_addr[12]);
 	}
 
 	return;
@@ -4667,16 +4721,20 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
+	bool reverse = false;
 	unsigned char *buf;
+	int ret;
+
+	ret = parse_ip4_print_args(event->tep, ptr, &reverse);
 
 	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
-		return 0;
+		return ret;
 	}
 
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
-		return 0;
+		return ret;
 	}
 
 	if (!arg->field.field) {
@@ -4685,7 +4743,7 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
-			return 0;
+			return ret;
 		}
 	}
 
@@ -4693,11 +4751,12 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (arg->field.field->size != 4) {
 		trace_seq_printf(s, "INVALIDIPv4");
-		return 0;
+		return ret;
 	}
-	print_ip4_addr(s, i, buf);
 
-	return 0;
+	print_ip4_addr(s, i, reverse, buf);
+	return ret;
+
 }
 
 static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
@@ -4757,7 +4816,9 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 	char have_c = 0, have_p = 0;
 	unsigned char *buf;
 	struct sockaddr_storage *sa;
+	bool reverse = false;
 	int rc = 0;
+	int ret;
 
 	/* pISpc */
 	if (i == 'I') {
@@ -4772,6 +4833,9 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 			rc++;
 		}
 	}
+	ret = parse_ip4_print_args(event->tep, ptr, &reverse);
+	ptr += ret;
+	rc += ret;
 
 	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
@@ -4803,7 +4867,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 			return rc;
 		}
 
-		print_ip4_addr(s, i, (unsigned char *) &sa4->sin_addr);
+		print_ip4_addr(s, i, reverse, (unsigned char *) &sa4->sin_addr);
 		if (have_p)
 			trace_seq_printf(s, ":%d", ntohs(sa4->sin_port));
 
@@ -4837,25 +4901,20 @@ static int print_ip_arg(struct trace_seq *s, const char *ptr,
 			struct tep_print_arg *arg)
 {
 	char i = *ptr;  /* 'i' or 'I' */
-	char ver;
-	int rc = 0;
-
-	ptr++;
-	rc++;
+	int rc = 1;
 
-	ver = *ptr;
+	/* IP version */
 	ptr++;
-	rc++;
 
-	switch (ver) {
+	switch (*ptr) {
 	case '4':
-		rc += print_ipv4_arg(s, ptr, i, data, size, event, arg);
+		rc += print_ipv4_arg(s, ptr + 1, i, data, size, event, arg);
 		break;
 	case '6':
-		rc += print_ipv6_arg(s, ptr, i, data, size, event, arg);
+		rc += print_ipv6_arg(s, ptr + 1, i, data, size, event, arg);
 		break;
 	case 'S':
-		rc += print_ipsa_arg(s, ptr, i, data, size, event, arg);
+		rc += print_ipsa_arg(s, ptr + 1, i, data, size, event, arg);
 		break;
 	default:
 		return 0;
@@ -4864,6 +4923,133 @@ static int print_ip_arg(struct trace_seq *s, const char *ptr,
 	return rc;
 }
 
+static const int guid_index[16] = {3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15};
+static const int uuid_index[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
+
+static int print_uuid_arg(struct trace_seq *s, const char *ptr,
+			void *data, int size, struct tep_event *event,
+			struct tep_print_arg *arg)
+{
+	const int *index = uuid_index;
+	char *format = "%02x";
+	int ret = 0;
+	char *buf;
+	int i;
+
+	switch (*(ptr + 1)) {
+	case 'L':
+		format = "%02X";
+		/* fall through */
+	case 'l':
+		index = guid_index;
+		ret++;
+		break;
+	case 'B':
+		format = "%02X";
+		/* fall through */
+	case 'b':
+		ret++;
+		break;
+	}
+
+	if (arg->type == TEP_PRINT_FUNC) {
+		process_defined_func(s, data, size, event, arg);
+		return ret;
+	}
+
+	if (arg->type != TEP_PRINT_FIELD) {
+		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
+		return ret;
+	}
+
+	if (!arg->field.field) {
+		arg->field.field =
+			tep_find_any_field(event, arg->field.name);
+		if (!arg->field.field) {
+			do_warning("%s: field %s not found",
+				   __func__, arg->field.name);
+			return ret;
+		}
+	}
+
+	if (arg->field.field->size != 16) {
+		trace_seq_printf(s, "INVALIDUUID");
+		return ret;
+	}
+
+	buf = data + arg->field.field->offset;
+
+	for (i = 0; i < 16; i++) {
+		trace_seq_printf(s, format, buf[index[i]] & 0xff);
+		switch (i) {
+		case 3:
+		case 5:
+		case 7:
+		case 9:
+			trace_seq_printf(s, "-");
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
+			      void *data, int size, struct tep_event *event,
+			      struct tep_print_arg *arg, int print_len)
+{
+	int plen = print_len;
+	char *delim = " ";
+	int ret = 0;
+	char *buf;
+	int i;
+	unsigned long offset;
+	int arr_len;
+
+	switch (*(ptr + 1)) {
+	case 'C':
+		delim = ":";
+		ret++;
+		break;
+	case 'D':
+		delim = "-";
+		ret++;
+		break;
+	case 'N':
+		delim = "";
+		ret++;
+		break;
+	}
+
+	if (arg->type == TEP_PRINT_FUNC) {
+		process_defined_func(s, data, size, event, arg);
+		return ret;
+	}
+
+	if (arg->type != TEP_PRINT_DYNAMIC_ARRAY) {
+		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
+		return ret;
+	}
+
+	offset = tep_read_number(event->tep,
+				 data + arg->dynarray.field->offset,
+				 arg->dynarray.field->size);
+	arr_len = (unsigned long long)(offset >> 16);
+	buf = data + (offset & 0xffff);
+
+	if (arr_len < plen)
+		plen = arr_len;
+
+	if (plen < 1)
+		return ret;
+
+	trace_seq_printf(s, "%02x", buf[0] & 0xff);
+	for (i = 1; i < plen; i++)
+		trace_seq_printf(s, "%s%02x", delim, buf[i] & 0xff);
+
+	return ret;
+}
+
 static int is_printable_array(char *p, unsigned int len)
 {
 	unsigned int i;
@@ -4952,6 +5138,68 @@ void tep_print_fields(struct trace_seq *s, void *data,
 	}
 }
 
+static int print_function(struct trace_seq *s, const char *format,
+			  void *data, int size, struct tep_event *event,
+			  struct tep_print_arg *arg)
+{
+	struct func_map *func;
+	unsigned long long val;
+
+	val = eval_num_arg(data, size, event, arg);
+	func = find_func(event->tep, val);
+	if (func) {
+		trace_seq_puts(s, func->func);
+		if (*format == 'F' || *format == 'S')
+			trace_seq_printf(s, "+0x%llx", val - func->addr);
+	} else {
+		if (event->tep->long_size == 4)
+			trace_seq_printf(s, "0x%lx", (long)val);
+		else
+			trace_seq_printf(s, "0x%llx", (long long)val);
+	}
+
+	return 0;
+}
+
+static int print_pointer(struct trace_seq *s, const char *format, int plen,
+			 void *data, int size,
+			 struct tep_event *event, struct tep_print_arg *arg)
+{
+	unsigned long long val;
+	int ret = 1;
+
+	switch (*format) {
+	case 'F':
+	case 'f':
+	case 'S':
+	case 's':
+		ret += print_function(s, format, data, size, event, arg);
+		break;
+	case 'M':
+	case 'm':
+		ret += print_mac_arg(s, format, data, size, event, arg);
+		break;
+	case 'I':
+	case 'i':
+		ret += print_ip_arg(s, format, data, size, event, arg);
+		break;
+	case 'U':
+		ret += print_uuid_arg(s, format, data, size, event, arg);
+		break;
+	case 'h':
+		ret += print_raw_buff_arg(s, format, data, size, event, arg, plen);
+		break;
+	default:
+		ret = 0;
+		val = eval_num_arg(data, size, event, arg);
+		trace_seq_printf(s, "%p", (void *)val);
+		break;
+	}
+
+	return ret;
+
+}
+
 static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
 {
 	struct tep_handle *tep = event->tep;
@@ -4960,16 +5208,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 	struct tep_print_arg *args = NULL;
 	const char *ptr = print_fmt->format;
 	unsigned long long val;
-	struct func_map *func;
 	const char *saveptr;
 	struct trace_seq p;
 	char *bprint_fmt = NULL;
 	char format[32];
-	int show_func;
 	int len_as_arg;
 	int len_arg = 0;
 	int len;
 	int ls;
+	int ret;
 
 	if (event->flags & TEP_EVENT_FL_FAILED) {
 		trace_seq_printf(s, "[FAILED TO PARSE]");
@@ -5008,7 +5255,6 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 
 		} else if (*ptr == '%') {
 			saveptr = ptr;
-			show_func = 0;
 			len_as_arg = 0;
  cont_process:
 			ptr++;
@@ -5046,39 +5292,21 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 			case '-':
 				goto cont_process;
 			case 'p':
-				if (tep->long_size == 4)
-					ls = 1;
-				else
-					ls = 2;
-
-				if (isalnum(ptr[1]))
-					ptr++;
-
 				if (arg->type == TEP_PRINT_BSTRING) {
+					if (isalnum(ptr[1]))
+						ptr++;
 					trace_seq_puts(s, arg->string.string);
 					arg = arg->next;
 					break;
 				}
-
-				if (*ptr == 'F' || *ptr == 'f' ||
-				    *ptr == 'S' || *ptr == 's') {
-					show_func = *ptr;
-				} else if (*ptr == 'M' || *ptr == 'm') {
-					print_mac_arg(s, *ptr, data, size, event, arg);
-					arg = arg->next;
-					break;
-				} else if (*ptr == 'I' || *ptr == 'i') {
-					int n;
-
-					n = print_ip_arg(s, ptr, data, size, event, arg);
-					if (n > 0) {
-						ptr += n - 1;
-						arg = arg->next;
-						break;
-					}
-				}
-
-				/* fall through */
+				ret = print_pointer(s, ptr + 1,
+						    len_as_arg ? len_arg : 1,
+						    data, size,
+						    event, arg);
+				arg = arg->next;
+				if (ret > 0)
+					ptr += ret;
+				break;
 			case 'd':
 			case 'u':
 			case 'i':
@@ -5107,17 +5335,6 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 				val = eval_num_arg(data, size, event, arg);
 				arg = arg->next;
 
-				if (show_func) {
-					func = find_func(tep, val);
-					if (func) {
-						trace_seq_puts(s, func->func);
-						if (show_func == 'F')
-							trace_seq_printf(s,
-							       "+0x%llx",
-							       val - func->addr);
-						break;
-					}
-				}
 				if (tep->long_size == 8 && ls == 1 &&
 				    sizeof(long) != 8) {
 					char *p;
@@ -5125,8 +5342,6 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 					/* make %l into %ll */
 					if (ls == 1 && (p = strchr(format, 'l')))
 						memmove(p+1, p, strlen(p)+1);
-					else if (strcmp(format, "%p") == 0)
-						strcpy(format, "0x%llx");
 					ls = 2;
 				}
 				switch (ls) {
-- 
2.26.2

