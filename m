Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BDBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 04:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbiAQEhC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 16 Jan 2022 23:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiAQEhB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 16 Jan 2022 23:37:01 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD891C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 16 Jan 2022 20:37:00 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so19875704wme.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 16 Jan 2022 20:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PO9RHvOWxwbcwsqXPNIRpwwxKWxo74vLcDRbkWztRSw=;
        b=MCfbv2f8eVzTNpa5c/iGmc4fePeuyZrnHoZ5OVg5PuMehf02f2Di/KvdB6rau6/l4r
         8PDid5Ux4/VEzmR5cj3qzlv9x1xAFalISLUW/9cZrgdFQnrYPVIdzNstsiyfN6jbvbW3
         H0STzeOTN43QUqcPgipm50/nNy4u2y30GWFUoLAkh+djjvfAixGya2OoPU52eRs6VICG
         X2NAh19KCp8WXp7YtCBzhGKWW+kGNPF3d+cfs5UTCQaKrQIFqdb+kYyBkclQX35JYxN5
         Te2c50VtETAxlJzMrhX1oW4U+ZnvilTg7RwsxKwRApQTFDz5QlTEEZFfWgqJibxBh4fb
         LUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PO9RHvOWxwbcwsqXPNIRpwwxKWxo74vLcDRbkWztRSw=;
        b=R4QEz/RC3MuHHBQzrwNwmuXTe2rcYPUJQgbrPVQJdbtFjxFmp1JWrkV4o2bR2lN8RR
         6CIW7ND3/CRoZkXZL/U19ZN1kDxQ+8hWiCmK2NonaNmo2rwjBVQEtT+g4zdsIHxaC+UO
         +p9knLNf24MvmHAglgd+hJBqCUfO5nQdFjynKDlvo/OauXNU42ZR4SU4uNsuGhpXB9vj
         /5l2JzfMsvyDfkg9sfyiX3X7cT2IQaWytN3Dq97DnqwL41PPXixTZhogKm7hGh7aJN/3
         sBNxgMYOC2+Fd6WOcFHY6LZ0AkHWgJZJH6b5p20Qi5qC10eaCzrzuVSEIseSe9AvDQoa
         j+HA==
X-Gm-Message-State: AOAM533VjSwAz88ngLsG7+fxPkHmpRxePfWBVGUw/x0zjuHJoARAn+zv
        nnfW47jTRpAl/YUbX/bzY0ERob4jNhc=
X-Google-Smtp-Source: ABdhPJwLekS9SHCrioNNV93cZ9a8drlPkqMRXHGLul6HuOFxweT6IoM7Vl4nRG49x+T9JBnXED4myg==
X-Received: by 2002:a7b:c317:: with SMTP id k23mr18864167wmj.20.1642394218289;
        Sun, 16 Jan 2022 20:36:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g84sm16392173wme.7.2022.01.16.20.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 20:36:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Unify man pages style
Date:   Mon, 17 Jan 2022 06:36:55 +0200
Message-Id: <20220117043655.109662-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man pages of the library should have consistent view. There are some
differences in functions and arguments visualisation across current man
pages. Made the style of all pages consistent:
 - all function names in bold
 - all arguments are underlined.
Fixed also a few spelling mistakes.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---

v2 changes:
 - In man pages synopsis: make all enums in bold. 
		
 Documentation/libtracefs-error.txt            |   2 +-
 Documentation/libtracefs-events-tep.txt       |  18 +--
 Documentation/libtracefs-events.txt           |  39 +++---
 Documentation/libtracefs-files.txt            |  20 +--
 Documentation/libtracefs-filter.txt           |  12 +-
 Documentation/libtracefs-function-filter.txt  |   8 +-
 Documentation/libtracefs-hist-cont.txt        |  20 +--
 Documentation/libtracefs-hist.txt             | 127 +++++++++---------
 .../libtracefs-instances-affinity.txt         |  14 +-
 .../libtracefs-instances-file-manip.txt       |  26 ++--
 Documentation/libtracefs-instances-files.txt  |  14 +-
 Documentation/libtracefs-instances-manage.txt |  28 ++--
 Documentation/libtracefs-instances-utils.txt  |  16 +--
 Documentation/libtracefs-log.txt              |   4 +-
 Documentation/libtracefs-marker.txt           |  12 +-
 Documentation/libtracefs-marker_raw.txt       |  12 +-
 Documentation/libtracefs-option-get.txt       |  18 +--
 Documentation/libtracefs-option-misc.txt      |  10 +-
 Documentation/libtracefs-sql.txt              |   8 +-
 Documentation/libtracefs-stream.txt           |  14 +-
 Documentation/libtracefs-synth.txt            |  84 ++++++------
 Documentation/libtracefs-synth2.txt           |  55 ++++----
 Documentation/libtracefs-traceon.txt          |  18 +--
 Documentation/libtracefs-tracer.txt           |   4 +-
 Documentation/libtracefs-utils.txt            |  16 +--
 Documentation/libtracefs.txt                  |   2 +-
 26 files changed, 304 insertions(+), 297 deletions(-)

diff --git a/Documentation/libtracefs-error.txt b/Documentation/libtracefs-error.txt
index 8dd5b42..60e7554 100644
--- a/Documentation/libtracefs-error.txt
+++ b/Documentation/libtracefs-error.txt
@@ -13,7 +13,7 @@ SYNOPSIS
 *#include <tracefs.h>*
 
 char pass:[*]*tracefs_error_last*(struct tracefs_instance pass:[*]_instance_);
-char pass:[*]*tracefs_error_last*(struct tracefs_instance pass:[*]_instance_);
+char pass:[*]*tracefs_error_all*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_error_clear*(struct tracefs_instance pass:[*]_instance_);
 --
 
diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
index 752e830..af5f1d6 100644
--- a/Documentation/libtracefs-events-tep.txt
+++ b/Documentation/libtracefs-events-tep.txt
@@ -23,13 +23,13 @@ DESCRIPTION
 -----------
 Functions for initializing a tep handler with trace events from the local system.
 
-The _tracefs_local_events()_ function allocates a new _tep_ handler and
+The *tracefs_local_events()* function allocates a new _tep_ handler and
 initializes it with events from all trace systems, located in the given
 _tracing_dir_ directory. This could be NULL or the location of the tracefs
 mount point for the trace systems of the local machine, or it may be a path
 to a copy of the tracefs directory from another machine.
 
-The _tracefs_local_events_system()_ function allocates a new _tep_ handler
+The *tracefs_local_events_system()* function allocates a new _tep_ handler
 and initializes it with events from specified trace systems _sys_names_,
 located in the given _tracing_dir_ directory. This could be NULL or the
 location of the tracefs mount point for the trace systems of the local
@@ -38,7 +38,7 @@ machine. The _sys_names_ argument is an array of trace system names, that
 will be used for _tep_ handler initialization. The last element in that
 array must be a NULL pointer.
 
-The _tracefs_fill_local_events()_ function initializes already allocated _tep_
+The *tracefs_fill_local_events()* function initializes already allocated _tep_
 handler with events from all trace systems, located in the given _tracing_dir_
 directory. This could be NULL or the location of the tracefs mount point
 for the trace systems of the local machine, or it may be a path to a copy
@@ -51,20 +51,20 @@ The above functions will also load the mappings between pids and the process
 command line names. In some cases the _tep_ handle is created with one
 of the above before tracing begins. As the mappings get updated during the
 trace, there may be a need to read the mappings again after the trace.
-The _tracefs_load_cmdlines()_ does just that. The _tracing_dir_ is
-the director of the mount point to load from, or NULL to use the
+The *tracefs_load_cmdlines()* does just that. The _tracing_dir_ is
+the directory of the mount point to load from, or NULL to use the
 mount point of the tracefs file system.
 
 RETURN VALUE
 ------------
-The _tracefs_local_events()_ and _tracefs_local_events_system()_ functions
+The *tracefs_local_events()* and *tracefs_local_events_system()* functions
 return pointer to allocated and initialized _tep_ handler, or NULL in
-case of an error. The returned _tep_ handler must be freed with _tep_free(3)_.
+case of an error. The returned _tep_ handler must be freed with *tep_free(3)*.
 
-The _tracefs_fill_local_events()_ function returns -1 in case of an error or
+The *tracefs_fill_local_events()* function returns -1 in case of an error or
 0 otherwise.
 
-The _tracefs_load_cmdlines()_ function returns -1 in case of an error, or
+The *tracefs_load_cmdlines()* function returns -1 in case of an error, or
 0 otherwise.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index 102728d..eabce96 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -14,9 +14,14 @@ SYNOPSIS
 
 char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
 char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
-int *tracefs_event_enable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_);
-int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_);
-int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
+int *tracefs_event_enable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
+			   const char pass:[*]_event_);
+int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
+			    const char pass:[*]_event_);
+int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
+				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
+				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
+				 void pass:[*]_callback_context_);
 
 --
 
@@ -24,22 +29,22 @@ DESCRIPTION
 -----------
 Trace systems and events related APIs.
 
-The _tracefs_event_systems()_ function returns array of strings with the
+The *tracefs_event_systems()* function returns array of strings with the
 names of all registered trace systems, located in the given _tracing_dir_
 directory. This could be NULL or the location of the tracefs mount point
 for the trace systems of the local machine, or it may be a path to a copy
 of the tracefs directory from another machine. The last entry in the array
-is a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
+is a NULL pointer. The array must be freed with *tracefs_list_free()* API.
 
-The _tracefs_system_events()_ function returns array of strings with the
+The *tracefs_system_events()* function returns array of strings with the
 names of all registered trace events for given trace system specified by
 _system_, located in the given _tracing_dir_ directory. This could be NULL
 or the location of the tracefs mount point for the trace systems of the
 local machine, or it may be a path to a copy of the tracefs directory
 from another machine. The last entry in the array as a NULL pointer.
-The array must be freed with _tracefs_list_free()_ API.
+The array must be freed with *tracefs_list_free()* API.
 
-The _tracefs_event_enable()_ function enables a given event based on
+The *tracefs_event_enable()* function enables a given event based on
 the _system_ and _event_ passed in for the given _instance_. If _instance_
 is NULL, then the top level tracing directory is used. If _system_
 and _event_ are both NULL, then all events are enabled for the  _instance_.
@@ -48,17 +53,17 @@ If _system_ is NULL, then all systems are searched and any event within
 a system that matches _event_ is enabled. Both _system_ and _event_ may
 be regular expressions as defined by *regex*(3).
 
-The _tracefs_event_disable()_ function disables the events that match
+The *tracefs_event_disable()* function disables the events that match
 the _system_ and _event_ parameters for the given _instance_. What events
-are disable follow the same rules as _tracefs_event_enable()_ for matching
+are disable follow the same rules as *tracefs_event_enable()* for matching
 events. That is, if _instance_ is NULL, then the top level tracing directory
 is used. If both _system_ and _event_ are NULL then all events are disabled
 for the given _instance_, and so on.
 
-The _tracefs_iterate_raw_events()_ function will read the tracefs raw
+The *tracefs_iterate_raw_events()* function will read the tracefs raw
 data buffers and call the specified _callback_ function for every event it
 encounters. Events are iterated in sorted order: oldest first. An initialized
-_tep_ handler is required (See _tracefs_local_events_(3)). If _instance_ is
+_tep_ handler is required (See *tracefs_local_events*(3)). If _instance_ is
 NULL, then the toplevel tracefs buffer is used, otherwise the buffer for
 the corresponding _instance_ is read. To filter only on a subset of CPUs,
 _cpus_ and _cpu_size_ may be set to only call _callback_ with events that
@@ -73,19 +78,19 @@ returns non-zero, the iteration stops.
 
 RETURN VALUE
 ------------
-The _tracefs_event_systems()_ and __tracefs_system_events()_ functions return
+The *tracefs_event_systems()* and *tracefs_system_events()* functions return
 an array of strings. The last element in that array is a NULL pointer. The array
-must be freed with _tracefs_list_free()_ API. In case of an error, NULL is returned.
+must be freed with *tracefs_list_free()* API. In case of an error, NULL is returned.
 
-Both _tracefs_event_enable()_ and _tracefs_event_disable()_ return 0 if they found
+Both *tracefs_event_enable()* and *tracefs_event_disable()* return 0 if they found
 any matching events (Note it does not check the previous status of the event. If
-_tracefs_event_enable()_ finds an event that is already enabled, and there are no
+*tracefs_event_enable()* finds an event that is already enabled, and there are no
 other errors, then it will return 0). If an error occurs, even if other events were
 found, it will return -1 and errno will be set. If no errors occur, but no events
 are found that match the _system_ and _event_ parameters, then -1 is returned
 and errno is not set.
 
-The _tracefs_iterate_raw_events()_ function returns -1 in case of an error or
+The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
 0 otherwise.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index d6da507..00f12c3 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -22,17 +22,17 @@ DESCRIPTION
 This set of APIs can be used to find the full path of the trace file
 system mount point and trace files in it.
 
-The _tracefs_get_tracing_file()_ function returns the full path of the
+The *tracefs_get_tracing_file()* function returns the full path of the
 file with given _name_ in the trace file system. The function works
 only with files in the tracefs main directory, it is not trace instance
-aware. It is recommended to use _tracefs_instance_get_file()_ and
-_tracefs_instance_get_dir()_ instead. The returned string must be freed
-with _tracefs_put_tracing_file()_.
+aware. It is recommended to use *tracefs_instance_get_file()* and
+*tracefs_instance_get_dir()* instead. The returned string must be freed
+with *tracefs_put_tracing_file()*.
 
-The _tracefs_put_tracing_file()_ function frees trace file name,
-returned by _tracefs_get_tracing_file()_.
+The *tracefs_put_tracing_file()* function frees trace file name,
+returned by *tracefs_get_tracing_file()*.
 
-The _tracefs_tracing_dir()_ function returns the full path to the
+The *tracefs_tracing_dir()* function returns the full path to the
 trace file system. In the first function call, the mount point of the
 tracing file system is located, cached and returned. It will mount it,
 if it is not mounted. On any subsequent call the cached path is returned.
@@ -40,10 +40,10 @@ The return string must _not_ be freed.
 
 RETURN VALUE
 ------------
-The _tracefs_get_tracing_file()_ function returns a string or NULL in case
-of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
+The *tracefs_get_tracing_file()* function returns a string or NULL in case
+of an error. The returned string must be freed with *tracefs_put_tracing_file()*.
 
-The _tracefs_tracing_dir()_ function returns a constant string or NULL
+The *tracefs_tracing_dir()* function returns a constant string or NULL
 in case of an error. The returned string must _not_ be freed.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index f7bbb17..0bb88e2 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -12,12 +12,12 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_filter_string_append(struct tep_event pass:[*]event, char pass:[**] filter,
-				 struct tracefs_filter type, const char pass:[*]field,
-				 enum tracefs_synth_compare compare, const char pass:[*]val);
-int tracefs_filter_string_verify(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
-int tracefs_event_filter_apply(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event, const char pass:[*]filter);
-int tracefs_event_filter_clear(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event);
+int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
+				 struct tracefs_filter _type_, const char pass:[*]_field_,
+				 enum tracefs_synth_compare _compare_, const char pass:[*]_val_);
+int *tracefs_filter_string_verify*(struct tep_event pass:[*]_event_, const char pass:[*]_filter_, char pass:[**]_err_);
+int *tracefs_event_filter_apply*(struct tracefs_instance pass:[*]_instance_, struct tep_event pass:[*]_event_, const char pass:[*]_filter_);
+int *tracefs_event_filter_clear*(struct tracefs_instance pass:[*]_instance_, struct tep_event pass:[*]_event_);
 
 --
 
diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 23ba2b8..1a77d77 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -94,19 +94,19 @@ regular expression.
 RETURN VALUE
 ------------
 
-For _tracefs_function_filter_() and _tracefs_function_notrace()_ a
+For *tracefs_function_filter()* and *tracefs_function_notrace()* a
 return of 0 means success. If the there is an error but the filtering was not
 started, then 1 is returned. If filtering was started but an error occurs,
 then -1 is returned. The state of the filtering may be in an unknown state.
 
 If *TRACEFS_FL_CONTINUE* was set, and 0 or -1 was returned, then another call
-to tracefs_function_filter() must be done without *TRACEFS_FL_CONTINUE* set
+to *tracefs_function_filter()* must be done without *TRACEFS_FL_CONTINUE* set
 in order to commit (and close) the filtering.
 
-For _tracefs_filter_functions_(), a return of 0 means success, and the _list_
+For *tracefs_filter_functions()*, a return of 0 means success, and the _list_
 parameter is filled with a list of function names that matched _filter_ and
 _module_. _list_ is a string array, where the last string pointer in the
-array is NULL. The _list_ must be freed with _tracefs_list_free()_.
+array is NULL. The _list_ must be freed with *tracefs_list_free()*.
 On failure, a negative is returned, and _list_ is ignored.
 
 ERRORS
diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index b5cc726..b32a2cc 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -11,34 +11,34 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_hist_start(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
-int tracefs_hist_destory(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
-int tracefs_hist_pause(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
-int tracefs_hist_continue(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
-int tracefs_hist_reset(struct tracefs_instance pass:[*]instance, struct tracefs_hist pass:[*]hist);
+int *tracefs_hist_start*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+int *tracefs_hist_destroy*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+int *tracefs_hist_pause*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+int *tracefs_hist_continue*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+int *tracefs_hist_reset*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
 
 --
 
 DESCRIPTION
 -----------
 
-*tracefs_hist_start* is called to actually start the histogram _hist_.
+*tracefs_hist_start()* is called to actually start the histogram _hist_.
 The _instance_ is the instance to start the histogram in, NULL if it
 should start at the top level.
 
-*tracefs_hist_pause* is called to pause the histogram _hist_.
+*tracefs_hist_pause()* is called to pause the histogram _hist_.
 The _instance_ is the instance to pause the histogram in, NULL if it
 is in the top level.
 
-*tracefs_hist_continue* is called to continue a paused histogram _hist_.
+*tracefs_hist_continue()* is called to continue a paused histogram _hist_.
 The _instance_ is the instance to continue the histogram, NULL if it
 is in the top level.
 
-*tracefs_hist_reset* is called to clear / reset the histogram _hist_.
+*tracefs_hist_reset()* is called to clear / reset the histogram _hist_.
 The _instance_ is the instance to clear the histogram, NULL if it
 is in the top level.
 
-*tracefs_hist_destory* is called to delete the histogram where it will no longer
+*tracefs_hist_destroy()* is called to delete the histogram where it will no longer
 exist.  The _instance_ is the instance to delete the histogram from, NULL if it
 is in the top level.
 
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 3a167e8..d7ab709 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
-tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
+tracefs_hist_destroy, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
 tracefs_hist_echo_cmd, tracefs_hist_get_name, tracefs_hist_get_event, tracefs_hist_get_system - Create, update and describe event histograms
 
 SYNOPSIS
@@ -13,68 +13,68 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-enum tracefs_hist_key_type {
-	TRACEFS_HIST_KEY_NORMAL = 0,
-	TRACEFS_HIST_KEY_HEX,
-	TRACEFS_HIST_KEY_SYM,
-	TRACEFS_HIST_KEY_SYM_OFFSET,
-	TRACEFS_HIST_KEY_SYSCALL,
-	TRACEFS_HIST_KEY_EXECNAME,
-	TRACEFS_HIST_KEY_LOG,
-	TRACEFS_HIST_KEY_USECS,
-	TRACEFS_HIST_KEY_MAX
+enum *tracefs_hist_key_type* {
+	*TRACEFS_HIST_KEY_NORMAL* = 0,
+	*TRACEFS_HIST_KEY_HEX*,
+	*TRACEFS_HIST_KEY_SYM*,
+	*TRACEFS_HIST_KEY_SYM_OFFSET*,
+	*TRACEFS_HIST_KEY_SYSCALL*,
+	*TRACEFS_HIST_KEY_EXECNAME*,
+	*TRACEFS_HIST_KEY_LOG*,
+	*TRACEFS_HIST_KEY_USECS*,
+	*TRACEFS_HIST_KEY_MAX*
 };
 
-struct tracefs_hist_axis {
-	const char *key;
-	enum tracefs_hist_key_type type;
+struct *tracefs_hist_axis* {
+	const char pass:[*]_key_;
+	enum tracefs_hist_key_type _type_;
 };
 
-struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
-			const char pass:[*]system, const char pass:[*]event,
-			const char pass:[*]key, enum tracefs_hist_key_type type);
-struct tracefs_hist pass:[*]tracefs_hist_alloc_2d(struct tracefs_tep pass:[*] tep,
-			const char pass:[*]system, const char pass:[*]event,
-			const char pass:[*]key1, enum tracefs_hist_key_type type1,
-			const char pass:[*]key2, enum tracefs_hist_key_type type2));
-struct tracefs_hist pass:[*]tracefs_hist_alloc_nd(struct tracefs_tep pass:[*] tep,
-			const char pass:[*]system, const char pass:[*]event,
-			struct tracefs_hist_axis pass:[*]axes);
-void tracefs_hist_free(struct tracefs_hist pass:[*]hist);
+struct tracefs_hist pass:[*]*tracefs_hist_alloc*(struct tracefs_tep pass:[*] _tep_,
+			const char pass:[*]_system_, const char pass:[*]_event_,
+			const char pass:[*]_key_, enum tracefs_hist_key_type _type_);
+struct tracefs_hist pass:[*]*tracefs_hist_alloc_2d*(struct tracefs_tep pass:[*] _tep_,
+			const char pass:[*]_system_, const char pass:[*]_event_,
+			const char pass:[*]_key1_, enum tracefs_hist_key_type _type1_,
+			const char pass:[*]_key2_, enum tracefs_hist_key_type _type2_));
+struct tracefs_hist pass:[*]*tracefs_hist_alloc_nd*(struct tracefs_tep pass:[*] _tep_,
+			const char pass:[*]_system_, const char pass:[*]_event_,
+			struct tracefs_hist_axis pass:[*]_axes_);
+void *tracefs_hist_free*(struct tracefs_hist pass:[*]_hist_);
 
-int tracefs_hist_add_key(struct tracefs_hist pass:[*]hist, const char pass:[*]key,
-			 enum tracefs_hist_key_type type);
-int tracefs_hist_add_value(struct tracefs_hist pass:[*]hist, const char pass:[*]value);
-int tracefs_hist_add_sort_key(struct tracefs_hist pass:[*]hist,
-			      const char pass:[*]sort_key);
+int *tracefs_hist_add_key*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
+			 enum tracefs_hist_key_type _type_);
+int *tracefs_hist_add_value*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_value_);
+int *tracefs_hist_add_sort_key*(struct tracefs_hist pass:[*]_hist_,
+			      const char pass:[*]_sort_key_);
 
-int tracefs_hist_set_sort_key(struct tracefs_hist pass:[*]hist,
-			      const char pass:[*]sort_key, ...);
-int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
-				    const char pass:[*]sort_key,
-				    enum tracefs_hist_sort_direction dir);
+int *tracefs_hist_set_sort_key*(struct tracefs_hist pass:[*]_hist_,
+			      const char pass:[*]_sort_key_, _..._);
+int *tracefs_hist_sort_key_direction*(struct tracefs_hist pass:[*]_hist_,
+				    const char pass:[*]_sort_key_,
+				    enum tracefs_hist_sort_direction _dir_);
 
-int tracefs_hist_add_name(struct tracefs_hist pass:[*]hist, const char pass:[*]name);
+int *tracefs_hist_add_name*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_name_);
 
-int tracefs_hist_append_filter(struct tracefs_hist pass:[*]hist,
-			       enum tracefs_filter type,
-			       const char pass:[*]field,
-			       enum tracefs_compare compare,
-			       const char pass:[*]val);
+int *tracefs_hist_append_filter*(struct tracefs_hist pass:[*]_hist_,
+			       enum tracefs_filter _type_,
+			       const char pass:[*]_field_,
+			       enum tracefs_compare _compare_,
+			       const char pass:[*]_val_);
 
-int tracefs_hist_echo_cmd(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
-			  struct tracefs_hist pass:[*]hist,
-			  enum tracefs_hist_command command);
+int *tracefs_hist_echo_cmd*(struct trace_seq pass:[*]_s_, struct tracefs_instance pass:[*]_instance_,
+			  struct tracefs_hist pass:[*]_hist_,
+			  enum tracefs_hist_command _command_);
 
-int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
-			 struct tracefs_hist pass:[*]hist,
-			 enum tracefs_hist_command command);
+int *tracefs_hist_command*(struct tracefs_instance pass:[*]_instance_,
+			 struct tracefs_hist pass:[*]_hist_,
+			 enum tracefs_hist_command _command_);
 
-const char *tracefs_hist_get_name(struct tracefs_hist pass:[*]hist);
+const char pass:[*]*tracefs_hist_get_name*(struct tracefs_hist pass:[*]_hist_);
 
-const char *tracefs_hist_get_event(struct tracefs_hist pass:[*]hist);
+const char pass:[*]*tracefs_hist_get_event*(struct tracefs_hist pass:[*]_hist_);
 
-const char *tracefs_hist_get_system(struct tracefs_hist pass:[*]hist);
+const char pass:[*]*tracefs_hist_get_system*(struct tracefs_hist pass:[*]_hist_);
 
 --
 
@@ -108,7 +108,7 @@ histogram and returns the address of it. This descriptor must be freed by *trace
 The _tep_ is a trace event handle (see *tracefs_local_events*(3)), that holds the
 _system_ and _event_ that the histogram will be attached to. The _system_ is the
 system or group of the event. The _event_ is the event to attach the histogram to.
-The _axes_ is an array of _key_ / _type_ pairs, defining the dimentions of the histogram.
+The _axes_ is an array of _key_ / _type_ pairs, defining the dimensions of the histogram.
 
 *tracefs_hist_free*() frees the _tracefs_hist_ descriptor. Note, it does not stop
 or disable the running histogram if it was started. *tracefs_hist_destroy*() needs
@@ -119,23 +119,23 @@ The key passed to *tracefs_hist_alloc_nd*() is the primary key of the histogram.
 The first time this function is called, it will add a secondary key (or two dimensional
 histogram). If this function is called again on the same histogram, it will add
 a _tertiary_ key (or three dimensional histogram). The _hist_ parameter is the
-histrogram descriptor to add the _key_ to. The _type_ is the type of key to add
+histogram descriptor to add the _key_ to. The _type_ is the type of key to add
 (See KEY TYPES below).
 
 *tracefs_hist_add_value*() will add a value to record. By default, the value is
 simply the "hitcount" of the number of times a instance of the histogram's
 key was hit. The _hist_ is the histogram descriptor to add the value to.
-The _value_ is a field in the histogram to add to when an instane of the
+The _value_ is a field in the histogram to add to when an instance of the
 key is hit.
 
 *tracefs_hist_add_sort_key*() will add a key to sort on. The _hist_ is the
-histrogram descriptor to add the sort key to. The _sort_key_ is a string
+histogram descriptor to add the sort key to. The _sort_key_ is a string
 that must match either an already defined key of the histogram, or an already
 defined value. If _hist_  already has sorting keys (previously added) the new
 _sort_key_ will have lower priority(be secondary or so on) when sorting.
 
 *tracefs_hist_set_sort_key*() will reset the list of key to sort on. The _hist_ is
-the histrogram descriptor to reset the sort key to. The _sort_key_ is a string
+the histogram descriptor to reset the sort key to. The _sort_key_ is a string
 that must match either an already defined key of the histogram, or an already
 defined value. Multiple sort keys may be added to denote a secondary, sort order
 and so on, but all sort keys must match an existing key or value, or be
@@ -155,7 +155,7 @@ is the histogram to name, and the _name_ is the name to give it.
 
 *tracefs_hist_append_filter*() creates a filter or appends to it for the
 histogram  event. Depending on _type_, it will build a string of tokens for
-parenthesis or logic statemens, or it may add a comparison of _field_
+parenthesis or logic statements, or it may add a comparison of _field_
 to _val_ based on _compare_.
 
 If _type_ is:
@@ -167,7 +167,7 @@ If _type_ is:
 *TRACEFS_FILTER_CLOSE_PAREN* -  Append ")" to the filter
 
 _field_, _compare_, and _val_ are ignored unless _type_ is equal to
-*TRACEFS_FILTER_COMPARE*, then _compare will be used for the following:
+*TRACEFS_FILTER_COMPARE*, then _compare_ will be used for the following:
 
 *TRACEFS_COMPARE_EQ* - _field_ == _val_
 
@@ -213,15 +213,15 @@ KEY TYPES
 *tracefs_hist_alloc_nd*() and *tracefs_hist_add_key*() both add a key and requires
 that key to have a type. The types may be:
 
- *TRACEFS_HIST_KEY_NORMAL* or zero (0) which is to not modify the type.
+*TRACEFS_HIST_KEY_NORMAL* or zero (0) which is to not modify the type.
 
- *TRACEFS_HIST_KEY_HEX* to display the key in hex.
+*TRACEFS_HIST_KEY_HEX* to display the key in hex.
 
- *TRACEFS_HIST_KEY_SYM* to display the key as a kernel symbol (if found). If
+*TRACEFS_HIST_KEY_SYM* to display the key as a kernel symbol (if found). If
 the key is an address, this is useful as it will display the function names instead
 of just a number.
 
- *TRACEFS_HIST_KEY_SYM_OFFSET* similar to *TRACEFS_HIST_KEY_SYM* but will also include
+*TRACEFS_HIST_KEY_SYM_OFFSET* similar to *TRACEFS_HIST_KEY_SYM* but will also include
 the offset of the function to match the exact address.
 
 *TRACEFS_HIST_KEY_SYSCALL* If the key is a system call "id" (the number passed from user
@@ -236,6 +236,8 @@ instead of showing the number, show the name of the running task.
 *TRACEFS_HIST_KEY_USECS* for use with "common_timestamp" or TRACEFS_HIST_TIMESTAMP,
 in which case it will show the timestamp in microseconds instead of nanoseconds.
 
+RETURN VALUE
+------------
 *tracefs_hist_get_name*() returns the name of the histogram or NULL on error.
 The returned string belongs to the histogram object and is freed with the histogram
 by *tracefs_hist_free*().
@@ -248,9 +250,6 @@ by *tracefs_hist_free*().
 The returned string belongs to the histogram object and is freed with the histogram
 by *tracefs_hist_free*().
 
-
-RETURN VALUE
-------------
 *tracefs_hist_alloc_nd*() returns an allocated histogram descriptor which must
 be freed by *tracefs_hist_free*() or NULL on error.
 
diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index af04e79..f3e16d9 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_instance_set_affinity(struct tracefs_instace pass:[*]_instance_, const char pass:[*]_cpu_str_);
-int tracefs_instance_set_affinity_set(struct tracefs_instace pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
-int tracefs_instance_set_affinity_raw(struct tracefs_instace pass:[*]_instance_, const char pass:[*]_mask_);
+int *tracefs_instance_set_affinity*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_cpu_str_);
+int *tracefs_instance_set_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
+int *tracefs_instance_set_affinity_raw*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_mask_);
 
 --
 
@@ -24,9 +24,9 @@ These functions set the CPU affinity that limits what CPUs will have tracing ena
 for a given instance defined by the _instance_ parameter. If _instance_ is NULL, then
 the top level instance is affected.
 
-The _tracefs_instance_set_affinity()_ function takes a string _cpu_str_ that is a
+The *tracefs_instance_set_affinity()* function takes a string _cpu_str_ that is a
 list of CPUs to set the affinity for. If _cpu_str_ is NULL, then all the CPUs in
-the system will be set. The format of _cpu_str_ is a comma deliminated string of
+the system will be set. The format of _cpu_str_ is a comma delimited string of
 decimal numbers with no spaces. A range may be specified by a hyphen.
 
 For example: "1,4,6-8"
@@ -34,12 +34,12 @@ For example: "1,4,6-8"
 The numbers do not need to be in order except for ranges, where the second number
 must be equal to or greater than the first.
 
-The _tracefs_instance_set_affinity_set()_ function takes a CPU set defined by
+The *tracefs_instance_set_affinity_set()* function takes a CPU set defined by
 *CPU_SET(3)*. The size of the set defined by _set_size_ is the size in bytes of
 _set_. If _set_ is NULL then all the CPUs on the system will be set, and _set_size_
 is ignored.
 
-The _tracefs_instance_set_affinity_raw()_ function takes a string that holds
+The *tracefs_instance_set_affinity_raw()* function takes a string that holds
 a hexidecimal bitmask, where each 32 bits is separated by a comma. For a
 machine with more that 32 CPUs, to set CPUS 1-10 and CPU 40:
 
diff --git a/Documentation/libtracefs-instances-file-manip.txt b/Documentation/libtracefs-instances-file-manip.txt
index 942e7ad..3690594 100644
--- a/Documentation/libtracefs-instances-file-manip.txt
+++ b/Documentation/libtracefs-instances-file-manip.txt
@@ -30,47 +30,47 @@ Each of these APIs take an _instance_ argument, that can be NULL to act
 on the top level instance. Otherwise, it acts on an instance created with
 *tracefs_insance_create*(3)
 
-The _tracefs_instance_file_open()_ function opens trace _file_ from given _instance_ and returns
+The *tracefs_instance_file_open()* function opens trace _file_ from given _instance_ and returns
 a file descriptor to it. The file access _mode_ can be specified, see *open*(3) for more details.
 If -1 is passed as _mode_, default O_RDWR is used.
 
-The _tracefs_instance_file_write()_ function writes a string _str_ in a _file_ from
+The *tracefs_instance_file_write()* function writes a string _str_ in a _file_ from
 the given _instance_, without the terminating NULL character. When opening the file, this function
 tries to truncates the size of the file to zero, which clears all previously existing settings.
 
-The _tracefs_instance_file_append()_ function writes a string _str_ in a _file_ from
+The *tracefs_instance_file_append()* function writes a string _str_ in a _file_ from
 the given _instance_, without the terminating NULL character.  This function is similar to
-_tracefs_instance_file_write()_, but the existing content of the is not cleared. Thus the
+*tracefs_instance_file_write()*, but the existing content of the is not cleared. Thus the
 new settings are appended to the existing ones (if any).
 
-The _tracefs_instance_file_clear()_ function tries to truncates the size of the file to zero,
+The *tracefs_instance_file_clear()* function tries to truncates the size of the file to zero,
 which clears all previously existing settings. If the file has content that does not get
 cleared in this way, this will not have any effect.
 
-The _tracefs_instance_file_read()_ function reads the content of a _file_ from
+The *tracefs_instance_file_read()* function reads the content of a _file_ from
 the given _instance_.
 
-The _tracefs_instance_file_read_number()_ function reads the content of a _file_ from
+The *tracefs_instance_file_read_number()* function reads the content of a _file_ from
 the given _instance_ and converts it to a long long integer, which is stored in _res_.
 
 RETURN VALUE
 ------------
-The _tracefs_instance_file_open()_ function returns a file descriptor to the opened file. It must be
+The *tracefs_instance_file_open()* function returns a file descriptor to the opened file. It must be
 closed with *close*(3). In case of an error, -1 is returned.
 
-The _tracefs_instance_file_write()_ function returns the number of written bytes,
+The *tracefs_instance_file_write()* function returns the number of written bytes,
 or -1 in case of an error.
 
-The _tracefs_instance_file_append()_ function returns the number of written bytes,
+The *tracefs_instance_file_append()* function returns the number of written bytes,
 or -1 in case of an error.
 
-The _tracefs_instance_file_clear()_ function returns 0 on success, or -1 in case of an error.
+The *tracefs_instance_file_clear()* function returns 0 on success, or -1 in case of an error.
 
-The _tracefs_instance_file_read()_ function returns a pointer to a NULL terminated
+The *tracefs_instance_file_read()* function returns a pointer to a NULL terminated
 string, read from the file, or NULL in case of an error. The returned string must
 be freed with free().
 
-The _tracefs_instance_file_read_number()_ function returns 0 if a valid integer is read from
+The *tracefs_instance_file_read_number()* function returns 0 if a valid integer is read from
 the file and stored in _res_ or -1 in case of an error.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index 4ac87d1..c289c82 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -26,26 +26,26 @@ Each of these APIs take an _instance_ argument, that can be NULL to act
 on the top level instance. Otherwise, it acts on an instance created with
 *tracefs_insance_create*(3)
 
-The _tracefs_file_exists()_ function checks if a file with _name_ exists in _instance_.
+The *tracefs_file_exists()* function checks if a file with _name_ exists in _instance_.
 
-The _tracefs_dir_exists()_ function checks if a directory with _name_ exists in _instance_.
+The *tracefs_dir_exists()* function checks if a directory with _name_ exists in _instance_.
 
-The _tracefs_instance_get_file()_ function returns the full path of the file
+The *tracefs_instance_get_file()* function returns the full path of the file
 with given _name_ in _instance_. Note, it does not check if the file exists in
 the instance.
 
-The _tracefs_instance_get_dir()_ function  returns the full path of the directory
+The *tracefs_instance_get_dir()* function  returns the full path of the directory
 with given _name_ in _instance_. Note, it does not check if the directory exists
 in the instance.
 
 RETURN VALUE
 ------------
-The _tracefs_file_exists()_ and  _tracefs_dir_exists()_ functions return true if the
+The *tracefs_file_exists()* and *tracefs_dir_exists()* functions return true if the
 file / directory exist in the given instance or false if it does not exist.
 
-The _tracefs_instance_get_file()_ and _tracefs_instance_get_dir()_ functions return
+The *tracefs_instance_get_file()* and *tracefs_instance_get_dir()* functions return
 a string or NULL in case of an error. The returned string must be freed with
-_tracefs_put_tracing_file()_.
+*tracefs_put_tracing_file()*.
 
 EXAMPLE
 -------
diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 2ba48c4..2b0b662 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -28,45 +28,45 @@ name, the events enabled in an instance do not affect the main tracing
 system, nor other instances, as events enabled in the main tracing system
 or other instances do not affect the given instance.
 
-The _tracefs_instance_create()_ function allocates and initializes a new
+The *tracefs_instance_create()* function allocates and initializes a new
 tracefs_instance structure and returns it. If the instance with _name_ does
 not yet exist in the system, it will be created. The _name_ could be NULL,
-then the new tracefs_instance structure is initialised for the top instance.
+then the new tracefs_instance structure is initialized for the top instance.
 Note that the top instance cannot be created in the system, if it does not
 exist.
 
-The _tracefs_instance_destroy()_ removes the instance from the system, but
-does not free the structure. _tracefs_instance_free()__ must still be called
+The *tracefs_instance_destroy()* removes the instance from the system, but
+does not free the structure. *tracefs_instance_free()* must still be called
 on _instance_.
 
-The _tracefs_instance_alloc()_ function allocates a new tracefs_instance structure
+The tracefs_instance_alloc()* function allocates a new tracefs_instance structure
 for existing trace instance. If the instance does not exist in the system, the function
 fails. The _tracing_dir_ parameter points to the system trace directory. It can be
 NULL, then default system trace directory is used. This parameter is useful to allocate
 instances to trace directories, copied from another machine. The _name_ is the name of
 the instance, or NULL for the top instance in the given _tracing_dir_.
 
-The _tracefs_instance_free()_ function frees the tracefs_instance structure,
+The *tracefs_instance_free()* function frees the tracefs_instance structure,
 without removing the trace instance from the system.
 
-The _tracefs_instance_is_new()_ function checks if the given _instance_ is
-newly created by _tracefs_instance_create()_, or it has been in the system
+The *tracefs_instance_is_new()* function checks if the given _instance_ is
+newly created by *tracefs_instance_create()*, or it has been in the system
 before that.
 
 RETURN VALUE
 ------------
-The _tracefs_instance_create()_ and _tracefs_instance_alloc()_ functions return a pointer to
-a newly allocated tracefs_instance structure. It must be freed with _tracefs_instance_free()_.
+The *tracefs_instance_create()* and *tracefs_instance_alloc()* functions return a pointer to
+a newly allocated tracefs_instance structure. It must be freed with *tracefs_instance_free()*.
 
-The _tracefs_instance_destroy()_ function returns 0 if it succeeds to remove
+The *tracefs_instance_destroy()* function returns 0 if it succeeds to remove
 the instance, otherwise it returns -1 if the instance does not exist or it
 fails to remove it.
 
-The _tracefs_instance_is_new()_ function returns true if the
-_tracefs_instance_create()_ that allocated _instance_ also created the
+The *tracefs_instance_is_new()* function returns true if the
+*tracefs_instance_create()* that allocated _instance_ also created the
 trace instance in the system, or false if the trace instance already
 existed in the system when _instance_ was allocated by
-_tracefs_instance_create()_ or _tracefs_instance_alloc()_.
+*tracefs_instance_create()* or *tracefs_instance_alloc()*.
 
 EXAMPLE
 -------
diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index f559406..8a2b614 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -24,33 +24,33 @@ DESCRIPTION
 -----------
 Helper functions for working with trace instances.
 
-The _tracefs_instance_get_name()_ function returns the name of the given _instance_.
+The *tracefs_instance_get_name()* function returns the name of the given _instance_.
 Note that the top instance has no name, the function returns NULL for it.
 
-The _tracefs_instance_get_trace_dir()_ function returns the tracing directory, where
+The *tracefs_instance_get_trace_dir()* function returns the tracing directory, where
 the given _instance_ is configured.
 
-The _tracefs_instances_walk()_ function walks through all configured tracing
+The *tracefs_instances_walk()* function walks through all configured tracing
 instances in the system and calls _callback_ for each one of them. The _context_
 argument is passed to the _callback_, together with the instance name. If the
 _callback_ returns non-zero, the iteration stops. Note, the _callback_ is not
 called for the top top instance.
 
-The _tracefs_instance_exists()_ function checks if an instance with the given
+The *tracefs_instance_exists()* function checks if an instance with the given
 _name_ exists in the system.
 
 RETURN VALUE
 ------------
-The _tracefs_instance_get_name()_ returns a string or NULL in case of the top
+The *tracefs_instance_get_name()* returns a string or NULL in case of the top
 instance. The returned string must _not_ be freed.
 
-The _tracefs_instance_get_trace_dir()_ returns a string or NULL in case of an error.
+The *tracefs_instance_get_trace_dir()* returns a string or NULL in case of an error.
 The returned string must _not_ be freed.
 
-The _tracefs_instances_walk()_ function returns 0, if all instances were iterated, 1
+The *tracefs_instances_walk()* function returns 0, if all instances were iterated, 1
 if the iteration was stopped by the _callback_, or -1 in case of an error.
 
-The _tracefs_instance_exists()_ returns true if an instance with the given name
+The *tracefs_instance_exists()* returns true if an instance with the given _name_
 exists in the system or false otherwise.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-log.txt b/Documentation/libtracefs-log.txt
index a4107e8..7b562c7 100644
--- a/Documentation/libtracefs-log.txt
+++ b/Documentation/libtracefs-log.txt
@@ -16,8 +16,8 @@ int *tracefs_set_loglevel*(enum tep_loglevel _level_);
 
 DESCRIPTION
 -----------
-The _tracefs_set_loglevel()_ function sets the level of the library logs that will be printed on
-the console. See _libtraceevent(3)_ for detailed desciription of the log levels. Setting the log
+The *tracefs_set_loglevel()* function sets the level of the library logs that will be printed on
+the console. See _libtraceevent(3)_ for detailed description of the log levels. Setting the log
 level to specific value means that logs from the previous levels will be printed too. For example
 _TEP_LOG_WARNING_ will print any logs with severity _TEP_LOG_WARNING_, _TEP_LOG_ERROR_ and
 _TEP_LOG_CRITICAL_. The default log level is _TEP_LOG_CRITICAL_.  When a new level is set, it is
diff --git a/Documentation/libtracefs-marker.txt b/Documentation/libtracefs-marker.txt
index 1905662..fdab4a4 100644
--- a/Documentation/libtracefs-marker.txt
+++ b/Documentation/libtracefs-marker.txt
@@ -26,23 +26,23 @@ See Documentation/trace/ftrace.rst from the Linux kernel tree for more informati
 data from user space in the trace buffer. All these APIs have _instance_ as a first argument. If
 NULL is passed as _instance_, the top trace instance is used.
 
-The _tracefs_print_init()_ function initializes the library for writing into the trace buffer of
+The *tracefs_print_init()* function initializes the library for writing into the trace buffer of
 the selected _instance_. It is not mandatory to call this API before writing strings, any of
 the printf APIs will call it automatically, if the library is not yet initialized. But calling
-_tracefs_print_init()_ in advance will speed up the writing.
+*tracefs_print_init()* in advance will speed up the writing.
 
-The _tracefs_printf()_ function writes a formatted string in the trace buffer of the selected
+The *tracefs_printf()* function writes a formatted string in the trace buffer of the selected
 _instance_. The _fmt_ argument is a string in printf format, followed by variable arguments _..._.
 
-The _tracefs_vprintf()_ function writes a formatted string in the trace buffer of the selected
+The *tracefs_vprintf()* function writes a formatted string in the trace buffer of the selected
 _instance_. The _fmt_ argument is a string in printf format, followed by list _ap_ of arguments.
 
-The _tracefs_print_close()_ function closes the resources, used by the library for writing in
+The *tracefs_print_close()* function closes the resources, used by the library for writing in
 the trace buffer of the selected instance.
 
 RETURN VALUE
 ------------
-The _tracefs_print_init()_, _tracefs_printf()_, and _tracefs_vprintf()_ functions return 0 if
+The *tracefs_print_init()*, *tracefs_printf()*, and *tracefs_vprintf()* functions return 0 if
 the operation is successful, or -1 in case of an error.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-marker_raw.txt b/Documentation/libtracefs-marker_raw.txt
index f53ac72..e4ebadc 100644
--- a/Documentation/libtracefs-marker_raw.txt
+++ b/Documentation/libtracefs-marker_raw.txt
@@ -25,21 +25,21 @@ See Documentation/trace/ftrace.rst from the Linux kernel tree for more informati
 data from user space in the trace buffer. All these APIs have _instance_ as a first argument. If
 NULL is passed as _instance_, the top trace instance is used.
 
-The _tracefs_binary_init()_ function initializes the library for writing into the trace buffer of
+The *tracefs_binary_init()* function initializes the library for writing into the trace buffer of
 the selected _instance_. It is not mandatory to call this API before writing data, the
-_tracefs_binary_write()_ will call it automatically, if the library is not yet initialized.
-But calling _tracefs_binary_init()_ in advance will speed up the writing.
+*tracefs_binary_write()* will call it automatically, if the library is not yet initialized.
+But calling *tracefs_binary_init()* in advance will speed up the writing.
 
-The _tracefs_binary_write()_ function writes a binary data in the trace buffer of the selected
+The *tracefs_binary_write()* function writes a binary data in the trace buffer of the selected
 _instance_. The _data_ points to the data with length _len_, that is going to be written in
 the trace buffer.
 
-The _tracefs_binary_close()_ function closes the resources, used by the library for writing in
+The *tracefs_binary_close()* function closes the resources, used by the library for writing in
 the trace buffer of the selected instance.
 
 RETURN VALUE
 ------------
-The _tracefs_binary_init()_, and _tracefs_binary_write()_ functions return 0 if the operation is
+The *tracefs_binary_init()*, and *tracefs_binary_write()* functions return 0 if the operation is
 successful, or -1 in case of an error.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index ea5e21b..815e77f 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -25,35 +25,35 @@ DESCRIPTION
 This set of APIs can be used to get and check current ftrace options. Supported ftrace options may
 depend on the kernel version and the kernel configuration.
 
-The _tracefs_options_get_supported()_ function gets all ftrace options supported by the system in
+The *tracefs_options_get_supported()* function gets all ftrace options supported by the system in
 the given _instance_. If _instance_ is NULL, supported options of the top trace instance are
 returned. The set of supported options is the same in all created trace instances, but may be different
 than the top trace instance.
 
-The _tracefs_option_is_supported()_ function checks if the option with given _id_ is supported by
+The *tracefs_option_is_supported()/ function checks if the option with given _id_ is supported by
 the system in the given _instance_. If _instance_ is NULL, the top trace instance is used. If an
 option is supported at the top trace instance, it it may not be supported in a created trace instance.
 
-The _tracefs_options_get_enabled()_ function gets all ftrace options, currently enabled in
+The *tracefs_options_get_enabled()* function gets all ftrace options, currently enabled in
 the given _instance_. If _instance_ is NULL, enabled options of the top trace instance are returned.
 
-The _tracefs_option_is_enabled()_ function checks if the option with given _id_ is enabled in the
+The *tracefs_option_is_enabled()* function checks if the option with given _id_ is enabled in the
 given _instance_. If _instance_ is NULL, the top trace instance is used.
 
-The _tracefs_option_mask_is_set()_ function checks if the bit, corresponding to the option with _id_ is
-set in the _options_ bitmask returned from _tracefs_option_get_enabled()_ and _tracefs_option_is_supported()_.
+The *tracefs_option_mask_is_set()* function checks if the bit, corresponding to the option with _id_ is
+set in the _options_ bitmask returned from *tracefs_option_get_enabled()* and *tracefs_option_is_supported()*.
 
 RETURN VALUE
 ------------
-The _tracefs_options_get_supported()_ and _tracefs_options_get_enabled()_ functions, on success,
+The *tracefs_options_get_supported()* and *tracefs_options_get_enabled()* functions, on success,
 return a pointer to the bitmask within the instance, or a global bitmask for the top level,
 or NULL in case of an error. As the returned bitmask is part of the instance structure (or a
 global variable) and must not be freed or modified.
 
-The _tracefs_option_is_supported()_ and _tracefs_option_is_enabled()_ functions return true if the
+The *tracefs_option_is_supported()* and *tracefs_option_is_enabled()* functions return true if the
 option in supported / enabled, or false otherwise.
 
-The _tracefs_option_mask_is_set()_ returns true if the corresponding option is set in the mask
+The *tracefs_option_mask_is_set()* returns true if the corresponding option is set in the mask
 or false otherwise.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-option-misc.txt b/Documentation/libtracefs-option-misc.txt
index 4258910..552aaed 100644
--- a/Documentation/libtracefs-option-misc.txt
+++ b/Documentation/libtracefs-option-misc.txt
@@ -21,22 +21,22 @@ DESCRIPTION
 -----------
 This set of APIs can be used to enable and disable ftrace options and to get the name of an option.
 
-The _tracefs_option_enable()_ function enables the option with _id_ in the given _instance_. If
+The *tracefs_option_enable()* function enables the option with _id_ in the given _instance_. If
 _instance_ is NULL, the option is enabled in the top trace instance.
 
-The _tracefs_option_disable()_ function disables the option with _id_ in the given _instance_. If
+The *tracefs_option_disable()* function disables the option with _id_ in the given _instance_. If
 _instance_ is NULL, the option is disabled in the top trace instance.
 
-The _tracefs_option_name()_ function returns a string, representing the option with _id_. The string
+The *tracefs_option_name()* function returns a string, representing the option with _id_. The string
 must *not* be freed.
 
 
 RETURN VALUE
 ------------
-The _tracefs_option_enable()_ and _tracefs_option_disable()_ functions return 0 if the state of the
+The *tracefs_option_enable()* and *tracefs_option_disable()* functions return 0 if the state of the
 option is set successfully, or -1 in case of an error.
 
-The _tracefs_option_name()_ function returns string with option name, or "unknown" in case of an
+The *tracefs_option_name()* function returns string with option name, or "unknown" in case of an
 error. The returned string must *not* be freed.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 8c765eb..b7ddbb2 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_sql - Create a synthetitc event via an SQL statement
+tracefs_sql - Create a synthetic event via an SQL statement
 
 SYNOPSIS
 --------
@@ -11,8 +11,8 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_synth *tracefs_sql(struct tep_handle pass:[*]tep, const char pass:[*]name,
-				  const char pass:[*]sql_buffer, char pass:[**]err);
+struct tracefs_synth pass:[*]*tracefs_sql*(struct tep_handle pass:[*]_tep_, const char pass:[*]_name_,
+					const char pass:[*]_sql_buffer_, char pass:[**]_err_);
 --
 
 DESCRIPTION
@@ -35,7 +35,7 @@ be created from two different events.
 For simple SQL queries to make a histogram instead of a synthetic event, see
 HISTOGRAMS below.
 
-*tracefs_sql*() takes in a *tep* handler (See _tep_local_events_(3)) that is used to
+*tracefs_sql*() takes in a _tep_ handler (See _tep_local_events_(3)) that is used to
 verify the events within the _sql_buffer_ expression. The _name_ is the name of the
 synthetic event to create. If _err_ points to an address of a string, it will be filled
 with a detailed message on any type of parsing error, including fields that do not belong
diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index 68ec8c3..d8c61c6 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
-ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
-void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
+ssize_t *tracefs_trace_pipe_stream*(int _fd_, struct tracefs_instance pass:[*]_instance_, int _flags_);
+ssize_t *tracefs_trace_pipe_print*(struct tracefs_instance pass:[*]_instance_, int _flags_);
+void *tracefs_trace_pipe_stop*(struct tracefs_instance pass:[*]_instance_);
 
 
 --
@@ -23,24 +23,24 @@ DESCRIPTION
 -----------
 If NULL is passed as _instance_, the top trace instance is used.
 
-The reading of the trace_pipe file can be stopped by calling tracefs_trace_pipe_stop()
+The reading of the trace_pipe file can be stopped by calling *tracefs_trace_pipe_stop()*
 which could be placed in a signal handler in case the application wants to stop the
 reading, for example, with the user pressing Ctrl-C.
 
-The _tracefs_trace_pipe_stream()_ function redirects the stream of trace data to an output
+The *tracefs_trace_pipe_stream()* function redirects the stream of trace data to an output
 file. The "splice" system call is used to moves the data without copying between kernel
 address space and user address space. The _fd_ is the file descriptor of the output file
 and _flags_ is a bit mask of flags to be passed to the open system call of the trace_pipe
 file (see ). If flags contain O_NONBLOCK, then that is also passed to the splice calls
 that may read the file to the output stream file descriptor.
 
-The _tracefs_trace_pipe_print()_ function is similar to _tracefs_trace_pipe_stream()_, but
+The *tracefs_trace_pipe_print()* function is similar to *tracefs_trace_pipe_stream()*, but
 the stream of trace data is redirected to stdout.
 
 
 RETURN VALUE
 ------------
-The _tracefs_trace_pipe_stream()_, and _tracefs_trace_pipe_print()_ functions return the
+The *tracefs_trace_pipe_stream()*, and *tracefs_trace_pipe_print()* functions return the
 number of bytes transfered if the operation is successful, or -1 in case of an error.
 
 EXAMPLE
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index 370a63b..fe28060 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -13,41 +13,41 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_synth pass:[*]tracefs_synth_alloc(struct tep_handle pass:[*]tep,
-					 const char pass:[*]name,
-					 const char pass:[*]start_system,
-					 const char pass:[*]start_event,
-					 const char pass:[*]end_system,
-					 const char pass:[*]end_event,
-					 const char pass:[*]start_match_field,
-					 const char pass:[*]end_match_field,
-					 const char pass:[*]match_name);
-int tracefs_synth_add_match_field(struct tracefs_synth pass:[*]synth,
-				  const char pass:[*]start_match_field,
-				  const char pass:[*]end_match_field,
-				  const char pass:[*]name);
-int tracefs_synth_add_compare_field(struct tracefs_synth pass:[*]synth,
-				    const char pass:[*]start_compare_field,
-				    const char pass:[*]end_compare_field,
-				    enum tracefs_synth_calc calc,
-				    const char pass:[*]name);
-int tracefs_synth_add_start_field(struct tracefs_synth pass:[*]synth,
-				  const char pass:[*]start_field,
-				  const char pass:[*]name);
-int tracefs_synth_add_end_field(struct tracefs_synth pass:[*]synth,
-				const char pass:[*]end_field,
-				const char pass:[*]name);
-int tracefs_synth_append_start_filter(struct tracefs_synth pass:[*]synth,
-				      struct tracefs_filter type,
-				      const char pass:[*]field,
-				      enum tracefs_synth_compare compare,
-				      const char pass:[*]val);
-int tracefs_synth_append_end_filter(struct tracefs_synth pass:[*]synth,
-				    struct tracefs_filter type,
-				    const char pass:[*]field,
-				    enum tracefs_synth_compare compare,
-				    const char pass:[*]val);
--void tracefs_synth_free(struct tracefs_synth pass:[*]synth);
+struct tracefs_synth pass:[*]*tracefs_synth_alloc*(struct tep_handle pass:[*]_tep_,
+					 const char pass:[*]_name_,
+					 const char pass:[*]_start_system_,
+					 const char pass:[*]_start_event_,
+					 const char pass:[*]_end_system_,
+					 const char pass:[*]_end_event_,
+					 const char pass:[*]_start_match_field_,
+					 const char pass:[*]_end_match_field_,
+					 const char pass:[*]_match_name_);
+int *tracefs_synth_add_match_field*(struct tracefs_synth pass:[*]_synth_,
+				  const char pass:[*]_start_match_field_,
+				  const char pass:[*]_end_match_field_,
+				  const char pass:[*]_name_);
+int *tracefs_synth_add_compare_field*(struct tracefs_synth pass:[*]_synth_,
+				    const char pass:[*]_start_compare_field_,
+				    const char pass:[*]_end_compare_field_,
+				    enum tracefs_synth_calc _calc_,
+				    const char pass:[*]_name_);
+int *tracefs_synth_add_start_field*(struct tracefs_synth pass:[*]_synth_,
+				  const char pass:[*]_start_field_,
+				  const char pass:[*]_name_);
+int *tracefs_synth_add_end_field*(struct tracefs_synth pass:[*]_synth_,
+				const char pass:[*]_end_field_,
+				const char pass:[*]_name_);
+int *tracefs_synth_append_start_filter*(struct tracefs_synth pass:[*]_synth_,
+				      struct tracefs_filter _type_,
+				      const char pass:[*]_field_,
+				      enum tracefs_synth_compare _compare_,
+				      const char pass:[*]_val_);
+int *tracefs_synth_append_end_filter*(struct tracefs_synth pass:[*]_synth_,
+				    struct tracefs_filter _type_,
+				    const char pass:[*]_field_,
+				    enum tracefs_synth_compare _compare_,
+				    const char pass:[*]_val_);
+void *tracefs_synth_free*(struct tracefs_synth pass:[*]_synth_);
 --
 
 DESCRIPTION
@@ -74,7 +74,7 @@ It does not create the synthetic event, but supplies the minimal information
 to do so. See *tracefs_synth_create*(3) for how to create the synthetic
 event in the system. It requires a _tep_ handler that can be created by
 *tracefs_local_events*(3) for more information. The _name_ holds the name
-of the synthetic event that will be created. The _start_system is the name
+of the synthetic event that will be created. The _start_system_ is the name
 of the system for the starting event. It may be NULL and the first event
 with the name of _start_event_ will be chosen. The _end_system_ is the
 name of the system for theh ending event. It may be NULL and the first event
@@ -88,7 +88,7 @@ not be recorded in the created synthetic event.
 starting event and the ending event. If _name_ is given, then the content
 of the matching field will be saved by this _name_ in the synthetic event.
 The _start_match_field_ is the field of the starting event to mach with the
-ending event's _end_match_field.
+ending event's _end_match_field_.
 
 *tracefs_synth_add_compare_field*() is used to compare the _start_compare_field_
 of the starting event with the _end_compare_field_ of the ending event. The _name_
@@ -100,17 +100,17 @@ can be one of:
 *TRACEFS_SYNTH_DELTA_END* - calculate the difference between the content in
  the _end_compare_field_ from the content of the _start_compare_field_.
 
- _name_ = _end_compare_field_ - _start_compare_field_
+_name_ = _end_compare_field_ - _start_compare_field_
 
 *TRACEFS_SYNTH_DELTA_START* - calculate the difference between the content in
  the _start_compare_field_ from the content of the _end_compare_field_.
 
- _name_ = _start_compare_field_ - _end_compare_field_
+_name_ = _start_compare_field_ - _end_compare_field_
 
 *TRACEFS_SYNTH_ADD* - Add the content of the _start_compare_field_ to the
   content of the _end_compare_field_.
 
- _name_ = _start_compare_field_ + _end_compare_field_
+_name_ = _start_compare_field_ + _end_compare_field_
 
 *tracefs_synth_add_start_field*() - Records the _start_field_ of the starting
 event as _name_ in the synthetic event. If _name_ is NULL, then the name used
@@ -122,7 +122,7 @@ will be the same as _end_field_.
 
 *tracefs_synth_append_start_filter*() creates a filter or appends to it for the
 starting event. Depending on _type_, it will build a string of tokens for
-parenthesis or logic statemens, or it may add a comparison of _field_
+parenthesis or logic statements, or it may add a comparison of _field_
 to _val_ based on _compare_.
 
 If _type_ is:
@@ -161,7 +161,7 @@ filters on the ending event.
 RETURN VALUE
 ------------
 *tracefs_synth_alloc*() returns an allocated struct tracefs_synth descriptor
-on sucess or NULL on error.
+on success or NULL on error.
 
 All other functions that return an integer returns zero on success or -1
 on error.
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 8056ab8..b542e85 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -14,24 +14,24 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_synth_create(struct tracefs_synth pass:[*]synth);
-int tracefs_synth_destroy(struct tracefs_synth pass:[*]synth);
-int tracefs_synth_echo_cmd(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
-bool tracefs_synth_complete(struct tracefs_synth pass:[*]synth);
-struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pass:[*]synth);
-
-int tracefs_synth_trace(struct tracefs_synth pass:[*]synth,
-			enum tracefs_synth_handler type, const char pass:[*]var);
-int tracefs_synth_snapshot(struct tracefs_synth pass:[*]synth,
-			   enum tracefs_synth_handler type, const char pass:[*]var);
-int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
-		       enum tracefs_synth_handler type, const char pass:[*]var,
-		       char pass:[**]save_fields);
-const char *tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);
-int tracefs_synth_raw_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
-const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
-const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
-const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
+int *tracefs_synth_create*(struct tracefs_synth pass:[*]_synth_);
+int *tracefs_synth_destroy*(struct tracefs_synth pass:[*]_synth_);
+int *tracefs_synth_echo_cmd*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
+bool *tracefs_synth_complete*(struct tracefs_synth pass:[*]_synth_);
+struct tracefs_hist pass:[*]*tracefs_synth_get_start_hist*(struct tracefs_synth pass:[*]_synth_);
+
+int *tracefs_synth_trace*(struct tracefs_synth pass:[*]_synth_,
+			enum tracefs_synth_handler _type_, const char pass:[*]_var_);
+int *tracefs_synth_snapshot*(struct tracefs_synth pass:[*]_synth_,
+			   enum tracefs_synth_handler _type_, const char pass:[*]_var_);
+int *tracefs_synth_save*(struct tracefs_synth pass:[*]_synth_,
+		       enum tracefs_synth_handler _type_, const char pass:[*]_var_,
+		       char pass:[**]_save_fields_);
+const char pass:[*]*tracefs_synth_get_name*(struct tracefs_synth pass:[*]_synth_);
+int *tracefs_synth_raw_fmt*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
+const char pass:[*]*tracefs_synth_show_event*(struct tracefs_synth pass:[*]_synth_);
+const char pass:[*]*tracefs_synth_show_start_hist*(struct tracefs_synth pass:[*]_synth_);
+const char pass:[*]*tracefs_synth_show_end_hist*(struct tracefs_synth pass:[*]_synth_);
 
 --
 
@@ -51,7 +51,7 @@ This event is triggered when a new task is scheduled on the CPU. By setting
 the "common_pid" of both events as the matching fields, the time between the
 two events is considered the wake up latency of that process. Use *TRACEFS_TIMESTAMP*
 as a field for both events to calculate the delta in nanoseconds, or use
-*TRACEFS_TIMESTAMP_USECS" as the compare fields for both events to calculate the
+*TRACEFS_TIMESTAMP_USECS* as the compare fields for both events to calculate the
 delta in microseconds. This is used as the example below.
 
 *tracefs_synth_create*() creates the synthetic event in the system. The synthetic events apply
@@ -70,11 +70,14 @@ a starting and ending event.
 *tracefs_synth_get_start_hist*() returns a struct tracefs_hist descriptor describing
 the histogram used to create the synthetic event.
 
+[verse]
+--
 enum tracefs_synth_handler {
-	TRACEFS_SYNTH_HANDLE_MATCH,
-	TRACEFS_SYNTH_HANDLE_MAX,
-	TRACEFS_SYNTH_HANDLE_CHANGE,
+	*TRACEFS_SYNTH_HANDLE_MATCH*,
+	*TRACEFS_SYNTH_HANDLE_MAX*,
+	*TRACEFS_SYNTH_HANDLE_CHANGE*,
 };
+--
 
 *tracefs_synth_trace*() Instead of doing just a trace on matching of the start and
 end events, do the _type_ handler where *TRACEFS_SYNTH_HANDLE_MAX* will do a trace
@@ -83,17 +86,17 @@ when the given variable _var_ hits a new max for the matching keys. Or
 the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
 *tracefs_synth_snapshot*() When the given variable _var_ is either a new max if
-_handler_ is TRACEFS_SYNTH_HANDLE_MAX_ or simpy changed if TRACEFS_SYNTH_HANDLE_CHANGE_
+_handler_ is *TRACEFS_SYNTH_HANDLE_MAX* or simply changed if *TRACEFS_SYNTH_HANDLE_CHANGE*
 then take a "snapshot" of the buffer. The snapshot moves the normal "trace" buffer
 into a "snapshot" buffer, that can be accessed via the "snapshot" file in the
 top level tracefs directory, or one of the instances.  _var_ changes. _var_ must be one of
 the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
 *tracefs_synth_save*() When the given variable _var_ is either a new max if
-_handler_ is TRACEFS_SYNTH_HANDLE_MAX_ or simpy changed if TRACEFS_SYNTH_HANDLE_CHANGE_
-then saven the given _save_fields_ list. The fields will be stored in the histogram
+_handler_ is *TRACEFS_SYNTH_HANDLE_MAX* or simpy changed if *TRACEFS_SYNTH_HANDLE_CHANGE*
+then save the given _save_fields_ list. The fields will be stored in the histogram
 "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
-_var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
+_var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
 *tracefs_synth_get_name*() returns the name of the synthetic event or NULL on error.
 The returned string belongs to the synth event object and is freed with the event
diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
index d7fc239..2b720c2 100644
--- a/Documentation/libtracefs-traceon.txt
+++ b/Documentation/libtracefs-traceon.txt
@@ -15,7 +15,7 @@ SYNOPSIS
 int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_trace_off*(struct tracefs_instance pass:[*]_instance_);
-int _tracefs_trace_on_get_fd_(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_trace_on_get_fd*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_trace_on_fd*(int _fd_);
 int *tracefs_trace_off_fd*(int _fd_);
 --
@@ -25,31 +25,31 @@ DESCRIPTION
 This set of functions can be used to check, enable or disable writing to the ring buffer in
 the given trace instance. The tracing is enabled when writing to the ring buffer is enabled.
 
-The _tracefs_trace_is_on()_ function checks if tracing is enabled for the given _instance_. If
+The *tracefs_trace_is_on()* function checks if tracing is enabled for the given _instance_. If
 _instance_ is NULL, the top instance is used.
 
-The _tracefs_trace_on()_ and _tracefs_trace_off()_ functions set the tracing in the _instance_
+The *tracefs_trace_on()* and *tracefs_trace_off()* functions set the tracing in the _instance_
 to enable or disable state. If _instance_ is NULL, the top instance is used.
 
-The _tracefs_trace_on_get_fd()_ function returns a file deascriptor to the "tracing_on" file from
+The *tracefs_trace_on_get_fd()* function returns a file descriptor to the "tracing_on" file from
 the given _instance_. If _instance_ is NULL, the top trace instance is used. The returned descriptor
 can be used for fast enabling or disabling the tracing of the instance.
 
-The _tracefs_trace_on_fd()_ and _tracefs_trace_off_fd()_ functions set the tracing state to enable
+The *tracefs_trace_on_fd()* and *tracefs_trace_off_fd()* functions set the tracing state to enable
 or disable using the given _fd_. This file descriptor must be opened for writing with
 *tracefs_trace_on_get_fd*(3) of the desired trace instance. These functions are faster than
 *tracefs_trace_on* and *tracefs_trace_off*.
 
 RETURN VALUE
 ------------
-The _tracefs_trace_is_on()_ function returns 0 if tracing is disable, 1 if it is enabled or
+The *tracefs_trace_is_on()* function returns 0 if tracing is disable, 1 if it is enabled or
 -1 in case of an error.
 
-The _tracefs_trace_on_get_fd()_ function returns a file descriptor to "tracing_on"
+The *tracefs_trace_on_get_fd()* function returns a file descriptor to "tracing_on"
 file for reading and writing, which must be closed wuth close(). In case of an error -1 is returned.
 
-The _tracefs_trace_on()_, _tracefs_trace_off()_, _tracefs_trace_on_fd()_ and
-_tracefs_trace_off_fd()_ functions return -1 in case of an error or 0 otherwise.
+The *tracefs_trace_on()*, *tracefs_trace_off()*, *tracefs_trace_on_fd()* and
+*tracefs_trace_off_fd()* functions return -1 in case of an error or 0 otherwise.
 
 EXAMPLE
 -------
diff --git a/Documentation/libtracefs-tracer.txt b/Documentation/libtracefs-tracer.txt
index 64d99c7..cca0e33 100644
--- a/Documentation/libtracefs-tracer.txt
+++ b/Documentation/libtracefs-tracer.txt
@@ -20,7 +20,7 @@ DESCRIPTION
 -----------
 *tracefs_tracer_set* enables a tracer in the given instance, defined by the
 _instance_ parameter. If _instance_ is NULL, then the top level instance is
-changed. If _tracer_ is set to _TRACFES_TRACER_CUSTOM_ then a const char pass[*]
+changed. If _tracer_ is set to *TRACFES_TRACER_CUSTOM* then a _name_
 string must be passed in as the third parameter, and that is written into the
 instance to enable the tracer with that name. This is useful for newer or
 custom kernels that contain tracers that are not yet identified by the
@@ -38,7 +38,7 @@ The currently defined enums that are accepted are:
 
 *TRACEFS_TRACER_NOP* :
 This is the idle tracer, which does nothing and is used to clear any
-active tarcer.
+active tracer.
 
 *TRACEFS_TRACER_FUNCTION* :
 Enables most functions in the kernel to be traced.
diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index 41544ab..aa8284a 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -21,28 +21,28 @@ DESCRIPTION
 -----------
 Various useful functions for working with trace file system.
 
-The _tracefs_tracers()_ function returns array of strings with the
+The *tracefs_tracers()* function returns array of strings with the
 names of supported tracer plugins, located in the given _tracing_dir_
 directory. This could be NULL or the location of the tracefs mount point
 for the trace systems of the local machine, or it may be a path to a copy
 of the tracefs directory from another machine. The last entry in the array
-as a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
+as a NULL pointer. The array must be freed with *tracefs_list_free()* API.
 
-The _tracefs_get_clock()_ function returns name of the current trace clock,
+The *tracefs_get_clock()* function returns name of the current trace clock,
 used in the given _instance_. If _instance_ is NULL, the clock of the main
 trace instance is returned. The returned string must be freed with free().
 
-The _tracefs_list_free()_ function frees an array of strings, returned by
-_tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
+The *tracefs_list_free()* function frees an array of strings, returned by
+*tracefs_event_systems()*, *tracefs_system_events()* and *tracefs_tracers()*
 APIs.
 
 RETURN VALUE
 ------------
-The _tracefs_tracers()_ returns array of strings. The last element in that
-array is a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
+The *tracefs_tracers()* returns array of strings. The last element in that
+array is a NULL pointer. The array must be freed with *tracefs_list_free()* API.
 In case of an error, NULL is returned.
 
-The _tracefs_get_clock()_ returns string, that must be freed with free(), or NULL
+The *tracefs_get_clock()* returns string, that must be freed with free(), or NULL
 in case of an error.
 
 EXAMPLE
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 161b75c..0123c0b 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -63,7 +63,7 @@ Trace helper functions:
 	int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_off*(struct tracefs_instance pass:[*]_instance_);
-	int _tracefs_trace_on_get_fd_(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_trace_on_get_fd*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_on_fd*(int _fd_);
 	int *tracefs_trace_off_fd*(int _fd_);
 
-- 
2.34.1

