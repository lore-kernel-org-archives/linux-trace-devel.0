Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40394 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731997AbeHCPEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 11:04:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15-v6so5362070wrs.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 06:08:37 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark-qt: In the Doxygen doc. add spacing after @brief and @param.
Date: Fri,  3 Aug 2018 16:07:59 +0300
Message-Id: <20180803130759.31858-3-y.karadz@gmail.com>
In-Reply-To: <20180803130759.31858-1-y.karadz@gmail.com>
References: <20180803130759.31858-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds a blank comment line after @brief, and after the last @param
in the Doxygen documentation of each  function. This makes it easier to read.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 847c10f..c829aa9 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -65,11 +65,13 @@ static bool init_thread_seq(void)
  *	  calling any other kshark function. If the session has been
  *	  initialized, this function can be used to obtain the session's
  *	  context.
+ *
  * @param kshark_ctx: Optional input/output location for context pointer.
  *		      If it points to a context, that context will become
  *		      the new session. If it points to NULL, it will obtain
  *		      the current (or new) session. The result is only
  *		      valid on return of true.
+ *
  * @returns True on success, or false on failure.
  */
 bool kshark_instance(struct kshark_context **kshark_ctx)
@@ -121,8 +123,10 @@ static void kshark_free_task_list(struct kshark_context *kshark_ctx)
  * @brief Open and prepare for reading a trace data file specified by "file".
  *	  If the specified file does not exist, or contains no trace data,
  *	  the function returns false.
+ *
  * @param kshark_ctx: Input location for context pointer.
  * @param file: The file to load.
+ *
  * @returns True on success, or false on failure.
  */
 bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
@@ -158,6 +162,7 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 
 /**
  * @brief Close the trace data file and free the trace data handle.
+ *
  * @param kshark_ctx: Input location for the session context pointer.
  */
 void kshark_close(struct kshark_context *kshark_ctx)
@@ -190,6 +195,7 @@ void kshark_close(struct kshark_context *kshark_ctx)
 /**
  * @brief Deinitialize kshark session. Should be called after closing all
  *	  open trace data files and before your application terminates.
+ *
  * @param kshark_ctx: Optional input location for session context pointer.
  *		      If it points to a context of a sessuin, that sessuin
  *		      will be deinitialize. If it points to NULL, it will
@@ -271,9 +277,11 @@ kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 /**
  * @brief Get an array containing the Process Ids of all tasks presented in
  *	  the loaded trace data file.
+ *
  * @param kshark_ctx: Input location for context pointer.
  * @param pids: Output location for the Pids of the tasks. The user is
  *		responsible for freeing the elements of the outputted array.
+ *
  * @returns The size of the outputted array of Pids in the case of success,
  *	    or a negative error code on failure.
  */
@@ -346,6 +354,7 @@ static bool kshark_show_event(struct kshark_context *kshark_ctx, int pid)
 
 /**
  * @brief Add an Id value to the filster specified by "filter_id".
+ *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param filter_id: Identifier of the filter.
  * @param id: Id value to be added to the filter.
@@ -377,6 +386,7 @@ void kshark_filter_add_id(struct kshark_context *kshark_ctx,
 
 /**
  * @brief Clear (reset) the filster specified by "filter_id".
+ *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param filter_id: Identifier of the filter.
  */
@@ -443,6 +453,7 @@ static void unset_event_filter_flag(struct kshark_context *kshark_ctx,
  *	  WARNING: Do not use this function if the advanced filter is set.
  *	  Applying the advanced filter requires access to prevent_record,
  *	  hence the data has to be reloaded using kshark_load_data_entries().
+ *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param data: Input location for the trace data to be filtered.
  * @param n_entries: The size of the inputted data.
@@ -681,10 +692,12 @@ static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
  *	  is updated according to the criteria provided by the filters. The
  *	  field "filter_mask" of the session's context is used to control the
  *	  level of visibility/invisibility of the filtered entries.
+ *
  * @param kshark_ctx: Input location for context pointer.
  * @param data_rows: Output location for the trace data. The user is
  *		     responsible for freeing the elements of the outputted
  *		     array.
+ *
  * @returns The size of the outputted data in the case of success, or a
  *	    negative error code on failure.
  */
@@ -749,9 +762,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
  * @brief Load the content of the trace data file into an array of
  *	  pevent_records. Use this function only if you need fast access
  *	  to all fields of the record.
+ *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param data_rows: Output location for the trace data. Use free_record()
  *	 	     to free the elements of the outputted array.
+ *
  * @returns The size of the outputted data in the case of success, or a
  *	    negative error code on failure.
  */
@@ -857,7 +872,9 @@ static const char *kshark_get_info(struct pevent *pe,
  * @brief Dump into a string the content of one entry. The function allocates
  *	  a null terminated string and returns a pointer to this string. The
  *	  user has to free the returned string.
+ *
  * @param entry: A Kernel Shark entry to be printed.
+ *
  * @returns The returned string contains a semicolon-separated list of data
  *	    fields.
  */
-- 
2.17.1
