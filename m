Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB02C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Nov 2021 17:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349835AbhK2RhY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 12:37:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34562 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhK2RfT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 12:35:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84395B8120F
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 17:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3E3C53FC7
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 17:31:59 +0000 (UTC)
Date:   Mon, 29 Nov 2021 12:31:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Rename tracefs_event_append/verify_filter()
 functions
Message-ID: <20211129123157.0ce043c3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The function names:

  tracefs_event_append_filter()
  tracefs_event_verify_filter()

Are confusing, as they do not actually affect the tep_event. What they do
is to create a filter string. Rename them to a more appropriate:

  tracefs_filter_string_append()
  tracefs_filter_string_verify()

We need to keep around the old names as they have been in a tagged
release. But move them to deprecated, and have them call the appropriate
names. Also remove the old name from the man pages.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-filter.txt | 18 ++++++++---------
 include/tracefs.h                   | 10 ++++++++++
 src/tracefs-filter.c                | 31 +++++++++++++++++++++--------
 3 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 14fb292..23a2abf 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_event_append_filter, tracefs_event_verify_filter - Add and verify event filters
+tracefs_filter_string_append, tracefs_filter_string_verify - Add and verify event filters
 
 SYNOPSIS
 --------
@@ -11,16 +11,16 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_event_append_filter(struct tep_event pass:[*]event, char pass:[**] filter,
+int tracefs_filter_string_append(struct tep_event pass:[*]event, char pass:[**] filter,
 				 struct tracefs_filter type, const char pass:[*]field,
 				 enum tracefs_synth_compare compare, const char pass:[*]val);
-int tracefs_event_verify_filter(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
+int tracefs_filter_string_verify(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
 
 --
 
 DESCRIPTION
 -----------
-*tracefs_event_append_filter*() is a way to create and verify event filters for
+*tracefs_filter_string_append*() is a way to create and verify event filters for
 a given event. It will verify that the _field_ belongs to the event and that
 the _compare_ option that is used is valid for the type of the field, as well
 as _val_. For the _type_ that is not of *TRACEFS_FILTER_COMPARE*, it will build
@@ -60,7 +60,7 @@ _field_, _compare_, and _val_ are ignored unless _type_ is equal to
 
 *TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
 
-*tracefs_event_verify_filter*() will parse _filter_ to make sure that the
+*tracefs_filter_string_verify*() will parse _filter_ to make sure that the
 fields are for the _event_, and that the syntax is correct. If there's an
 error in the syntax, and _err_ is not NULL, then it will be allocated with an
 error message stating what was found wrong with the filter. _err_ must be freed
@@ -68,9 +68,9 @@ with *free*().
 
 RETURN VALUE
 ------------
-*tracefs_event_append_filter*() returns 0 on success and -1 on error.
+*tracefs_filter_string_append*() returns 0 on success and -1 on error.
 
-*tracefs_event_verify_filter*() returns 0 on success and -1 on error. if there
+*tracefs_filter_string_verify*() returns 0 on success and -1 on error. if there
 is an error, and _errno_ is not *ENOMEM*, then _err_ is allocated and will
 contain a string describing what was found wrong with _filter_. _err_ must be
 freed with *free*().
@@ -128,7 +128,7 @@ int main (int argc, char **argv)
 		exit(-1);
 	}
 
-	if (tracefs_event_verify_filter(event, filter, &err) < 0) {
+	if (tracefs_filter_string_verify(event, filter, &err) < 0) {
 		perror("tracecfs_event_verify_filter");
 		if (err)
 			fprintf(stderr, "%s", err);
@@ -260,7 +260,7 @@ int main (int argc, char **argv)
 			val[n] = '\0';
 			break;
 		}
-		n = tracefs_event_append_filter(event, &new_filter, type,
+		n = tracefs_filter_string_append(event, &new_filter, type,
 						field, compare, val);
 		if (n < 0) {
 			fprintf(stderr, "Failed making new filter:\n'%s'\n",
diff --git a/include/tracefs.h b/include/tracefs.h
index 8b8b554..c9ebaa6 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -467,10 +467,20 @@ enum tracefs_synth_calc {
 	TRACEFS_SYNTH_ADD,
 };
 
+int tracefs_filter_string_append(struct tep_event *event, char **filter,
+				 enum tracefs_filter type,
+				 const char *field, enum tracefs_compare compare,
+				 const char *val);
+int tracefs_filter_string_verify(struct tep_event *event, const char *filter,
+				 char **err);
+
+/** Deprecated do not use: Instead use tracefs_filter_string_append() **/
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				enum tracefs_filter type,
 				const char *field, enum tracefs_compare compare,
 				const char *val);
+
+/** Deprecated do not use: Instead use tracefs_filter_string_verify()  **/
 int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 				char **err);
 
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index def8f68..e65fd94 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -338,7 +338,7 @@ __hidden int trace_append_filter(char **filter, unsigned int *state,
 }
 
 /**
- * tracefs_event_append_filter - create or append a filter for an event
+ * tracefs_filter_string_append - create or append a filter for an event
  * @event: tep_event to create / append a filter for
  * @filter: Pointer to string to append to (pointer to NULL to create)
  * @type: The type of element to add to the filter
@@ -387,10 +387,10 @@ __hidden int trace_append_filter(char **filter, unsigned int *state,
  *
  * Returns 0 on success and -1 on failure.
  */
-int tracefs_event_append_filter(struct tep_event *event, char **filter,
-				enum tracefs_filter type,
-				const char *field, enum tracefs_compare compare,
-				const char *val)
+int tracefs_filter_string_append(struct tep_event *event, char **filter,
+				 enum tracefs_filter type,
+				 const char *field, enum tracefs_compare compare,
+				 const char *val)
 {
 	unsigned int open_parens;
 	unsigned int state = 0;
@@ -623,7 +623,7 @@ static int get_val_end(const char *filter, int i, int *end)
 }
 
 /**
- * tracefs_event_verify_filter - verify a given filter works for an event
+ * tracefs_filter_string_verify - verify a given filter works for an event
  * @event: The event to test the given filter for
  * @filter: The filter to test
  * @err: Error message for syntax errors (NULL to ignore)
@@ -634,8 +634,8 @@ static int get_val_end(const char *filter, int i, int *end)
  * errors, @err will be allocated with an error message. It must
  * be freed with free().
  */
-int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
-				char **err)
+int tracefs_filter_string_verify(struct tep_event *event, const char *filter,
+				 char **err)
 {
 	enum tracefs_filter filter_type;
 	enum tracefs_compare compare;
@@ -745,3 +745,18 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 	free(str);
 	return 0;
 }
+
+/** Deprecated **/
+int tracefs_event_append_filter(struct tep_event *event, char **filter,
+				enum tracefs_filter type,
+				const char *field, enum tracefs_compare compare,
+				const char *val)
+{
+	return tracefs_filter_string_append(event, filter, type, field,
+					    compare, val);
+}
+int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
+				char **err)
+{
+	return tracefs_filter_string_verify(event, filter, err);
+}
-- 
2.31.1

