Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CCBC4320A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE9660EB5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhG3DD0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhG3DDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B4361059;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PR3-70; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 6/6] libtracefs: Add man pages for tracefs_event_append_filter()
Date:   Thu, 29 Jul 2021 23:03:07 -0400
Message-Id: <20210730030307.574270-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730030307.574270-1-rostedt@goodmis.org>
References: <20210730030307.574270-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add man pages for tracefs_event_append_filter() and
tracefs_event_verify_filter()

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-filter.txt | 329 ++++++++++++++++++++++++++++
 1 file changed, 329 insertions(+)
 create mode 100644 Documentation/libtracefs-filter.txt

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
new file mode 100644
index 000000000000..7e167bc8f34a
--- /dev/null
+++ b/Documentation/libtracefs-filter.txt
@@ -0,0 +1,329 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_event_append_filter, tracefs_event_verify_filter - Add and verify event filters
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int tracefs_event_append_filter(struct tep_event pass:[*]event, char pass:[**] filter,
+				 struct tracefs_filter type, const char pass:[*]field,
+				 enum tracefs_synth_compare compare, const char pass:[*]val);
+int tracefs_event_verify_filter(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
+
+--
+
+DESCRIPTION
+-----------
+*tracefs_event_append_filter*() is a way to create and verify event filters for
+a given event. It will verify that the _field_ belongs to the event and that
+the _compare_ option that is used is valid for the type of the field, as well
+as _val_. For the _type_ that is not of *TRACEFS_FILTER_COMPARE*, it will build
+the logical string and also make sure that the syntax is correct. For example,
+there are no more close parenthesis than open parenthesis. An AND (&&) or OR
+(||) is not misplaced, etc.
+
+*tracefs_synth_append_start_filter*() creates a filter or appends to it for the
+starting event. Depending on _type_, it will build a string of tokens for
+parenthesis or logic statemens, or it may add a comparison of _field_
+to _val_ based on _compare_.
+
+If _type_ is:
+*TRACEFS_FILTER_COMPARE*     -  See below
+*TRACEFS_FILTER_AND*         -  Append "&&" to the filter
+*TRACEFS_FILTER_OR*          -  Append "||" to the filter
+*TRACEFS_FILTER_NOT*         -  Append "!" to the filter
+*TRACEFS_FILTER_OPEN_PAREN*  -  Append "(" to the filter
+*TRACEFS_FILTER_CLOSE_PAREN* -  Append ")" to the filter
+
+_field_, _compare_, and _val_ are ignored unless _type_ is equal to
+*TRACEFS_FILTER_COMPARE*, then _compare will be used for the following:
+
+*TRACEFS_COMPARE_EQ* - _field_ == _val_
+
+*TRACEFS_COMPARE_NE* - _field_ != _val_
+
+*TRACEFS_COMPARE_GT* - _field_ > _val_
+
+*TRACEFS_COMPARE_GE* - _field_ >= _val_
+
+*TRACEFS_COMPARE_LT* - _field_ < _val_
+
+*TRACEFS_COMPARE_LE* - _field_ <pass:[=] _val_
+
+*TRACEFS_COMPARE_RE* - _field_ ~ "_val_" : where _field_ is a string.
+
+*TRACEFS_COMPARE_AND* - _field_ & _val_ : where _field_ is a flags field.
+
+*tracefs_event_verify_filter*() will parse _filter_ to make sure that the
+fields are for the _event_, and that the syntax is correct. If there's an
+error in the syntax, and _err_ is not NULL, then it will be allocated with an
+error message stating what was found wrong with the filter. _err_ must be freed
+with *free*().
+
+RETURN VALUE
+------------
+*tracefs_event_append_filter*() returns 0 on success and -1 on error.
+
+*tracefs_event_verify_filter*() returns 0 on success and -1 on error. if there
+is an error, and _errno_ is not *ENOMEM*, then _err_ is allocated and will
+contain a string describing what was found wrong with _filter_. _err_ must be
+freed with *free*().
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <stdio.h>
+#include <ctype.h>
+#include <tracefs.h>
+
+static void usage(char **argv)
+{
+	fprintf(stderr, "usage: %s [system] event filter\n", argv[0]);
+	exit(-1);
+}
+
+int main (int argc, char **argv)
+{
+	struct tep_handle *tep;
+	struct tep_event *event;
+	const char *system = NULL;
+	const char *event_name;
+	const char *filter;
+	char *new_filter = NULL;
+	char *err = NULL;
+	int i;
+
+	if (argc < 3)
+		usage(argv);
+
+	if (argc < 4) {
+		event_name = argv[1];
+		filter = argv[2];
+	} else {
+		system = argv[1];
+		event_name = argv[2];
+		filter = argv[3];
+	}
+
+	/* Load all events from the system */
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("tep");
+		exit(-1);
+	}
+
+	event = tep_find_event_by_name(tep, system, event_name);
+	if (!event) {
+		fprintf(stderr, "Event %s%s%s not found\n",
+			system ? system : "" , system ? " " : "",
+			event_name);
+		exit(-1);
+	}
+
+	if (tracefs_event_verify_filter(event, filter, &err) < 0) {
+		perror("tracecfs_event_verify_filter");
+		if (err)
+			fprintf(stderr, "%s", err);
+		free(err);
+		exit(-1);
+	}
+
+	for (i = 0; filter[i]; i++) {
+		char buf[strlen(filter)];
+		char *field = NULL;
+		char *val = NULL;
+		enum tracefs_filter type;
+		enum tracefs_compare compare = 0;
+		int start_i, n;
+		int quote;
+		bool backslash;
+
+		while (isspace(filter[i]))
+			i++;
+
+		switch(filter[i]) {
+		case '(':
+			type = TRACEFS_FILTER_OPEN_PAREN;
+			break;
+		case ')':
+			type = TRACEFS_FILTER_CLOSE_PAREN;
+			break;
+		case '!':
+			type = TRACEFS_FILTER_NOT;
+			break;
+		case '&':
+			type = TRACEFS_FILTER_AND;
+			i++;
+			break;
+		case '|':
+			type = TRACEFS_FILTER_OR;
+			i++;
+			break;
+		default:
+			type = TRACEFS_FILTER_COMPARE;
+
+			while (isspace(filter[i]))
+				i++;
+
+			start_i = i;
+			for (; filter[i]; i++) {
+				switch(filter[i]) {
+				case 'a' ... 'z':
+				case 'A' ... 'Z':
+				case '0' ... '9':
+				case '_':
+					continue;
+				}
+				break;
+			}
+
+			n = i - start_i;
+			field = buf;
+			strncpy(field, filter + start_i, n);
+			field[n++] = '\0';
+
+			val = buf + n;
+
+			while (isspace(filter[i]))
+				i++;
+
+			start_i = i;
+			switch(filter[i++]) {
+			case '>':
+				compare = TRACEFS_COMPARE_GT;
+				if (filter[i] == '=') {
+					i++;
+					compare = TRACEFS_COMPARE_GE;
+				}
+				break;
+			case '<':
+				compare = TRACEFS_COMPARE_LT;
+				if (filter[i] == '=') {
+					i++;
+					compare = TRACEFS_COMPARE_LE;
+				}
+				break;
+			case '=':
+				compare = TRACEFS_COMPARE_EQ;
+				i++;
+				break;
+			case '!':
+				compare = TRACEFS_COMPARE_NE;
+				i++;
+				break;
+			case '~':
+				compare = TRACEFS_COMPARE_RE;
+				break;
+			case '&':
+				compare = TRACEFS_COMPARE_AND;
+				break;
+			}
+
+			while (isspace(filter[i]))
+				i++;
+
+			quote = 0;
+			backslash = false;
+			start_i = i;
+			for (; filter[i]; i++) {
+				if (quote) {
+					if (backslash)
+						backslash = false;
+					else if (filter[i] == '\\')
+						backslash = true;
+					else if (filter[i] == quote)
+						quote = 0;
+					continue;
+				}
+				switch(filter[i]) {
+				case '"': case '\'':
+					quote = filter[i];
+					continue;
+				case 'a' ... 'z':
+				case 'A' ... 'Z':
+				case '0' ... '9':
+				case '_':
+					continue;
+				}
+				break;
+			}
+			n = i - start_i;
+			strncpy(val, filter + start_i, n);
+			val[n] = '\0';
+			break;
+		}
+		n = tracefs_event_append_filter(event, &new_filter, type,
+						field, compare, val);
+		if (n < 0) {
+			fprintf(stderr, "Failed making new filter:\n'%s'\n",
+				new_filter ? new_filter : "(null)");
+			exit(-1);
+		}
+	}
+
+	tep_free(tep);
+
+	printf("Created new filter: '%s'\n", new_filter);
+	free(new_filter);
+
+	exit(0);
+}
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_,
+_tracefs_hist_alloc(3)_,
+_tracefs_hist_free(3)_,
+_tracefs_hist_add_key(3)_,
+_tracefs_hist_add_value(3)_,
+_tracefs_hist_add_name(3)_,
+_tracefs_hist_start(3)_,
+_tracefs_hist_destory(3)_,
+_tracefs_hist_add_sort_key(3)_,
+_tracefs_hist_sort_key_direction(3)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.30.2

