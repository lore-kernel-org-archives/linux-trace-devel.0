Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90AAC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82CEC610FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhHJUsx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232783AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 473D861052;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hAT-AF; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 9/9] libtracefs: Add man pages for tracefs_hist_data functions
Date:   Tue, 10 Aug 2021 16:48:18 -0400
Message-Id: <20210810204818.880714-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add man pages for:

  tracefs_hist_data_parse()
  tracefs_hist_data_read()
  tracefs_hist_data_free()
  tracefs_hist_data_free_list()
  tracefs_hist_data_key_names()
  tracefs_hist_data_value_names()
  tracefs_hist_data_keys()
  tracefs_hist_data_values()
  tracefs_hist_data_next_bucket()
  tracefs_hist_data_first_bucket()

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist-data-2.txt | 346 +++++++++++++++++++++++
 Documentation/libtracefs-hist-data.txt   | 294 +++++++++++++++++++
 2 files changed, 640 insertions(+)
 create mode 100644 Documentation/libtracefs-hist-data-2.txt
 create mode 100644 Documentation/libtracefs-hist-data.txt

diff --git a/Documentation/libtracefs-hist-data-2.txt b/Documentation/libtracefs-hist-data-2.txt
new file mode 100644
index 000000000000..c5b11aaa650a
--- /dev/null
+++ b/Documentation/libtracefs-hist-data-2.txt
@@ -0,0 +1,346 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_hist_data_key_names, tracefs_hist_data_key_values, tracefs_hist_data_keys, tracefs_hist_data_values,
+tracefs_hist_data_next_bucket, tracefs_hist_data_first_bucket - Read an allocated tracefs_hist_data descriptor
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+
+char pass:[**]tracefs_hist_data_key_names(struct tracefs_hist_data pass:[*]hdata);
+char pass:[**]tracefs_hist_data_value_names(struct tracefs_hist_data pass:[*]hdata);
+
+const struct tracefs_hist_bucket_key pass:[*]tracefs_hist_data_keys(struct tracefs_hist_data pass:[*]hdata);
+const struct tracefs_hist_bucket_val pass:[*]tracefs_hist_data_values(struct tracefs_hist_data pass:[*]hdata);
+
+int tracefs_hist_data_next_bucket(struct tracefs_hist_data pass:[*]hdata);
+int tracefs_hist_data_first_bucket(struct tracefs_hist_data pass:[*]hdata);
+--
+
+DESCRIPTION
+-----------
+The _hist_ trigger for trace events will create a histogram that can be read in
+the trace event's _hist_ file. The file is human readable ASCII format, but that
+makes it difficult to process in programs. The *tracefs_hist_data_*pass:[*]()
+functions convert the histogram ASCII format into structures that can be processed
+and converted into tables.
+
+*tracefs_hist_data_key_names*() Returns an allocated list of strings containing the
+names of the keys in the order that they are saved in the list returned by
+*tracefs_hist_data_keys*(3). The _hdata_ is a _tracefs_hist_data_ descriptor that
+was created by either *tracefs_hist_data_parse*(3) or tracefs_hist_data_read*(3).
+
+*tracefs_hist_data_value_names*() Returns an allocated list of strings containing the
+names of the values in the order that they are saved in the list returned by
+*tracefs_hist_data_values*(3). The _hdata_ is a _tracefs_hist_data_ descriptor that
+was created by either *tracefs_hist_data_parse*(3) or *tracefs_hist_data_read*(3).
+
+*tracefs_hist_data_keys*() returns a link list of _tracefs_hist_data_bucket_key_
+descriptors that contain the content of the keys of the current bucket. Each key
+has its own descriptor, and the _key_->next will link to the next descriptor. The
+returned link list is an actual internal construct of the _tracefs_hist_data_
+and must not be modified or freed.
+
+*tracefs_hist_data_values*() returns a link list of _tracefs_hist_data_bucket_val_
+descriptors that contain the content of the values of the current bucket. Each value
+has its own descriptor, and the _value_->next will link to the next descriptor. The
+returned link list is an actual internal construct of the _tracefs_hist_data_
+and must not be modified or freed.
+
+After the _tracefs_hist_data_ has been created, it will keep track of the internal
+bucket, and this is not reentrant, so care must be taken when using with threads.
+The *tracefs_hist_data_keys*() or *tracefs_hist_data_values*() will return the list
+of keys or values respectively for the current bucket.
+
+*tracefs_hist_data_next_bucket*() will move the internal cursor of the _tracefs_hist_data_
+to the next bucket, where following this call, *tracefs_hist_data_keys*() and
+*tracefs_hist_data_values*() will return the keys and values from the new bucket.
+
+*tracefs_hist_data_first_bucket*() will reset the index such that following calls
+to *tracefs_hist_data_keys*() or tracefs_hist_data_values*() will return the link
+list of keys or values for the first bucket, and the list can be traversed again
+with *tracefs_hist_data_next_bucket*().
+
+RETURN VALUE
+------------
+*tracefs_hist_data_key_names*() on success, returns an allocated list of the names of the
+keys in _hdata_ and must be freed with *tracefs_list_free*(3). Returns NULL
+on failure.
+
+*tracefs_hist_data_value_names*() on success, returns an allocated list of the names of the
+values in _hdata_ and must be freed with *tracefs_list_free*(3). Returns NULL
+on failure.
+
+*tracefs_hist_data_keys*() on success, returns a link list of _tracefs_hist_bucket_key_ descriptors.
+Returns NULL on error.
+
+struct tracefs_hist_bucket_key {
+	struct tracefs_hist_bucket_key	*next;
+	unsigned int			flags;
+	union {
+		struct tracefs_hist_bucket_key_single	single;
+		struct tracefs_hist_bucket_key_range	range;
+	};
+};
+
+To traverse to the next key in the list, use the _key_->next, where the last key will have
+its _next_ pointer be NULL.
+
+If the flag TRACEFS_BUCKET_KEY_FL_SINGLE is set, then the "single" union structure should
+be used, otherwise the TRACEFS_BUCKET_KEY_FL_RANGE bit should be set.
+
+The other lower bits map to the type of the key, defined by the _tracefs_hist_key_type_ enum.
+
+struct tracefs_hist_bucket_key_single {
+	long long		val;
+	char			*sym;
+};
+
+Depending on the flags set, _val_ may be the integer representation of the _sym_.
+See the EXAMPLE below.
+
+struct tracefs_hist_bucket_key_range {
+	long long		start;
+	long long		end;
+};
+
+If the key is a range, then the tracefs_hist_bucket_key_range should be used
+to get the _start_ and _end_ values of that range inclusive.
+
+*tracefs_hist_data_next_bucket*() Returns -1 on error, 0 on succes and the
+cursor is pointing to the next bucket to read from, or 1 on success but there
+are on more buckets to read.
+
+*tracefs_hist_data_first_bucket*() Returns -1 on error, 0 on succes and the
+cursor is pointing to the next bucket to read from, or 1 on success but there
+are on more buckets to read.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+int main (int argc, char **argv)
+{
+	struct tracefs_hist_data *hdata;
+	const struct tracefs_hist_bucket_key *key;
+	const struct tracefs_hist_bucket_val *val;
+	char buf[BUFSIZ];
+	const char *buffer;
+	char *content = NULL;
+	char *file;
+	char *err;
+	char **key_names;
+	char **value_names;
+	int key_idx;
+	int val_idx;
+	FILE *fp;
+	size_t r;
+	bool done = false;
+	int buffer_size = 0;
+	int c;
+	int i;
+
+	for (;;) {
+		c = getopt(argc, argv, "hf:");
+		if (c == -1)
+			break;
+
+		switch(c) {
+		case 'h':
+			fprintf(stderr, "usage: %s [-f file]\n", argv[0]);
+			exit(0);
+		case 'f':
+			file = optarg;
+			break;
+		}
+	}
+
+	if (file) {
+		if (!strcmp(file, "-"))
+			fp = stdin;
+		else
+			fp = fopen(file, "r");
+		if (!fp) {
+			perror(file);
+			exit(-1);
+		}
+		while ((r = fread(buf, 1, BUFSIZ, fp)) > 0) {
+			content = realloc(content, buffer_size + r + 1);
+			strncpy(content + buffer_size, buf, r);
+			buffer_size += r;
+		}
+		fclose(fp);
+		if (buffer_size)
+			content[buffer_size] = '\0';
+	} else if (argc == optind) {
+		fprintf(stderr, "usage: %s [-f file]\n", argv[0]);
+		exit(-1);
+	} else {
+		for (i = optind; i < argc; i++) {
+			r = strlen(argv[i]);
+			content = realloc(content, buffer_size + r + 2);
+			if (i != optind)
+				content[buffer_size++] = ' ';
+			strcpy(content + buffer_size, argv[i]);
+			buffer_size += r;
+		}
+	}
+
+	buffer = content;
+	hdata = tracefs_hist_data_parse(buffer, &buffer, &err);
+	printf("hdata = %p\n", hdata);
+	if (!hdata && err) {
+		printf("%s\n", err);
+		exit(-1);
+	}
+
+	key_names = tracefs_hist_data_key_names(hdata);
+	if (!key_names) {
+		perror("key_names");
+		exit(-1);
+	}
+
+	value_names = tracefs_hist_data_value_names(hdata);
+	if (!value_names) {
+		perror("value_names");
+		exit(-1);
+	}
+
+	do {
+		bool first = true;
+		key = tracefs_hist_data_keys(hdata);
+		val = tracefs_hist_data_values(hdata);
+		key_idx = 0;
+		val_idx = 0;
+
+		if (!key || !val) {
+			perror("keys or vals");
+			exit(-1);
+		}
+
+		while (key) {
+			if (!first)
+				printf(",");
+			first = false;
+			if (key_names[key_idx])
+				printf("%s:", key_names[key_idx++]);
+			else
+				printf("(\?\?):");
+			if (key->flags & TRACEFS_BUCKET_KEY_FL_UNDEF) {
+				fprintf(stderr, "bad key type?");
+				exit (-1);
+			} else if (key->flags & TRACEFS_BUCKET_KEY_FL_SINGLE) {
+
+				if (key->flags &
+				    ((1 << TRACEFS_HIST_KEY_SYM) |
+				     (1 << TRACEFS_HIST_KEY_SYM_OFFSET) |
+				     (1 << TRACEFS_HIST_KEY_SYSCALL) |
+				     (1 << TRACEFS_HIST_KEY_EXECNAME)))
+					printf("%s [ %lld ]",
+					       key->single.sym,
+					       key->single.val);
+				else
+					printf("%s", key->single.sym);
+
+			} else if  (key->flags & TRACEFS_BUCKET_KEY_FL_RANGE)
+				printf("%lld - %lld",
+				       key->range.start,
+				       key->range.end);
+			key = key->next;
+		}
+		printf(":");
+		first = true;
+		while (val) {
+			if (!first)
+				printf(",");
+			first = false;
+			if (value_names[val_idx])
+				printf("%s:", value_names[val_idx++]);
+			else
+				printf("(\?\?):");
+			printf("%lld", val->val);
+			val = val->next;
+		}
+		printf("\n");
+		if (tracefs_hist_data_next_bucket(hdata))
+			done = true;
+	} while (!done);
+
+	tracefs_list_free(key_names);
+	tracefs_list_free(value_names);
+	tracefs_hist_data_free(hdata);
+
+	return 0;
+}
+--
+
+BUGS
+----
+There are some known values that the histograms can produce that will break
+the parsing. Those are any string value that contains a comma (,) or a
+colon (:) may cause the parse to misinterpret the parsing and fail to parse.
+This may be fixed in the future.
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
+_tracefs_hist_data_parse(3)_
+_tracefs_hist_data_read(3)_
+_tracefs_hist_data_free(3)_
+_tracefs_hist_data_free_list(3)_
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
diff --git a/Documentation/libtracefs-hist-data.txt b/Documentation/libtracefs-hist-data.txt
new file mode 100644
index 000000000000..1890eabb7cd1
--- /dev/null
+++ b/Documentation/libtracefs-hist-data.txt
@@ -0,0 +1,294 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_hist_data_parse, tracefs_hist_data_read, tracefs_hist_data_free, tracefs_hist_data_free_list - Read and parse hist format files
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_hist_data pass:[*]tracefs_hist_data_parse(const char pass:[*]buffer,
+						  const char pass:[**]next_buffer,
+						  char pass:[**]err);
+
+struct tracefs_hist_data pass:[**]tracefs_hist_data_read(struct tracefs_instance pass:[*]instance,
+						  const char pass:[*]system,
+						  const char pass:[*]event,
+						  char pass:[**]err);
+
+void tracefs_hist_data_free(struct tracefs_hist_data pass:[*]hdata);
+void tracefs_hist_data_free_list(struct tracefs_hist_data pass:[**]hdata_list);
+--
+
+DESCRIPTION
+-----------
+The _hist_ trigger for trace events will create a histogram that can be read in
+the trace event's _hist_ file. The file is human readable ASCII format, but that
+makes it difficult to process in programs. The *tracefs_hist_data_*pass:[*]()
+functions convert the histogram ASCII format into structures that can be processed
+and converted into tables.
+
+*tracefs_hist_data_parse*() will read a string buffer that contains the contents
+of a trace_event hist file in _buffer_, and allocate and create a _tracefs_hist_data_
+descriptor. If there are more than one histograms in _buffer_, and _next_buffer_ is
+not NULL, it will then be set to the location of _buffer_ that contains the next
+histogram. _next_buffer_ may be a pointer to _buffer_ as it will not be updated
+until after the histogram is fully parsed. The _tracefs_trace_data_ returned must
+be freed with *tracefs_hist_data_free*().
+
+*tracefs_hist_data_read*() will read the "hist" file of the given trace event
+that is located in the _instance_ directory or the top level directory if _instance_ is NULL.
+The trace event is found with the _system_ and _event_ names, where _system_ can be
+NULL, and the first trace event with _event_ as its name will be used.
+It returns an array of _tracefs_hist_data_ structures or NULL on error. The
+array ends with a pointer to NULL. The reason for the array is because _hist_ files
+may contain more than one histogram, and this will return an array that has all the
+histograms in the _hist_ file parsed. The array can be freed with *tracefs_hist_data_free_list*()
+or each individual _tracefs_hist_data_ may be freed with *tracefs_hist_data_free*() and the
+array itself freed with *free*().
+
+*tracefs_hist_data_free*() frees a _tracefs_hist_data_ descriptor that was created
+with *tracefs_hist_data_parse*().
+
+*tracefs_hist_data_free_list*() frees an array of _tracefs_hist_data_ descriptors that was created
+with *tracefs_hist_data_read*().
+
+RETURN VALUE
+------------
+*tracefs_hist_data_parse*() returns an allocated _tracefs_hist_data_ descriptor. Or
+NULL on error, and if it was a parsing error and _err_ is not NULL, it will be set to
+an allocated string describing the error. _err_ must be freed with *free*().
+
+*tracefs_hist_data_read*() returns an allocated array of allocated _tracefs_hist_data_
+descriptors. Or NULL on error, and if it was a parsing error and _err_ is not NULL,
+it will be set to an allocated string describing the error. _err_ must be freed with *free*().
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+int main (int argc, char **argv)
+{
+	struct tracefs_hist_data *hdata;
+	const struct tracefs_hist_bucket_key *key;
+	const struct tracefs_hist_bucket_val *val;
+	char buf[BUFSIZ];
+	const char *buffer;
+	char *content = NULL;
+	char *file;
+	char *err;
+	char **key_names;
+	char **value_names;
+	int key_idx;
+	int val_idx;
+	FILE *fp;
+	size_t r;
+	bool done = false;
+	int buffer_size = 0;
+	int c;
+	int i;
+
+	for (;;) {
+		c = getopt(argc, argv, "hf:");
+		if (c == -1)
+			break;
+
+		switch(c) {
+		case 'h':
+			fprintf(stderr, "usage: %s [-f file]\n", argv[0]);
+			exit(0);
+		case 'f':
+			file = optarg;
+			break;
+		}
+	}
+
+	if (file) {
+		if (!strcmp(file, "-"))
+			fp = stdin;
+		else
+			fp = fopen(file, "r");
+		if (!fp) {
+			perror(file);
+			exit(-1);
+		}
+		while ((r = fread(buf, 1, BUFSIZ, fp)) > 0) {
+			content = realloc(content, buffer_size + r + 1);
+			strncpy(content + buffer_size, buf, r);
+			buffer_size += r;
+		}
+		fclose(fp);
+		if (buffer_size)
+			content[buffer_size] = '\0';
+	} else if (argc == optind) {
+		fprintf(stderr, "usage: %s [-f file]\n", argv[0]);
+		exit(-1);
+	} else {
+		for (i = optind; i < argc; i++) {
+			r = strlen(argv[i]);
+			content = realloc(content, buffer_size + r + 2);
+			if (i != optind)
+				content[buffer_size++] = ' ';
+			strcpy(content + buffer_size, argv[i]);
+			buffer_size += r;
+		}
+	}
+
+	buffer = content;
+	hdata = tracefs_hist_data_parse(buffer, &buffer, &err);
+	printf("hdata = %p\n", hdata);
+	if (!hdata && err) {
+		printf("%s\n", err);
+		exit(-1);
+	}
+
+	key_names = tracefs_hist_data_key_names(hdata);
+	if (!key_names) {
+		perror("key_names");
+		exit(-1);
+	}
+
+	value_names = tracefs_hist_data_value_names(hdata);
+	if (!value_names) {
+		perror("value_names");
+		exit(-1);
+	}
+
+	do {
+		bool first = true;
+		key = tracefs_hist_data_keys(hdata);
+		val = tracefs_hist_data_values(hdata);
+		key_idx = 0;
+		val_idx = 0;
+
+		if (!key || !val) {
+			perror("keys or vals");
+			exit(-1);
+		}
+
+		while (key) {
+			if (!first)
+				printf(",");
+			first = false;
+			if (key_names[key_idx])
+				printf("%s:", key_names[key_idx++]);
+			else
+				printf("(\?\?):");
+			if (key->flags & TRACEFS_BUCKET_KEY_FL_UNDEF) {
+				fprintf(stderr, "bad key type?");
+				exit (-1);
+			} else if (key->flags & TRACEFS_BUCKET_KEY_FL_SINGLE) {
+
+				if (key->flags &
+				    ((1 << TRACEFS_HIST_KEY_SYM) |
+				     (1 << TRACEFS_HIST_KEY_SYM_OFFSET) |
+				     (1 << TRACEFS_HIST_KEY_SYSCALL) |
+				     (1 << TRACEFS_HIST_KEY_EXECNAME)))
+					printf("%s [ %lld ]",
+					       key->single.sym,
+					       key->single.val);
+				else
+					printf("%s", key->single.sym);
+
+			} else if  (key->flags & TRACEFS_BUCKET_KEY_FL_RANGE)
+				printf("%lld - %lld",
+				       key->range.start,
+				       key->range.end);
+			key = key->next;
+		}
+		printf(":");
+		first = true;
+		while (val) {
+			if (!first)
+				printf(",");
+			first = false;
+			if (value_names[val_idx])
+				printf("%s:", value_names[val_idx++]);
+			else
+				printf("(\?\?):");
+			printf("%lld", val->val);
+			val = val->next;
+		}
+		printf("\n");
+		if (tracefs_hist_data_next_bucket(hdata))
+			done = true;
+	} while (!done);
+
+	tracefs_list_free(key_names);
+	tracefs_list_free(value_names);
+	tracefs_hist_data_free(hdata);
+
+	return 0;
+}
+--
+
+BUGS
+----
+There are some known values that the histograms can produce that will break
+the parsing. Those are any string value that contains a comma (,) or a
+colon (:) may cause the parse to misinterpret the parsing and fail to parse.
+This may be fixed in the future.
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
+_tracefs_hist_data_key_names(3)_
+_tracefs_hist_data_value_names(3)_
+_tracefs_hist_data_keys(3)_
+_tracefs_hist_data_values(3)_
+_tracefs_hist_data_next_bucket(3)_
+_tracefs_hist_data_first_bucket(3)_
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

