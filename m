Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FC2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbhKVJd5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238782AbhKVJd5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:33:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9FD660F22;
        Mon, 22 Nov 2021 09:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573451;
        bh=hP680RPejy4hpfnwOZX4FIIohQjLSzMvLlvfRbWXKUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9KwL4DtyblQUimZ6FvG9ghWoxKaynog7nihH3X8AkEx585lKaJodKwMSMHimHoaq
         +VZSahw04rDslDb4ptHyGbd8b8G4SKvve7XpeGCo1BKBXC/0bmLdsV9+/RHFcpJv7/
         G0jajf98ynxd27csehVSZkiP8VzHXcEkJXqSBue8mb4d8AV2bxpNgu99mYc20K8RVE
         AjH58vmuPwBfgIXO75/MFQLWWhQt1cAZBP3YAtuf1UFXbzK4QzXd9loUw6DSvsapfU
         mruG7SMmVcA1y7s+0At6obAL1vu4j7zU4wrvp4wXZn48pmDYctbnGiB2+E7YSROLxy
         DLVjuBX2VVrKA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/5] tools/perf: Add '__rel_loc' event field parsing support
Date:   Mon, 22 Nov 2021 18:30:48 +0900
Message-Id: <163757344810.510314.12449413842136229871.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <163757340321.510314.9399950115238632705.stgit@devnote2>
References: <163757340321.510314.9399950115238632705.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new '__rel_loc' dynamic data location attribute support.
This type attribute is similar to the '__data_loc' but records the
offset from the field itself.
The libtraceevent adds TEP_FIELD_IS_RELATIVE to the
'tep_format_field::flags' with TEP_FIELD_IS_DYNAMIC for'__rel_loc'.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v2:
  - Use TEP_FIELD_IS_RELATIVE instead of TEP_FIELD_IS_REL_DYNAMIC.
---
 tools/perf/builtin-trace.c                         |    2 ++
 tools/perf/util/data-convert-bt.c                  |    2 ++
 tools/perf/util/evsel.c                            |    2 ++
 tools/perf/util/python.c                           |    2 ++
 .../perf/util/scripting-engines/trace-event-perl.c |    2 ++
 .../util/scripting-engines/trace-event-python.c    |    2 ++
 tools/perf/util/sort.c                             |    2 ++
 7 files changed, 14 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2bf21194c7b3..3752a75ff3fb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2722,6 +2722,8 @@ static size_t trace__fprintf_tp_fields(struct trace *trace, struct evsel *evsel,
 				offset = format_field__intval(field, sample, evsel->needs_swap);
 				syscall_arg.len = offset >> 16;
 				offset &= 0xffff;
+				if (field->flags & TEP_FIELD_IS_RELATIVE)
+					offset += field->offset + field->size;
 			}
 
 			val = (uintptr_t)(sample->raw_data + offset);
diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index aa862a26d95c..579962063185 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -318,6 +318,8 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 		offset = tmp_val;
 		len = offset >> 16;
 		offset &= 0xffff;
+		if (flags & TEP_FIELD_IS_RELATIVE)
+			offset += fmtf->offset + fmtf->size;
 	}
 
 	if (flags & TEP_FIELD_IS_ARRAY) {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dbfeceb2546c..4401a7916d17 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2597,6 +2597,8 @@ void *evsel__rawptr(struct evsel *evsel, struct perf_sample *sample, const char
 	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 		offset = *(int *)(sample->raw_data + field->offset);
 		offset &= 0xffff;
+		if (field->flags & TEP_FIELD_IS_RELATIVE)
+			offset += field->offset + field->size;
 	}
 
 	return sample->raw_data + offset;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 8feef3a05af7..5f6b28f68eae 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -416,6 +416,8 @@ tracepoint_field(struct pyrf_event *pe, struct tep_format_field *field)
 			offset  = val;
 			len     = offset >> 16;
 			offset &= 0xffff;
+			if (field->flags & TEP_FIELD_IS_RELATIVE)
+				offset += field->offset + field->size;
 		}
 		if (field->flags & TEP_FIELD_IS_STRING &&
 		    is_printable_array(data + offset, len)) {
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 32a721b3e9a5..a5d945415bbc 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -392,6 +392,8 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 			if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 				offset = *(int *)(data + field->offset);
 				offset &= 0xffff;
+				if (field->flags & TEP_FIELD_IS_RELATIVE)
+					offset += field->offset + field->size;
 			} else
 				offset = field->offset;
 			XPUSHs(sv_2mortal(newSVpv((char *)data + offset, 0)));
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c0c010350bc2..d1f1501ce7fc 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -942,6 +942,8 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				offset  = val;
 				len     = offset >> 16;
 				offset &= 0xffff;
+				if (field->flags & TEP_FIELD_IS_RELATIVE)
+					offset += field->offset + field->size;
 			}
 			if (field->flags & TEP_FIELD_IS_STRING &&
 			    is_printable_array(data + offset, len)) {
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 568a88c001c6..446b5252060a 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2385,6 +2385,8 @@ static int64_t __sort__hde_cmp(struct perf_hpp_fmt *fmt,
 		tep_read_number_field(field, a->raw_data, &dyn);
 		offset = dyn & 0xffff;
 		size = (dyn >> 16) & 0xffff;
+		if (field->flags & TEP_FIELD_IS_RELATIVE)
+			offset += field->offset + field->size;
 
 		/* record max width for output */
 		if (size > hde->dynamic_len)

