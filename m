Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDFFC43219
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 03:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344109AbiBPDOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:14:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344111AbiBPDOD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 22:14:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF09D04B9
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 19:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35EB6618F8
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 03:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629A9C340F4;
        Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nKAlG-00481k-HG;
        Tue, 15 Feb 2022 22:13:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] libtraceevent: Make functions bold in man pages
Date:   Tue, 15 Feb 2022 22:13:45 -0500
Message-Id: <20220216031345.984113-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216031345.984113-1-rostedt@goodmis.org>
References: <20220216031345.984113-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Functions should be bold and not underlined in the man pages. Fix them all
up.

Note, functions that were of the type:

 _func_name()_

Are now:

 *func_name()*

But functions with man page references in the parenthesis where:

 _func_name(3)_

Are now:

 *func_name*(3)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-commands.txt      | 26 +++++------
 Documentation/libtraceevent-cpus.txt          |  8 ++--
 Documentation/libtraceevent-debug.txt         | 12 ++---
 Documentation/libtraceevent-endian_read.txt   |  6 +--
 Documentation/libtraceevent-event_find.txt    |  8 ++--
 Documentation/libtraceevent-event_get.txt     | 14 +++---
 Documentation/libtraceevent-event_list.txt    | 10 ++---
 Documentation/libtraceevent-event_print.txt   |  4 +-
 Documentation/libtraceevent-field_find.txt    | 10 ++---
 Documentation/libtraceevent-field_get_val.txt | 18 ++++----
 Documentation/libtraceevent-field_print.txt   | 18 ++++----
 Documentation/libtraceevent-field_read.txt    |  6 +--
 Documentation/libtraceevent-fields.txt        |  8 ++--
 Documentation/libtraceevent-file_endian.txt   |  8 ++--
 Documentation/libtraceevent-filter.txt        | 44 +++++++++----------
 Documentation/libtraceevent-func_apis.txt     | 30 ++++++-------
 Documentation/libtraceevent-func_find.txt     | 10 ++---
 Documentation/libtraceevent-handle.txt        | 16 +++----
 Documentation/libtraceevent-header_page.txt   | 14 +++---
 Documentation/libtraceevent-host_endian.txt   | 14 +++---
 Documentation/libtraceevent-log.txt           |  4 +-
 Documentation/libtraceevent-long_size.txt     |  8 ++--
 Documentation/libtraceevent-page_size.txt     |  8 ++--
 Documentation/libtraceevent-parse-files.txt   | 10 ++---
 Documentation/libtraceevent-parse_event.txt   |  8 ++--
 Documentation/libtraceevent-parse_head.txt    |  8 ++--
 Documentation/libtraceevent-plugins.txt       | 30 ++++++-------
 Documentation/libtraceevent-record_parse.txt  | 18 ++++----
 .../libtraceevent-reg_event_handler.txt       | 12 ++---
 .../libtraceevent-reg_print_func.txt          | 20 ++++-----
 Documentation/libtraceevent-set_flag.txt      | 12 ++---
 Documentation/libtraceevent-strerror.txt      |  8 ++--
 Documentation/libtraceevent-tseq.txt          | 28 ++++++------
 Documentation/libtraceevent.txt               |  2 +-
 34 files changed, 230 insertions(+), 230 deletions(-)

diff --git a/Documentation/libtraceevent-commands.txt b/Documentation/libtraceevent-commands.txt
index add91856b247..185ff16a1352 100644
--- a/Documentation/libtraceevent-commands.txt
+++ b/Documentation/libtraceevent-commands.txt
@@ -28,27 +28,27 @@ The library builds a cache of these mappings, which is used to display the name
 of the process, instead of its pid. This information can be retrieved from
 tracefs/saved_cmdlines file.
 
-The _tep_register_comm()_ function registers a _pid_ / process name mapping.
+The *tep_register_comm()* function registers a _pid_ / process name mapping.
 If a command with the same _pid_ is already registered, an error is returned.
 The _pid_ argument is the process ID, the _comm_ argument is the process name,
 _tep_ is the event context. The _comm_ is duplicated internally.
 
-The _tep_override_comm()_ function registers a _pid_ / process name mapping.
+The *tep_override_comm()* function registers a _pid_ / process name mapping.
 If a process with the same pid is already registered, the process name string is
 udapted with the new one. The _pid_ argument is the process ID, the _comm_
 argument is the process name, _tep_ is the event context. The _comm_ is
 duplicated internally.
 
-The _tep_is_pid_registered()_ function checks if a pid has a process name
+The *tep_is_pid_registered()* function checks if a pid has a process name
 mapping registered. The _pid_ argument is the process ID, _tep_ is the event
 context.
 
-The _tep_data_comm_from_pid()_ function returns the process name for a given
+The *tep_data_comm_from_pid()* function returns the process name for a given
 pid. The _pid_ argument is the process ID, _tep_ is the event context.
 The returned string should not be freed, but will be freed when the _tep_
 handler is closed.
 
-The _tep_data_pid_from_comm()_ function returns a pid for a given process name.
+The *tep_data_pid_from_comm()* function returns a pid for a given process name.
 The _comm_ argument is the process name, _tep_ is the event context.
 The argument _next_ is the cmdline structure to search for the next pid.
 As there may be more than one pid for a given process, the result of this call
@@ -56,31 +56,31 @@ can be passed back into a recurring call in the _next_ parameter, to search for
 the next pid. If _next_ is NULL, it will return the first pid associated with
 the _comm_. The function performs a linear search, so it may be slow.
 
-The _tep_cmdline_pid()_ function returns the pid associated with a given
+The *tep_cmdline_pid()* function returns the pid associated with a given
 _cmdline_. The _tep_ argument is the event context.
 
 RETURN VALUE
 ------------
-_tep_register_comm()_ function returns 0 on success. In case of an error -1 is
+*tep_register_comm()* function returns 0 on success. In case of an error -1 is
 returned and errno is set to indicate the cause of the problem: ENOMEM, if there
 is not enough memory to duplicate the _comm_ or EEXIST if a mapping for this
 _pid_ is already registered.
 
-_tep_override_comm()_ function returns 0 on success. In case of an error -1 is
+*tep_override_comm()* function returns 0 on success. In case of an error -1 is
 returned and errno is set to indicate the cause of the problem: ENOMEM, if there
 is not enough memory to duplicate the _comm_.
 
-_tep_is_pid_registered()_ function returns true if the _pid_ has a process name
+*tep_is_pid_registered()* function returns true if the _pid_ has a process name
 mapped to it, false otherwise.
 
-_tep_data_comm_from_pid()_ function returns the process name as string, or the
+*tep_data_comm_from_pid()* function returns the process name as string, or the
 string "<...>" if there is no mapping for the given pid.
 
-_tep_data_pid_from_comm()_ function returns a pointer to a struct cmdline, that
+*tep_data_pid_from_comm()* function returns a pointer to a struct cmdline, that
 holds a pid for a given process, or NULL if none is found. This result can be
 passed back into a recurring call as the _next_ parameter of the function.
 
-_tep_cmdline_pid()_ functions returns the pid for the give cmdline. If _cmdline_
+*tep_cmdline_pid()* functions returns the pid for the give cmdline. If _cmdline_
  is NULL, then -1 is returned.
 
 EXAMPLE
@@ -131,7 +131,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-cpus.txt b/Documentation/libtraceevent-cpus.txt
index f3d04df967c8..aff422356eb9 100644
--- a/Documentation/libtraceevent-cpus.txt
+++ b/Documentation/libtraceevent-cpus.txt
@@ -18,16 +18,16 @@ void *tep_set_cpus*(struct tep_handle pass:[*]_tep_, int _cpus_);
 
 DESCRIPTION
 -----------
-The _tep_get_cpus()_ function gets the number of CPUs, which have a tracing
+The *tep_get_cpus()* function gets the number of CPUs, which have a tracing
 buffer representing it. The _tep_ argument is trace event parser context.
 
-The _tep_set_cpus()_ function sets the number of CPUs, which have a tracing
+The *tep_set_cpus()* function sets the number of CPUs, which have a tracing
 buffer representing it. The _tep_ argument is trace event parser context.
 The _cpu_ argument is the number of CPUs with tracing data.
 
 RETURN VALUE
 ------------
-The _tep_get_cpus()_ functions returns the number of CPUs, which have tracing
+The *tep_get_cpus()* functions returns the number of CPUs, which have tracing
 data recorded.
 
 EXAMPLE
@@ -55,7 +55,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-debug.txt b/Documentation/libtraceevent-debug.txt
index 3ba573ab0ef3..ff1d06d96ccb 100644
--- a/Documentation/libtraceevent-debug.txt
+++ b/Documentation/libtraceevent-debug.txt
@@ -21,18 +21,18 @@ void *tep_plugin_print_options*(struct trace_seq pass:[*]s);
 
 DESCRIPTION
 -----------
-The _tep_print_printk()_ function prints the printk string formats that were
+The *tep_print_printk()* function prints the printk string formats that were
 stored for this tracing session. The _tep_ argument is trace event parser context.
 
-The _tep_print_funcs()_ function prints the stored function name to address mapping
+The *tep_print_funcs()* function prints the stored function name to address mapping
 for this tracing session. The _tep_ argument is trace event parser context.
 
-The _tep_set_test_filters()_ function sets a flag to test a filter string. If this
-flag is set, when _tep_filter_add_filter_str()_ API as called, it will print the filter
+The *tep_set_test_filters()* function sets a flag to test a filter string. If this
+flag is set, when *tep_filter_add_filter_str()* API as called, it will print the filter
 string instead of adding it. The _tep_ argument is trace event parser context.
 The _test_filters_ argument is the test flag that will be set.
 
-The _tep_plugin_print_options()_ function writes a list of the registered plugin options
+The *tep_plugin_print_options()* function writes a list of the registered plugin options
 into _s_.
 
 EXAMPLE
@@ -73,7 +73,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-endian_read.txt b/Documentation/libtraceevent-endian_read.txt
index cf21e39dbb67..372d52a132c9 100644
--- a/Documentation/libtraceevent-endian_read.txt
+++ b/Documentation/libtraceevent-endian_read.txt
@@ -16,14 +16,14 @@ unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, const void
 
 DESCRIPTION
 -----------
-The _tep_read_number()_ function reads an integer from raw data, taking into
+The *tep_read_number()* function reads an integer from raw data, taking into
 account the endianness of the raw data and the current host. The _tep_ argument
 is the trace event parser context. The _ptr_ is a pointer to the raw data, where
 the integer is, and the _size_ is the size of the integer.
 
 RETURN VALUE
 ------------
-The _tep_read_number()_ function returns the integer in the byte order of
+The *tep_read_number()* function returns the integer in the byte order of
 the current host. In case of an error, 0 is returned.
 
 EXAMPLE
@@ -56,7 +56,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-event_find.txt b/Documentation/libtraceevent-event_find.txt
index 185880e0f0c8..56d76b1023f5 100644
--- a/Documentation/libtraceevent-event_find.txt
+++ b/Documentation/libtraceevent-event_find.txt
@@ -23,15 +23,15 @@ This set of functions can be used to search for an event, based on a given
 criteria. All functions require a pointer to a _tep_, trace event parser
 context.
 
-The _tep_find_event()_ function searches for an event by given event _id_. The
+The *tep_find_event()* function searches for an event by given event _id_. The
 event ID is assigned dynamically and can be viewed in event's format file,
 "ID" field.
 
-The tep_find_event_by_name()_ function searches for an event by given
+The *tep_find_event_by_name()* function searches for an event by given
 event _name_, under the system _sys_. If the _sys_ is NULL (not specified),
 the first event with _name_ is returned.
 
-The tep_find_event_by_record()_ function searches for an event from a given
+The tep_find_event_by_record()* function searches for an event from a given
 _record_.
 
 RETURN VALUE
@@ -81,7 +81,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-event_get.txt b/Documentation/libtraceevent-event_get.txt
index b1f3d8e9a97d..488f17676d42 100644
--- a/Documentation/libtraceevent-event_get.txt
+++ b/Documentation/libtraceevent-event_get.txt
@@ -18,27 +18,27 @@ int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
 
 DESCRIPTION
 -----------
-The _tep_get_event()_ function returns a pointer to event at the given _index_.
+The *tep_get_event()* function returns a pointer to event at the given _index_.
 The _tep_ argument is trace event parser context, the _index_ is the index of
 the requested event.
 
-The _tep_get_first_event()_ function returns a pointer to the first event.
+The *tep_get_first_event()* function returns a pointer to the first event.
 As events are stored in an array, this function returns the pointer to the
 beginning of the array. The _tep_ argument is trace event parser context.
 
-The _tep_get_events_count()_ function returns the number of the events
+The *tep_get_events_count()* function returns the number of the events
 in the array. The _tep_ argument is trace event parser context.
 
 RETURN VALUE
 ------------
-The _tep_get_event()_ returns a pointer to the event located at _index_.
+The *tep_get_event()* returns a pointer to the event located at _index_.
 NULL is returned in case of error, in case there are no events or _index_ is
 out of range.
 
-The _tep_get_first_event()_ returns a pointer to the first event. NULL is
+The *tep_get_first_event()* returns a pointer to the first event. NULL is
 returned in case of error, or in case there are no events.
 
-The _tep_get_events_count()_ returns the number of the events. 0 is
+The *tep_get_events_count()* returns the number of the events. 0 is
 returned in case of error, or in case there are no events.
 
 EXAMPLE
@@ -77,7 +77,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-event_list.txt b/Documentation/libtraceevent-event_list.txt
index 736d99370953..a958b18308d4 100644
--- a/Documentation/libtraceevent-event_list.txt
+++ b/Documentation/libtraceevent-event_list.txt
@@ -24,7 +24,7 @@ struct tep_event pass:[*]pass:[*]*tep_list_events_copy*(struct tep_handle pass:[
 
 DESCRIPTION
 -----------
-The _tep_list_events()_ function returns an array of pointers to the events,
+The *tep_list_events()* function returns an array of pointers to the events,
 sorted by the _sort_type_ criteria. The last element of the array is NULL.
 The returned memory must not be freed, it is managed by the library.
 The function is not thread safe. The _tep_ argument is trace event parser
@@ -36,18 +36,18 @@ context. The _sort_type_ argument is the required sort criteria:
 	_TEP_EVENT_SORT_SYSTEM_	- sort by the event (system, name, id) triplet.
 --
 
-The _tep_list_events_copy()_ is a thread safe version of _tep_list_events()_.
+The *tep_list_events_copy()* is a thread safe version of _tep_list_events()_.
 It has the same behavior, but the returned array is allocated internally and
 must be freed by the caller. Note that the content of the array must not be
 freed (see the EXAMPLE below).
 
 RETURN VALUE
 ------------
-The _tep_list_events()_ function returns an array of pointers to events.
+The *tep_list_events()* function returns an array of pointers to events.
 In case of an error, NULL is returned. The returned array must not be freed,
 it is managed by the library.
 
-The _tep_list_events_copy()_ function returns an array of pointers to events.
+The *tep_list_events_copy()* function returns an array of pointers to events.
 In case of an error, NULL is returned. The returned array must be freed by
 the caller.
 
@@ -100,7 +100,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-event_print.txt b/Documentation/libtraceevent-event_print.txt
index c729a8734040..6a5946a83515 100644
--- a/Documentation/libtraceevent-event_print.txt
+++ b/Documentation/libtraceevent-event_print.txt
@@ -18,7 +18,7 @@ void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seqpass:[*]
 DESCRIPTION
 -----------
 
-The _tep_print_event()_ function parses the event information of the given
+The *tep_print_event()* function parses the event information of the given
 _record_ and writes it into the trace sequence _s_, according to the format
 string _fmt_. The desired information is specified after the format string.
 The _fmt_ is printf-like format string, following arguments are supported:
@@ -108,7 +108,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-field_find.txt b/Documentation/libtraceevent-field_find.txt
index fa3066bc8a55..5e4071ca4088 100644
--- a/Documentation/libtraceevent-field_find.txt
+++ b/Documentation/libtraceevent-field_find.txt
@@ -22,18 +22,18 @@ DESCRIPTION
 These functions search for a field with given name in an event. The field
 returned can be used to find the field content from within a data record.
 
-The _tep_find_common_field()_ function searches for a common field with _name_
+The *tep_find_common_field()* function searches for a common field with _name_
 in the _event_.
 
-The _tep_find_field()_ function searches for an event specific field with
+The *tep_find_field()* function searches for an event specific field with
 _name_ in the _event_.
 
-The _tep_find_any_field()_ function searches for any field with _name_ in the
+The *tep_find_any_field()* function searches for any field with _name_ in the
 _event_.
 
 RETURN VALUE
 ------------
-The _tep_find_common_field(), _tep_find_field()_ and _tep_find_any_field()_
+The _tep_find_common_field(), *tep_find_field()* and _tep_find_any_field()_
 functions return a pointer to the found field, or NULL in case there is no field
 with the requested name.
 
@@ -96,7 +96,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-field_get_val.txt b/Documentation/libtraceevent-field_get_val.txt
index 29f6583c44a3..69d51bfc1020 100644
--- a/Documentation/libtraceevent-field_get_val.txt
+++ b/Documentation/libtraceevent-field_get_val.txt
@@ -23,19 +23,19 @@ DESCRIPTION
 -----------
 These functions can be used to find a field and retrieve its value.
 
-The _tep_get_any_field_val()_ function searches in the _record_ for a field
+The *tep_get_any_field_val()* function searches in the _record_ for a field
 with _name_, part of the _event_. If the field is found, its value is stored in
 _val_. If there is an error and _err_ is not zero, then an error string is
 written into _s_.
 
-The _tep_get_common_field_val()_ function does the same as
-_tep_get_any_field_val()_, but searches only in the common fields. This works
+The *tep_get_common_field_val()* function does the same as
+*tep_get_any_field_val()*, but searches only in the common fields. This works
 for any event as all events include the common fields.
 
-The _tep_get_field_val()_ function does the same as _tep_get_any_field_val()_,
+The *tep_get_field_val()* function does the same as *tep_get_any_field_val()*,
 but searches only in the event specific fields.
 
-The _tep_get_field_raw()_ function searches in the _record_ for a field with
+The *tep_get_field_raw()* function searches in the _record_ for a field with
 _name_, part of the _event_. If the field is found, a pointer to where the field
 exists in the record's raw data is returned. The size of the data is stored in
 _len_. If there is an error and _err_ is not zero, then an error string is
@@ -43,10 +43,10 @@ written into _s_.
 
 RETURN VALUE
 ------------
-The _tep_get_any_field_val()_, _tep_get_common_field_val()_ and
-_tep_get_field_val()_ functions return 0 on success, or -1 in case of an error.
+The *tep_get_any_field_val()*, *tep_get_common_field_val()* and
+*tep_get_field_val()* functions return 0 on success, or -1 in case of an error.
 
-The _tep_get_field_raw()_ function returns a pointer to field's raw data, and
+The *tep_get_field_raw()* function returns a pointer to field's raw data, and
 places the length of this data in _len_. In case of an error NULL is returned.
 
 EXAMPLE
@@ -100,7 +100,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-field_print.txt b/Documentation/libtraceevent-field_print.txt
index 05b458b29e8e..3844fd1b62f1 100644
--- a/Documentation/libtraceevent-field_print.txt
+++ b/Documentation/libtraceevent-field_print.txt
@@ -25,25 +25,25 @@ DESCRIPTION
 -----------
 These functions print recorded field's data, according to the field's type.
 
-The _tep_print_field_content()_ function extracts from the recorded raw _data_ value of
+The *tep_print_field_content()* function extracts from the recorded raw _data_ value of
 the _field_ and prints it into _s_, according to the field type.
 
-The _tep_print_fields()_ prints each field name followed by the record's field
+The *tep_print_fields()* prints each field name followed by the record's field
 value according to the field's type:
 [verse]
 --
 "field1_name=field1_value field2_name=field2_value ..."
 --
-It iterates all fields of the _event_, and calls _tep_print_field_content()_ for each of
+It iterates all fields of the _event_, and calls *tep_print_field_content()* for each of
 them.
 
-The _tep_print_num_field()_ function prints a numeric field with given format
+The *tep_print_num_field()* function prints a numeric field with given format
 string. A search is performed in the _event_ for a field with _name_. If such
 field is found, its value is extracted from the _record_ and is printed in the
 _s_, according to the given format string _fmt_. If the argument _err_ is
 non-zero, and an error occures - it is printed in the _s_.
 
-The _tep_print_func_field()_ function prints a function field with given format
+The *tep_print_func_field()* function prints a function field with given format
 string.  A search is performed in the _event_ for a field with _name_. If such
 field is found, its value is extracted from the _record_. The value is assumed
 to be a function address, and a search is perform to find the name of this
@@ -51,16 +51,16 @@ function. The function name (if found) and its address are printed in the _s_,
 according to the given format string _fmt_. If the argument _err_ is non-zero,
 and an error occures - it is printed in _s_.
 
-The _tep_record_print_fields()_ prints the field's name followed by its value
+The *tep_record_print_fields()* prints the field's name followed by its value
 for all record's field.
 
-The _tep_record_print_selected_fields()_ prints the field's name followed by
+The *tep_record_print_selected_fields()* prints the field's name followed by
 its value for selected subset of record field. The fields to be printed are
 defined by the _select_mask_ bit mask.
 
 RETURN VALUE
 ------------
-The _tep_print_num_field()_ and _tep_print_func_field()_ functions return 1
+The *tep_print_num_field()* and *tep_print_func_field()* functions return 1
 on success, -1 in case of an error or 0 if the print buffer _s_ is full.
 
 EXAMPLE
@@ -113,7 +113,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-field_read.txt b/Documentation/libtraceevent-field_read.txt
index 96de89585d4d..cc322fb22764 100644
--- a/Documentation/libtraceevent-field_read.txt
+++ b/Documentation/libtraceevent-field_read.txt
@@ -16,14 +16,14 @@ int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void
 
 DESCRIPTION
 -----------
-The _tep_read_number_field()_ function reads the value of the _field_ from the
+The *tep_read_number_field()* function reads the value of the _field_ from the
 raw _data_ and stores it in the _value_. The function sets the _value_ according
 to the endianness of the raw data and the current machine and stores it in
 _value_.
 
 RETURN VALUE
 ------------
-The _tep_read_number_field()_ function retunrs 0 in case of success, or -1 in
+The *tep_read_number_field()* function retunrs 0 in case of success, or -1 in
 case of an error.
 
 EXAMPLE
@@ -59,7 +59,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-fields.txt b/Documentation/libtraceevent-fields.txt
index a0816907b071..99b302f87574 100644
--- a/Documentation/libtraceevent-fields.txt
+++ b/Documentation/libtraceevent-fields.txt
@@ -17,17 +17,17 @@ struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_event pass
 
 DESCRIPTION
 -----------
-The _tep_event_common_fields()_ function returns an array of pointers to common
+The *tep_event_common_fields()* function returns an array of pointers to common
 fields for the _event_. The array is allocated in the function and must be freed
 by free(). The last element of the array is NULL.
 
-The _tep_event_fields()_ function returns an array of pointers to event specific
+The *tep_event_fields()* function returns an array of pointers to event specific
 fields for the _event_. The array is allocated in the function and must be freed
 by free(). The last element of the array is NULL.
 
 RETURN VALUE
 ------------
-Both _tep_event_common_fields()_ and _tep_event_fields()_ functions return
+Both *tep_event_common_fields()* and *tep_event_fields()* functions return
 an array of pointers to tep_format_field structures in case of success, or
 NULL in case of an error.
 
@@ -83,7 +83,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-file_endian.txt b/Documentation/libtraceevent-file_endian.txt
index 197954c20a92..4d13227f780a 100644
--- a/Documentation/libtraceevent-file_endian.txt
+++ b/Documentation/libtraceevent-file_endian.txt
@@ -23,11 +23,11 @@ void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _
 --
 DESCRIPTION
 -----------
-The _tep_is_file_bigendian()_ function gets the endianness of the raw data,
+The *tep_is_file_bigendian()* function gets the endianness of the raw data,
 being accessed by the tep handler. The _tep_ argument is trace event parser
 context.
 
-The _tep_set_file_bigendian()_ function sets the endianness of raw data being
+The *tep_set_file_bigendian()* function sets the endianness of raw data being
 accessed by the tep handler. The _tep_ argument is trace event parser context.
 [verse]
 --
@@ -37,7 +37,7 @@ The _endian_ argument is the endianness:
 --
 RETURN VALUE
 ------------
-The _tep_is_file_bigendian()_ function returns true if the data is in bigendian
+The *tep_is_file_bigendian()* function returns true if the data is in bigendian
 format, false otherwise.
 
 EXAMPLE
@@ -69,7 +69,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-filter.txt b/Documentation/libtraceevent-filter.txt
index 052e745d8336..f3eacf6662bb 100644
--- a/Documentation/libtraceevent-filter.txt
+++ b/Documentation/libtraceevent-filter.txt
@@ -34,53 +34,53 @@ events when outputting them. Each event can be filtered based on its parameters,
 described in the event's format file. This set of functions can be used to
 create, delete, modify and attach event filters.
 
-The _tep_filter_alloc()_ function creates a new event filter. The _tep_ argument
+The *tep_filter_alloc()* function creates a new event filter. The _tep_ argument
 is the trace event parser context.
 
-The _tep_filter_free()_ function frees an event filter and all resources that it
+The *tep_filter_free()* function frees an event filter and all resources that it
 had used.
 
-The _tep_filter_reset()_ function removes all rules from an event filter and
+The *tep_filter_reset()* function removes all rules from an event filter and
 resets it.
 
-The _tep_filter_add_filter_str()_ function adds a new rule to the _filter_. The
+The *tep_filter_add_filter_str()* function adds a new rule to the _filter_. The
 _filter_str_ argument is the filter string, that contains the rule.
 
-The _tep_event_filtered()_ function checks if the event with _event_id_ has
+The *tep_event_filtered()* function checks if the event with _event_id_ has
 _filter_.
 
-The _tep_filter_remove_event()_ function removes a _filter_ for an event with
+The *tep_filter_remove_event()* function removes a _filter_ for an event with
 _event_id_.
 
-The _tep_filter_match()_ function tests if a _record_ matches given _filter_.
+The *tep_filter_match()* function tests if a _record_ matches given _filter_.
 
-The _tep_filter_copy()_ function copies a _source_ filter into a _dest_ filter.
+The *tep_filter_copy()* function copies a _source_ filter into a _dest_ filter.
 
-The _tep_filter_compare()_ function compares two filers - _filter1_ and _filter2_.
+The *tep_filter_compare()* function compares two filers - _filter1_ and _filter2_.
 
-The _tep_filter_make_string()_ function constructs a string, displaying
+The *tep_filter_make_string()* function constructs a string, displaying
 the _filter_ contents for given _event_id_.
 
-The _tep_filter_strerror()_ function copies the _filter_ error buffer into the
+The *tep_filter_strerror()* function copies the _filter_ error buffer into the
 given _buf_ with the size _buflen_. If the error buffer is empty, in the _buf_
 is copied a string, describing the error _err_.
 
 RETURN VALUE
 ------------
-The _tep_filter_alloc()_ function returns a pointer to the newly created event
+The *tep_filter_alloc()* function returns a pointer to the newly created event
 filter, or NULL in case of an error.
 
-The _tep_filter_add_filter_str()_ function returns 0 if the rule was
-successfully added or a negative error code.  Use _tep_filter_strerror()_ to see
+The *tep_filter_add_filter_str()* function returns 0 if the rule was
+successfully added or a negative error code.  Use *tep_filter_strerror()* to see
 actual error message in case of an error.
 
-The _tep_event_filtered()_ function returns 1 if the filter is found for given
+The *tep_event_filtered()* function returns 1 if the filter is found for given
 event, or 0 otherwise.
 
-The _tep_filter_remove_event()_ function returns 1 if the vent was removed, or
+The *tep_filter_remove_event()* function returns 1 if the vent was removed, or
 0 if the event was not found.
 
-The _tep_filter_match()_ function returns _tep_errno_, according to the result:
+The *tep_filter_match()* function returns _tep_errno_, according to the result:
 [verse]
 --
 _pass:[TEP_ERRNO__FILTER_MATCH]_	- filter found for event, the record matches.
@@ -90,16 +90,16 @@ _pass:[TEP_ERRNO__NO_FILTER]_		- no rules in the filter.
 --
 or any other _tep_errno_, if an error occurred during the test.
 
-The _tep_filter_copy()_ function returns 0 on success or -1 if not all rules
+The *tep_filter_copy()* function returns 0 on success or -1 if not all rules
  were copied.
 
-The _tep_filter_compare()_ function returns 1 if the two filters hold the same
+The *tep_filter_compare()* function returns 1 if the two filters hold the same
 content, or 0 if they do not.
 
-The _tep_filter_make_string()_ function returns a string, which must be freed
+The *tep_filter_make_string()* function returns a string, which must be freed
 with free(), or NULL in case of an error.
 
-The _tep_filter_strerror()_ function returns 0 if message was filled
+The *tep_filter_strerror()* function returns 0 if message was filled
 successfully, or -1 in case of an error.
 
 EXAMPLE
@@ -187,7 +187,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-func_apis.txt b/Documentation/libtraceevent-func_apis.txt
index 1fe450023772..84245777466b 100644
--- a/Documentation/libtraceevent-func_apis.txt
+++ b/Documentation/libtraceevent-func_apis.txt
@@ -31,18 +31,18 @@ allow them to keep using it instead of duplicating all the entries inside.
 
 The _tep_func_resolver_t_ type is the prototype of the alternative kernel
 functions resolver. This function receives a pointer to its custom context
-(set with the _tep_set_function_resolver()_ call ) and the address of a kernel
+(set with the *tep_set_function_resolver()* call ) and the address of a kernel
 function, which has to be resolved. In case of success, it should return
 the name of the function and its module (if any) in _modp_.
 
-The _tep_set_function_resolver()_ function registers _func_ as an alternative
+The *tep_set_function_resolver()* function registers _func_ as an alternative
 kernel functions resolver. The _tep_ argument is trace event parser context.
 The _priv_ argument is a custom context of the _func_ function. The function
-resolver is used by the APIs _tep_find_function()_,
-_tep_find_function_address()_, and _tep_print_func_field()_ to resolve
+resolver is used by the APIs *tep_find_function()*,
+*tep_find_function_address()*, and *tep_print_func_field()* to resolve
 a function address to a function name.
 
-The _tep_reset_function_resolver()_ function resets the kernel functions
+The *tep_reset_function_resolver()* function resets the kernel functions
 resolver to the default function.  The _tep_ argument is trace event parser
 context.
 
@@ -51,15 +51,15 @@ These APIs can be used to find function name and start address, by given
 address. The given address does not have to be exact, it will select
 the function that would contain it.
 
-The _tep_find_function()_ function returns the function name, which contains the
+The *tep_find_function()* function returns the function name, which contains the
 given address _addr_. The _tep_ argument is the trace event parser context.
 
-The _tep_find_function_address()_ function returns the function start address,
+The *tep_find_function_address()* function returns the function start address,
 by given address _addr_. The _addr_ does not have to be exact, it will select
 the function that would contain it. The _tep_ argument is the trace event
 parser context.
 
-The _tep_register_function()_ function registers a function name mapped to an
+The *tep_register_function()* function registers a function name mapped to an
 address and (optional) module. This mapping is used in case the function tracer
 or events have "%pS" parameter in its format string. It is common to pass in
 the kallsyms function names with their corresponding addresses with this
@@ -68,7 +68,7 @@ the name of the function, the string is copied internally. The _addr_ is the
 start address of the function. The _mod_ is the kernel module the function may
 be in (NULL for none).
 
-The _tep_register_print_string()_ function  registers a string by the address
+The *tep_register_print_string()* function  registers a string by the address
 it was stored in the kernel. Some strings internal to the kernel with static
 address are passed to certain events. The "%s" in the event's format field
 which has an address needs to know what string would be at that address. The
@@ -81,19 +81,19 @@ The _addr_ is the address the string was located at.
 
 RETURN VALUE
 ------------
-The _tep_set_function_resolver()_ function returns 0 in case of success, or -1
+The *tep_set_function_resolver()* function returns 0 in case of success, or -1
 in case of an error.
 
-The _tep_find_function()_ function returns the function name, or NULL in case
+The *tep_find_function()* function returns the function name, or NULL in case
 it cannot be found.
 
-The _tep_find_function_address()_ function returns the function start address,
+The *tep_find_function_address()* function returns the function start address,
 or 0 in case it cannot be found.
 
-The _tep_register_function()_ function returns 0 in case of success. In case of
+The *tep_register_function()* function returns 0 in case of success. In case of
 an error -1 is returned, and errno is set to the appropriate error number.
 
-The _tep_register_print_string()_ function returns 0 in case of success. In case
+The *tep_register_print_string()* function returns 0 in case of success. In case
 of an error -1 is returned, and errno is set to the appropriate error number.
 
 EXAMPLE
@@ -164,7 +164,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-func_find.txt b/Documentation/libtraceevent-func_find.txt
index b7e324b5a117..20982e91fa0b 100644
--- a/Documentation/libtraceevent-func_find.txt
+++ b/Documentation/libtraceevent-func_find.txt
@@ -21,19 +21,19 @@ These functions can be used to find function name and start address, by given
 address. The given address does not have to be exact, it will select the function
 that would contain it.
 
-The _tep_find_function()_ function returns the function name, which contains the
+The *tep_find_function()* function returns the function name, which contains the
 given address _addr_. The _tep_ argument is the trace event parser context.
 
-The _tep_find_function_address()_ function returns the function start address,
+The *tep_find_function_address()* function returns the function start address,
 by given address _addr_. The _addr_ does not have to be exact, it will select the
 function that would contain it. The _tep_ argument is the trace event parser context.
 
 RETURN VALUE
 ------------
-The _tep_find_function()_ function returns the function name, or NULL in case
+The *tep_find_function()* function returns the function name, or NULL in case
 it cannot be found.
 
-The _tep_find_function_address()_ function returns the function start address,
+The *tep_find_function_address()* function returns the function start address,
 or 0 in case it cannot be found.
 
 EXAMPLE
@@ -66,7 +66,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-handle.txt b/Documentation/libtraceevent-handle.txt
index 5696b6237c2f..0d6afdae81df 100644
--- a/Documentation/libtraceevent-handle.txt
+++ b/Documentation/libtraceevent-handle.txt
@@ -25,27 +25,27 @@ These are the main functions to create and destroy tep_handle - the main
 structure, representing the trace event parser context. This context is used as
 the input parameter of most library APIs.
 
-The _tep_alloc()_ function allocates and initializes the tep context.
+The *tep_alloc()* function allocates and initializes the tep context.
 
-The _tep_free()_ function will decrement the reference of the _tep_ handler.
+The *tep_free()* function will decrement the reference of the _tep_ handler.
 When there is no more references, then it will free the handler, as well
 as clean up all its resources that it had used. The argument _tep_ is
 the pointer to the trace event parser context.
 
-The _tep_ref()_ function adds a reference to the _tep_ handler.
+The *tep_ref()* function adds a reference to the _tep_ handler.
 
-The _tep_unref()_ function removes a reference from the _tep_ handler. When
+The *tep_unref()* function removes a reference from the _tep_ handler. When
 the last reference is removed, the _tep_ is destroyed, and all resources that
 it had used are cleaned up.
 
-The _tep_ref_get()_ functions gets the current references of the _tep_ handler.
+The *tep_ref_get()* functions gets the current references of the _tep_ handler.
 
 RETURN VALUE
 ------------
-_tep_alloc()_ returns a pointer to a newly created tep_handle structure.
+*tep_alloc()* returns a pointer to a newly created tep_handle structure.
 NULL is returned in case there is not enough free memory to allocate it.
 
-_tep_ref_get()_ returns the current references of _tep_.
+*tep_ref_get()* returns the current references of _tep_.
 If _tep_ is NULL, 0 is returned.
 
 EXAMPLE
@@ -79,7 +79,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-header_page.txt b/Documentation/libtraceevent-header_page.txt
index f8f72e5b2a9f..31b66e09fc82 100644
--- a/Documentation/libtraceevent-header_page.txt
+++ b/Documentation/libtraceevent-header_page.txt
@@ -22,26 +22,26 @@ These functions retrieve information from kernel context, stored in tracefs
 events/header_page. Old kernels do not have header page info, so default values
 from user space context are used.
 
-The _tep_get_header_page_size()_ function returns the size of a long integer,
+The *tep_get_header_page_size()* function returns the size of a long integer,
 in kernel context. The _tep_ argument is trace event parser context.
 This information is retrieved from tracefs events/header_page, "commit" field.
 
-The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
+The *tep_get_header_timestamp_size()* function returns the size of timestamps,
 in kernel context. The _tep_ argument is trace event parser context. This
 information is retrieved from tracefs events/header_page, "timestamp" field.
 
-The _tep_is_old_format()_ function returns true if the kernel predates
+The *tep_is_old_format()* function returns true if the kernel predates
 the addition of events/header_page, otherwise it returns false.
 
 RETURN VALUE
 ------------
-The _tep_get_header_page_size()_ function returns the size of a long integer,
+The *tep_get_header_page_size()* function returns the size of a long integer,
 in bytes.
 
-The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
+The *tep_get_header_timestamp_size()* function returns the size of timestamps,
 in bytes.
 
-The _tep_is_old_format()_ function returns true, if an old kernel is used to
+The *tep_is_old_format()* function returns true, if an old kernel is used to
 generate the tracing data, which has no event/header_page. If the kernel is new,
 or _tep_ is NULL, false is returned.
 
@@ -80,7 +80,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-host_endian.txt b/Documentation/libtraceevent-host_endian.txt
index 7fdfaed0ccf4..76d309a37dfe 100644
--- a/Documentation/libtraceevent-host_endian.txt
+++ b/Documentation/libtraceevent-host_endian.txt
@@ -25,15 +25,15 @@ void *tep_set_local_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian
 DESCRIPTION
 -----------
 
-The _tep_is_bigendian()_ gets the endianness of the machine, executing
+The *tep_is_bigendian()* gets the endianness of the machine, executing
 the function.
 
-The _tep_is_local_bigendian()_ function gets the endianness of the local
+The *tep_is_local_bigendian()* function gets the endianness of the local
 machine, saved in the _tep_ handler. The _tep_ argument is the trace event
-parser context. This API is a bit faster than _tep_is_bigendian()_, as it
+parser context. This API is a bit faster than *tep_is_bigendian()*, as it
 returns cached endianness of the local machine instead of checking it each time.
 
-The _tep_set_local_bigendian()_ function sets the endianness of the local
+The *tep_set_local_bigendian()* function sets the endianness of the local
 machine in the _tep_ handler. The _tep_ argument is trace event parser context.
 The _endian_ argument is the endianness:
 [verse]
@@ -44,10 +44,10 @@ The _endian_ argument is the endianness:
 
 RETURN VALUE
 ------------
-The _tep_is_bigendian()_ function returns non zero if the endianness of the
+The *tep_is_bigendian()* function returns non zero if the endianness of the
 machine, executing the code, is big endian and zero otherwise.
 
-The _tep_is_local_bigendian()_ function returns true, if the endianness of the
+The *tep_is_local_bigendian()* function returns true, if the endianness of the
 local machine, saved in the _tep_ handler, is big endian, or false otherwise.
 
 EXAMPLE
@@ -82,7 +82,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-log.txt b/Documentation/libtraceevent-log.txt
index 1ecb4db9f069..a236e2adac21 100644
--- a/Documentation/libtraceevent-log.txt
+++ b/Documentation/libtraceevent-log.txt
@@ -26,7 +26,7 @@ int *tep_set_loglevel*(enum tep_loglevel _level_);
 --
 DESCRIPTION
 -----------
-The _tep_set_loglevel()_ function sets the level of the library logs that will be printed
+The *tep_set_loglevel()* function sets the level of the library logs that will be printed
 on the console. Library log levels are:
 [verse]
 --
@@ -68,7 +68,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-long_size.txt b/Documentation/libtraceevent-long_size.txt
index a651438b4c3f..c4b358afe662 100644
--- a/Documentation/libtraceevent-long_size.txt
+++ b/Documentation/libtraceevent-long_size.txt
@@ -18,16 +18,16 @@ void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_);
 
 DESCRIPTION
 -----------
-The _tep_get_long_size()_ function returns the size of a long integer on the machine,
+The *tep_get_long_size()* function returns the size of a long integer on the machine,
 where the trace is generated. The _tep_ argument is trace event parser context.
 
-The _tep_set_long_size()_ function sets the size of a long integer on the machine,
+The *tep_set_long_size()* function sets the size of a long integer on the machine,
 where the trace is generated. The _tep_ argument is trace event parser context.
 The _long_size_ is the size of a long integer, in bytes.
 
 RETURN VALUE
 ------------
-The _tep_get_long_size()_ function returns the size of a long integer on the machine,
+The *tep_get_long_size()* function returns the size of a long integer on the machine,
 where the trace is generated, in bytes.
 
 EXAMPLE
@@ -56,7 +56,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-page_size.txt b/Documentation/libtraceevent-page_size.txt
index ff6092109167..7ffeb790002a 100644
--- a/Documentation/libtraceevent-page_size.txt
+++ b/Documentation/libtraceevent-page_size.txt
@@ -18,18 +18,18 @@ void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
 
 DESCRIPTION
 -----------
-The _tep_get_page_size()_ function returns the size of a memory page on
+The *tep_get_page_size()* function returns the size of a memory page on
 the machine, where the trace is generated. The _tep_ argument is trace
 event parser context.
 
-The _tep_set_page_size()_ function stores in the _tep_ context the size of a
+The *tep_set_page_size()* function stores in the _tep_ context the size of a
 memory page on the machine, where the trace is generated.
 The _tep_ argument is trace event parser context.
 The _page_size_ argument is the size of a memory page, in bytes.
 
 RETURN VALUE
 ------------
-The _tep_get_page_size()_ function returns size of the memory page, in bytes.
+The *tep_get_page_size()* function returns size of the memory page, in bytes.
 
 EXAMPLE
 -------
@@ -60,7 +60,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-parse-files.txt b/Documentation/libtraceevent-parse-files.txt
index 211f4f4ef006..bb2facb44a40 100644
--- a/Documentation/libtraceevent-parse-files.txt
+++ b/Documentation/libtraceevent-parse-files.txt
@@ -19,14 +19,14 @@ int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_bu
 
 DESCRIPTION
 -----------
-*tep_parse_saved_cmdlines* is a helper function to parse content in the tracefs
+*tep_parse_saved_cmdlines()* is a helper function to parse content in the tracefs
 file system of the "saved_cmdlines" file (stored in a string buffer passed in by _buf_)
 and loads the mapping of the process IDs (pid) to the comm names in the
 _tep_ handler. The events store the pid and this is used to be able to show the
 process names associated to those process ids. It parses the string _buf_ that
 holds the content of saved_cmdlines and ends with a nul character ('\0').
 
-*tep_parse_printk_formats* is a helper function to parse content in the tracefs
+*tep_parse_printk_formats()* is a helper function to parse content in the tracefs
 file system of the "printk_formats" file (stored in a string buffer passed in by _buf_)
 and loads the mapping of addresses of strings that may be referenced by events.
 Events only store the address of constant strings in the kernel, and the mapping
@@ -34,7 +34,7 @@ of their address to the string is exported to user space in the printk_formats
 file. It parses the string _buf_ that holds the content of printk_formats and
 ends with a nul character ('\0').
 
-*tep_parse_kallsyms* is a helper function to parse the Linux kernel /proc/kallsyms format
+*tep_parse_kallsyms()* is a helper function to parse the Linux kernel /proc/kallsyms format
 (stored in a string buffer passed in by _buf_) and load the functions into the
 _tep_ handler such that function IP addresses can be mapped to their name when
 parsing events with %pS in the print format field. It parses the string _buf_ that
@@ -126,8 +126,8 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_comm(3)_, _tep_register_function(3)_,
-_tep_register_print_string_(3)
+*libtraceevent*(3), *trace-cmd*(1), *tep_register_comm*(3), *tep_register_function*(3),
+*tep_register_print_string*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-parse_event.txt b/Documentation/libtraceevent-parse_event.txt
index dfbdedadc4a7..466d157a203f 100644
--- a/Documentation/libtraceevent-parse_event.txt
+++ b/Documentation/libtraceevent-parse_event.txt
@@ -17,7 +17,7 @@ enum tep_errno *tep_parse_format*(struct tep_handle pass:[*]_tep_, struct tep_ev
 
 DESCRIPTION
 -----------
-The _tep_parse_event()_ function parses the event format and creates an event
+The *tep_parse_event()* function parses the event format and creates an event
 structure to quickly parse raw data for a given event. The _tep_ argument is
 the trace event parser context. The created event structure is stored in the
 _tep_ context. The _buf_ argument is a buffer with _size_, where the event
@@ -25,13 +25,13 @@ format data is. The event format data can be taken from
 tracefs/events/.../.../format files. The _sys_ argument is the system of
 the event.
 
-The _tep_parse_format()_ function does the same as _tep_parse_event()_. The only
+The *tep_parse_format()* function does the same as *tep_parse_event()*. The only
 difference is in the extra _eventp_ argument, where the newly created event
 structure is returned.
 
 RETURN VALUE
 ------------
-Both _tep_parse_event()_ and _tep_parse_format()_ functions return 0 on success,
+Both *tep_parse_event()* and *tep_parse_format()* functions return 0 on success,
 or TEP_ERRNO__... in case of an error.
 
 EXAMPLE
@@ -68,7 +68,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-parse_head.txt b/Documentation/libtraceevent-parse_head.txt
index c20a41d46ca6..22b0a4f587b4 100644
--- a/Documentation/libtraceevent-parse_head.txt
+++ b/Documentation/libtraceevent-parse_head.txt
@@ -16,19 +16,19 @@ int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*]_buf_,
 
 DESCRIPTION
 -----------
-The _tep_parse_header_page()_ function parses the header page data from _buf_,
+The *tep_parse_header_page()* function parses the header page data from _buf_,
 and initializes the _tep_, trace event parser context, with it. The buffer
 _buf_ is with _size_, and is supposed to be copied from
 tracefs/events/header_page.
 
 Some old kernels do not have header page info, in this case the
-_tep_parse_header_page()_ function  can be called with _size_ equal to 0. The
+*tep_parse_header_page()* function  can be called with _size_ equal to 0. The
 _tep_ context is initialized with default values. The _long_size_ can be used in
 this use case, to set the size of a long integer to be used.
 
 RETURN VALUE
 ------------
-The _tep_parse_header_page()_ function returns 0 in case of success, or -1
+The *tep_parse_header_page()* function returns 0 in case of success, or -1
 in case of an error.
 
 EXAMPLE
@@ -60,7 +60,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-plugins.txt b/Documentation/libtraceevent-plugins.txt
index 510c4022afba..24d8ad84ef5c 100644
--- a/Documentation/libtraceevent-plugins.txt
+++ b/Documentation/libtraceevent-plugins.txt
@@ -25,7 +25,7 @@ int *tep_add_plugin_path*(struct tep_handle pass:[*]tep, char pass:[*]path,
 
 DESCRIPTION
 -----------
-The _tep_load_plugins()_ function loads all plugins, located in the plugin
+The *tep_load_plugins()* function loads all plugins, located in the plugin
 directories. The _tep_ argument is trace event parser context.
 The plugin directories are :
 [verse]
@@ -39,29 +39,29 @@ The plugin directories are :
 	- Directories, specified in _tep_->plugins_dir with priority TEP_PLUGIN_LAST
 --
 Loading of plugins can be controlled by the _tep_flags_, using the
-_tep_set_flag()_ API:
+*tep_set_flag()* API:
 [verse]
 --
 	_TEP_DISABLE_SYS_PLUGINS_	- do not load plugins, located in
 					the system's plugin directory.
 	_TEP_DISABLE_PLUGINS_		- do not load any plugins.
 --
-The _tep_set_flag()_ API needs to be called before _tep_load_plugins()_, if
+The *tep_set_flag()* API needs to be called before *tep_load_plugins()*, if
 loading of all plugins is not the desired case.
 
-The _tep_unload_plugins()_ function unloads the plugins, previously loaded by
-_tep_load_plugins()_. The _tep_ argument is trace event parser context. The
+The *tep_unload_plugins()* function unloads the plugins, previously loaded by
+*tep_load_plugins()*. The _tep_ argument is trace event parser context. The
 _plugin_list_ is the list of loaded plugins, returned by
-the _tep_load_plugins()_ function.
+the *tep_load_plugins()* function.
 
-The _tep_load_plugins_hook()_ function walks through all directories with plugins
-and calls user specified _load_plugin()_ hook for each plugin file. Only files
+The *tep_load_plugins_hook()* function walks through all directories with plugins
+and calls user specified *load_plugin()* hook for each plugin file. Only files
 with given _suffix_ are considered to be plugins. The _data_ is a user specified
-context, passed to _load_plugin()_. Directories and the walk order are the same
-as in _tep_load_plugins()_ API.
+context, passed to *load_plugin()*. Directories and the walk order are the same
+as in *tep_load_plugins()* API.
 
-The _tep_add_plugin_path()_ functions adds additional directories with plugins in
-the _tep_->plugins_dir list. It must be called before _tep_load_plugins()_ in order
+The *tep_add_plugin_path()* functions adds additional directories with plugins in
+the _tep_->plugins_dir list. It must be called before *tep_load_plugins()* in order
 for the plugins from the new directories to be loaded. The _tep_ argument is
 the trace event parser context. The _path_ is the full path to the new plugin
 directory. The _prio_ argument specifies the loading priority order for the
@@ -78,9 +78,9 @@ plugins in the other directories.
 
 RETURN VALUE
 ------------
-The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
+The *tep_load_plugins()* function returns a list of successfully loaded plugins,
 or NULL in case no plugins are loaded.
-The _tep_add_plugin_path()_ function returns -1 in case of an error, 0 otherwise.
+The *tep_add_plugin_path()* function returns -1 in case of an error, 0 otherwise.
 
 EXAMPLE
 -------
@@ -121,7 +121,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_, _tep_set_flag(3)_
+*libtraceevent*(3), *trace-cmd*(1), *tep_set_flag*(3)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-record_parse.txt b/Documentation/libtraceevent-record_parse.txt
index 73a96542bbda..dbc3a76bc01c 100644
--- a/Documentation/libtraceevent-record_parse.txt
+++ b/Documentation/libtraceevent-record_parse.txt
@@ -30,19 +30,19 @@ DESCRIPTION
 -----------
 This set of functions can be used to extract common fields from a record.
 
-The _tep_data_type()_ function gets the event id from the record _rec_.
+The *tep_data_type()* function gets the event id from the record _rec_.
 It reads the "common_type" field. The _tep_ argument is the trace event parser
 context.
 
-The _tep_data_pid()_ function gets the process id from the record _rec_.
+The *tep_data_pid()* function gets the process id from the record _rec_.
 It reads the "common_pid" field. The _tep_ argument is the trace event parser
 context.
 
-The _tep_data_preempt_count()_ function gets the preemption count from the
+The *tep_data_preempt_count()* function gets the preemption count from the
 record _rec_. It reads the "common_preempt_count" field. The _tep_ argument is
 the trace event parser context.
 
-The _tep_data_flags()_ function gets the latency flags from the record _rec_.
+The *tep_data_flags()* function gets the latency flags from the record _rec_.
 It reads the "common_flags" field. The _tep_ argument is the trace event parser
 context. Supported latency flags are:
 [verse]
@@ -56,14 +56,14 @@ context. Supported latency flags are:
 
 RETURN VALUE
 ------------
-The _tep_data_type()_ function returns an integer, representing the event id.
+The *tep_data_type()* function returns an integer, representing the event id.
 
-The _tep_data_pid()_ function returns an integer, representing the process id
+The *tep_data_pid()* function returns an integer, representing the process id
 
-The _tep_data_preempt_count()_ function returns an integer, representing the
+The *tep_data_preempt_count()* function returns an integer, representing the
 preemption count.
 
-The _tep_data_flags()_ function returns an integer, representing the latency
+The *tep_data_flags()* function returns an integer, representing the latency
 flags. Look at the _trace_flag_type_ enum for supported flags.
 
 All these functions in case of an error return a negative integer.
@@ -115,7 +115,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-reg_event_handler.txt b/Documentation/libtraceevent-reg_event_handler.txt
index 1e5ec0e3c7e7..90ab7f05be66 100644
--- a/Documentation/libtraceevent-reg_event_handler.txt
+++ b/Documentation/libtraceevent-reg_event_handler.txt
@@ -25,7 +25,7 @@ typedef int (*pass:[*]tep_event_handler_func*)(struct trace_seq pass:[*]s, struc
 
 DESCRIPTION
 -----------
-The _tep_register_event_handler()_ function registers a handler function,
+The *tep_register_event_handler()* function registers a handler function,
 which is going to be called to parse the information for a given event.
 The _tep_ argument is the trace event parser context. The _id_ argument is
 the id of the event. The _sys_name_ argument is the name of the system,
@@ -39,8 +39,8 @@ one. This mechanism allows a developer to override the parsing of a given event.
 If for some reason the default print format is not sufficient, the developer
 can register a function for an event to be used to parse the data instead.
 
-The _tep_unregister_event_handler()_ function unregisters the handler function,
-previously registered with _tep_register_event_handler()_. The _tep_ argument
+The *tep_unregister_event_handler()* function unregisters the handler function,
+previously registered with *tep_register_event_handler()*. The _tep_ argument
 is the trace event parser context. The _id_, _sys_name_, _event_name_, _func_,
 and _context_ are the same arguments, as when the callback function _func_ was
 registered.
@@ -53,13 +53,13 @@ _context_ is custom context, set when the custom event handler is registered.
 
 RETURN VALUE
 ------------
-The _tep_register_event_handler()_ function returns _TEP_REGISTER_SUCCESS_
+The *tep_register_event_handler()* function returns _TEP_REGISTER_SUCCESS_
 if the new handler is registered successfully or
 _TEP_REGISTER_SUCCESS_OVERWRITE_ if an existing handler is overwritten.
 If there is not  enough memory to complete the registration,
 TEP_ERRNO__MEM_ALLOC_FAILED is returned.
 
-The _tep_unregister_event_handler()_ function returns 0 if _func_ was removed
+The *tep_unregister_event_handler()* function returns 0 if _func_ was removed
 successful or, -1 if the event was not found.
 
 The _tep_event_handler_func_ should return -1 in case of an error,
@@ -134,7 +134,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-reg_print_func.txt b/Documentation/libtraceevent-reg_print_func.txt
index c3b3849c0751..b3c84917c9fa 100644
--- a/Documentation/libtraceevent-reg_print_func.txt
+++ b/Documentation/libtraceevent-reg_print_func.txt
@@ -33,7 +33,7 @@ Some events may have helper functions in the print format arguments.
 This allows a plugin to dynamically create a way to process one of
 these functions.
 
-The _tep_register_print_function()_ registers such helper function. The _tep_
+The *tep_register_print_function()* registers such helper function. The _tep_
 argument is the trace event parser context. The _func_ argument  is a pointer
 to the helper function. The _ret_type_ argument is  the return type of the
 helper function, value from the _tep_func_arg_type_ enum. The _name_ is the name
@@ -41,8 +41,8 @@ of the helper function, as seen in the print format arguments. The _..._ is a
 variable list of _tep_func_arg_type_ enums, the _func_ function arguments.
 This list must end with _TEP_FUNC_ARG_VOID_. See 'EXAMPLE' section.
 
-The _tep_unregister_print_function()_ unregisters a helper function, previously
-registered with _tep_register_print_function()_. The _tep_ argument is the
+The *tep_unregister_print_function()* unregisters a helper function, previously
+registered with *tep_register_print_function()*. The _tep_ argument is the
 trace event parser context. The _func_ and _name_ arguments are the same, used
 when the helper function was registered.
 
@@ -53,10 +53,10 @@ registered.
 
 RETURN VALUE
 ------------
-The _tep_register_print_function()_ function returns 0 in case of success.
+The *tep_register_print_function()* function returns 0 in case of success.
 In case of an error, TEP_ERRNO_... code is returned.
 
-The _tep_unregister_print_function()_ returns 0 in case of success, or -1 in
+The *tep_unregister_print_function()* returns 0 in case of success, or -1 in
 case of an error.
 
 EXAMPLE
@@ -71,7 +71,7 @@ print fmt: "pipe %c, frame=%u, scanline=%u, wm %d/%d/%d, sr %s/%d/%d/%d, hpll %s
 	    REC->sr_cursor, REC->sr_fbc, yesno(REC->hpll), REC->hpll_plane,
 	    REC->hpll_cursor, REC->hpll_fbc, yesno(REC->fbc)
 --
-Notice the call to function _yesno()_ in the print arguments. In the kernel
+Notice the call to function *yesno()* in the print arguments. In the kernel
 context, this function has the following implementation:
 [source,c]
 --
@@ -83,9 +83,9 @@ static const char *yesno(int x)
 	return x ? yes : no;
 }
 --
-The user space event parser has no idea how to handle this _yesno()_ function.
-The _tep_register_print_function()_ API can be used to register a user space
-helper function, mapped to the kernel's _yesno()_:
+The user space event parser has no idea how to handle this *yesno()* function.
+The *tep_register_print_function()* API can be used to register a user space
+helper function, mapped to the kernel's *yesno()*:
 [source,c]
 --
 #include <event-parse.h>
@@ -133,7 +133,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-set_flag.txt b/Documentation/libtraceevent-set_flag.txt
index b75426b7e5c9..c11dd00ddbbc 100644
--- a/Documentation/libtraceevent-set_flag.txt
+++ b/Documentation/libtraceevent-set_flag.txt
@@ -37,17 +37,17 @@ _TEP_DISABLE_PLUGINS_ - disable all library plugins:
 			- in directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
 			- in user's home directory, _~/.traceevent/plugins_
 --
-Note: plugin related flags must me set before calling _tep_load_plugins()_ API.
+Note: plugin related flags must me set before calling *tep_load_plugins()* API.
 
-The _tep_set_flag()_ function sets _flag_ to _tep_ context.
+The *tep_set_flag()* function sets _flag_ to _tep_ context.
 
-The _tep_clear_flag()_ function clears _flag_ from _tep_ context.
+The *tep_clear_flag()* function clears _flag_ from _tep_ context.
 
-The _tep_test_flag()_ function tests if _flag_ is set to _tep_ context.
+The *tep_test_flag()* function tests if _flag_ is set to _tep_ context.
 
 RETURN VALUE
 ------------
-_tep_test_flag()_ function returns true if _flag_ is set, false otherwise.
+*tep_test_flag()* function returns true if _flag_ is set, false otherwise.
 
 EXAMPLE
 -------
@@ -82,7 +82,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-strerror.txt b/Documentation/libtraceevent-strerror.txt
index f1cef0541df3..fa53344f8269 100644
--- a/Documentation/libtraceevent-strerror.txt
+++ b/Documentation/libtraceevent-strerror.txt
@@ -16,7 +16,7 @@ int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, cha
 --
 DESCRIPTION
 -----------
-The _tep_strerror()_ function converts tep error number into a human
+The *tep_strerror()* function converts tep error number into a human
 readable string.
 The _tep_ argument is trace event parser context. The _errnum_ is a regular
 errno, defined in errno.h, or a tep error number. The string, describing this
@@ -24,13 +24,13 @@ error number is copied in the _buf_ argument. The _buflen_ argument is
 the size of the _buf_.
 
 It as a thread safe wrapper around strerror_r(). The library function has two
-different behaviors - POSIX and GNU specific. The _tep_strerror()_ API always
+different behaviors - POSIX and GNU specific. The *tep_strerror()* API always
 behaves as the POSIX version - the error string is copied in the user supplied
 buffer.
 
 RETURN VALUE
 ------------
-The _tep_strerror()_ function returns 0, if a valid _errnum_ is passed and the
+The *tep_strerror()* function returns 0, if a valid _errnum_ is passed and the
 string is copied into _buf_. If _errnum_ is not a valid error number,
 -1 is returned and _buf_ is not modified.
 
@@ -63,7 +63,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent-tseq.txt b/Documentation/libtraceevent-tseq.txt
index 066f5e0ffa67..03dd74829d4a 100644
--- a/Documentation/libtraceevent-tseq.txt
+++ b/Documentation/libtraceevent-tseq.txt
@@ -32,45 +32,45 @@ DESCRIPTION
 Trace sequences are used to allow a function to call several other functions
 to create a string of data to use.
 
-The _trace_seq_init()_ function initializes the trace sequence _s_.
+The *trace_seq_init()* function initializes the trace sequence _s_.
 
-The _trace_seq_destroy()_ function destroys the trace sequence _s_ and frees
+The *trace_seq_destroy()* function destroys the trace sequence _s_ and frees
 all its resources that it had used.
 
-The _trace_seq_reset()_ function re-initializes the trace sequence _s_. All
+The *trace_seq_reset()* function re-initializes the trace sequence _s_. All
 characters already written in _s_ will be deleted.
 
-The _trace_seq_terminate()_ function terminates the trace sequence _s_. It puts
+The *trace_seq_terminate()* function terminates the trace sequence _s_. It puts
 the null character pass:['\0'] at the end of the buffer.
 
-The _trace_seq_putc()_ function puts a single character _c_ in the trace
+The *trace_seq_putc()* function puts a single character _c_ in the trace
 sequence _s_.
 
-The _trace_seq_puts()_ function puts a NULL terminated string _str_ in the
+The *trace_seq_puts()* function puts a NULL terminated string _str_ in the
 trace sequence _s_.
 
-The _trace_seq_printf()_ function puts a formated string _fmt _with
+The *trace_seq_printf()* function puts a formated string _fmt _with
 variable arguments _..._ in the trace sequence _s_.
 
-The _trace_seq_vprintf()_ function puts a formated string _fmt _with
+The *trace_seq_vprintf()* function puts a formated string _fmt _with
 list of arguments _args_ in the trace sequence _s_.
 
-The _trace_seq_do_printf()_ function prints the buffer of trace sequence _s_ to
+The *trace_seq_do_printf()* function prints the buffer of trace sequence _s_ to
 the standard output stdout.
 
-The _trace_seq_do_fprintf()_ function prints the buffer of trace sequence _s_
+The *trace_seq_do_fprintf()* function prints the buffer of trace sequence _s_
 to the given file _fp_.
 
 RETURN VALUE
 ------------
-Both _trace_seq_putc()_ and _trace_seq_puts()_ functions return the number of
+Both *trace_seq_putc()* and *trace_seq_puts()* functions return the number of
 characters put in the trace sequence, or 0 in case of an error
 
-Both _trace_seq_printf()_ and _trace_seq_vprintf()_ functions return 0 if the
+Both *trace_seq_printf()* and *trace_seq_vprintf()* functions return 0 if the
 trace oversizes the buffer's free space, the number of characters printed, or
 a negative value in case of an error.
 
-Both _trace_seq_do_printf()_ and _trace_seq_do_fprintf()_ functions return the
+Both *trace_seq_do_printf()* and *trace_seq_do_fprintf()* functions return the
 number of printed characters, or -1 in case of an error.
 
 EXAMPLE
@@ -136,7 +136,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_
+*libtraceevent*(3), *trace-cmd*(1)
 
 AUTHOR
 ------
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 95465521bcf4..6476070737f5 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -175,7 +175,7 @@ FILES
 
 SEE ALSO
 --------
-_trace-cmd(1)_
+*trace-cmd*(1)
 
 AUTHOR
 ------
-- 
2.34.1

